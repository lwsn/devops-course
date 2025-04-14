# Assignment 1: Docker and Kubernetes Basics

## Good to Know
- All documentation can be found in the `docs/` directory
- All scripts are expected to be executed from the assignment directory
- The application is designed for learning purposes and demonstrates scalability concepts

In this assignment, you will gain practical experience working with Docker and Kubernetes. You will take a simple Node.js application written in TypeScript, containerize it, and then deploy it to a Kubernetes cluster.

## Objectives
- Create a Docker container for a TypeScript Node.js application
- Deploy the application to Kubernetes
- Configure network traffic with Services and Ingress
- Perform load testing on the application

## Prerequisites
- Access to a Kubernetes cluster
- Docker installed on your computer
- kubectl configured against the cluster

## Application Features
The application provides the following endpoints:
- `/health` - Health check endpoint
- `/ready` - Readiness probe endpoint
- `/` - Main endpoint that returns a greeting message
- `/primes/:number` - Calculates the number of primes up to the specified number
  - Query parameter: `useCache=true|false` (default: false)
  - If caching is enabled, results are stored in a PostgreSQL database

## Assignment Description

### Part 1: Containerization
1. Examine the TypeScript Node.js application in the `app` folder
2. Create a Dockerfile that:
   - Uses an appropriate Node.js base image
   - Builds the TypeScript code
   - Copies the application code
   - Installs dependencies
   - Exposes the correct port
   - Configures the start command

### Part 2: Kubernetes Deployment
1. Create the following Kubernetes resources in the `k8s` folder:
   - Deployment (at least 2 replicas)
   - Service (expose port 80)
   - Ingress (configure your domain and TLS)
   - PostgreSQL deployment (if using caching)
   - Database initialization job (if using caching)

   > **Note:** Having a basic grasp on [Kubernetes annotations](docs/ingress-annotations.md) is useful for getting certificates and DNS set up properly with cert-manager and external-dns.
   
   > **Note:** For more information about Kubernetes networking and services, see the [Kubernetes Networking](docs/kubernetes-networking.md) documentation.

2. Verify that:
   - The application is accessible via your domain
   - HTTPS works correctly
   - Load balancing works between pods
   - The prime calculation endpoint works with and without caching

### Part 3: Database Connection
1. Create a Kubernetes Secret to store your database credentials:
   ```yaml
   apiVersion: v1
   kind: Secret
   metadata:
     name: assignment1
     namespace: YOUR-NAME-HERE
   type: Opaque
   stringData:
     DATABASE_URL: "postgresql://YOUR-USERNAME:YOUR-PASSWORD@postgres-postgresql.db.svc.cluster.local:5432/YOUR-DATABASE"
   ```

2. Update your Deployment to use the Secret:
   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: assignment1-app
     namespace: YOUR-NAME-HERE
   spec:
     # ... other deployment specs ...
     template:
       spec:
         containers:
         - name: assignment1-app
           # ... other container specs ...
           env:
           - name: DATABASE_URL
             valueFrom:
               secretKeyRef:
                 name: assignment1
                 key: DATABASE_URL
   ```

3. Apply the Secret and updated Deployment:
   ```bash
   kubectl apply -f k8s/secret.yaml
   kubectl apply -f k8s/deployment.yaml
   ```

4. Verify that your application can connect to the database by testing the `/primes/:number?useCache=true` endpoint.

### Part 4: Load Testing
1. Use the provided load testing script to test your deployment

2. Experiment with scaling your deployment:
   - Try increasing the number of replicas with `kubectl scale deployment --replicas 5 deployment-name`
   - Run the load test again and observe if the application can handle more requests per second

## Definition of Done
Your assignment is considered complete when:
- You can access your app on `assignment1.namespace.kumpan.btlc.dev` with a valid TLS certificate
- You can successfully scale the application using `kubectl scale deployment --replicas NUMBER assignment1`
- The `/primes/:number` endpoint works correctly with and without caching

## Tips
- Use `kubectl logs` and `kubectl describe` for troubleshooting
- Check that your resource limits are appropriately set
- Test your application locally with Docker before deploying to Kubernetes
- Use the provided database setup script to initialize the PostgreSQL database
- For local development, use `npm run dev` to run the application with ts-node 

## NOTES
The application is not designed to be useful in any other mean than to be a scalable application, but the student is encouraged to write down any improvements that can be made to the application.
