import express, { Request, Response } from 'express';
import { Pool, QueryResult } from 'pg';
import dotenv from 'dotenv';

// Load environment variables from .env file
dotenv.config();

// Check if DATABASE_URL is set
if (!process.env.DATABASE_URL) {
  console.warn('\x1b[33mWarning: DATABASE_URL environment variable is not set. Please check .env.example for the required format.\x1b[0m');
}

const app = express();
const port = process.env.PORT || 3000;

// PostgreSQL connection pool
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
});

// Function to check if a number is prime
const isPrime = (num: number): boolean => {
  if (num <= 1) return false;
  if (num <= 3) return true;
  if (num % 2 === 0 || num % 3 === 0) return false;

  for (let i = 5; i * i <= num; i += 6) {
    if (num % i === 0 || num % (i + 2) === 0) return false;
  }
  return true;
};

// Function to count primes up to a number
const countPrimes = (n: number): number => {
  let count = 0;
  for (let i = 1; i <= n; i++) {
    if (isPrime(i)) count++;
  }
  return count;
};

// Interface for prime cache result
interface PrimeCacheResult {
  prime_count: number;
}

// Function to check if the database is properly set up
const checkDatabaseSetup = async (): Promise<{ isConnected: boolean; hasTable: boolean; error?: string }> => {
  try {
    // Try to connect to the database
    const client = await pool.connect();

    try {
      // Check if the prime_cache table exists
      const result = await client.query(`
        SELECT EXISTS (
          SELECT FROM information_schema.tables
          WHERE table_name = 'prime_cache'
        );
      `);

      const hasTable = result.rows[0].exists;

      return {
        isConnected: true,
        hasTable
      };
    } finally {
      // Always release the client back to the pool
      client.release();
    }
  } catch (error) {
    console.error('Database connection error:', error);
    return {
      isConnected: false,
      hasTable: false,
      error: error instanceof Error ? error.message : 'Unknown database error'
    };
  }
};

// Function to get cached result or calculate and cache
const getPrimeCount = async (n: number, useCache: boolean): Promise<{ primeCount?: number; error?: string }> => {
  if (!useCache) {
    return { primeCount: countPrimes(n) };
  }

  // Check database setup first
  const dbStatus = await checkDatabaseSetup();

  if (!dbStatus.isConnected) {
    return {
      error: `Database connection failed: ${dbStatus.error}. Please check your database configuration.`
    };
  }

  if (!dbStatus.hasTable) {
    return {
      error: 'Database connection successful, but the prime_cache table does not exist. Please create the table manually with the following SQL:\n\nCREATE TABLE prime_cache (\n  number INTEGER PRIMARY KEY,\n  prime_count INTEGER NOT NULL\n);'
    };
  }

  try {
    // Check if result is in cache
    const result: QueryResult<PrimeCacheResult> = await pool.query(
      'SELECT prime_count FROM prime_cache WHERE number = $1',
      [n]
    );

    if (result.rows.length > 0) {
      console.log(`Cache hit for n=${n}`);
      return { primeCount: result.rows[0].prime_count };
    }

    // Calculate and cache the result
    console.log(`Cache miss for n=${n}, calculating...`);
    const primeCount = countPrimes(n);

    await pool.query(
      'INSERT INTO prime_cache (number, prime_count) VALUES ($1, $2)',
      [n, primeCount]
    );

    return { primeCount };
  } catch (error) {
    console.error('Database error:', error);
    return {
      error: `Database error: ${error instanceof Error ? error.message : 'Unknown error'}.`
    };
  }
};

// Health check endpoint
app.get('/health', (_req: Request, res: Response) => {
  res.status(200).json({ status: 'ok' });
});

// Readiness probe endpoint
app.get('/ready', (_req: Request, res: Response) => {
  res.status(200).json({ status: 'ready' });
});

// Main endpoint
app.get('/', (_req: Request, res: Response) => {
  res.json({
    message: 'Hello from Assignment 1 App!',
    timestamp: new Date().toISOString(),
    hostname: process.env.HOSTNAME || 'unknown'
  });
});

// Prime number calculation endpoint
app.get('/primes/:number', async (req: Request, res: Response) => {
  const number = parseInt(req.params.number, 10);
  const useCache = req.query.useCache === 'true';

  if (isNaN(number) || number < 1) {
    return res.status(400).json({ error: 'Please provide a valid positive number' });
  }

  try {
    const startTime = Date.now();
    const result = await getPrimeCount(number, useCache);
    const endTime = Date.now();

    // If there's an error and we're using cache, return the error immediately
    if (result.error && useCache) {
      return res.status(500).json({
        error: result.error,
        number,
        useCache,
        calculationTime: `${endTime - startTime}ms`,
        hostname: process.env.HOSTNAME || 'unknown'
      });
    }

    // Otherwise, return the result with the prime count
    res.json({
      number,
      primeCount: result.primeCount,
      useCache,
      calculationTime: `${endTime - startTime}ms`,
      hostname: process.env.HOSTNAME || 'unknown',
      ...(result.error ? { warning: result.error } : {})
    });
  } catch (error) {
    console.error('Error calculating primes:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
