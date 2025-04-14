-- Create a table to cache prime number calculations
CREATE TABLE IF NOT EXISTS prime_cache (
    number INTEGER PRIMARY KEY,
    prime_count INTEGER NOT NULL,
    calculated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create an index on the calculated_at column for potential cleanup operations
CREATE INDEX IF NOT EXISTS idx_prime_cache_calculated_at ON prime_cache(calculated_at);

-- Add a comment to the table
COMMENT ON TABLE prime_cache IS 'Cache for prime number calculations';
