# Kubernetes Networking

## Service Types

Kubernetes Services provide an abstraction layer for accessing pods. There are several types of Services:

### ClusterIP (Default)
- Exposes the service on a cluster-internal IP
- Only accessible within the cluster
- Used for internal communication between components

### NodePort
- Exposes the service on each Node's IP at a static port
- Accessible from outside the cluster via `<NodeIP>:<NodePort>`
- Limited to ports in the range 30000-32767

### LoadBalancer
- Exposes the service externally using a cloud provider's load balancer
- Automatically assigns an external IP address
- Most suitable for production workloads that need external access

### ExternalName
- Maps a service to a DNS name
- Used for services outside the cluster
- No proxying is involved, just DNS resolution

## Kubernetes DNS

Kubernetes provides DNS-based service discovery. Services and pods can be addressed using DNS names following this pattern:

```
<service-name>.<namespace>.svc.cluster.local
```

For example:
- `postgres-postgresql.db.svc.cluster.local` refers to the `postgres-postgresql` service in the `db` namespace
- `assignment1-app.eeemil.svc.cluster.local` refers to the `assignment1-app` service in the `eeemil` namespace

Within the same namespace, you can use just the service name:
- `postgres-postgresql` (if you're in the `db` namespace)
- `assignment1-app` (if you're in the `eeemil` namespace)

## Database Access

For this course, each student has their own user and personal database in the PostgreSQL instance. You can connect to it using:

```
Host: postgres-postgresql.db.svc.cluster.local
Port: 5432
Database: <your-database-name>
Username: <your-username>
Password: <your-password>
```

If you've lost your credentials, please contact eeemil to retrieve them.

## Example: Connecting to PostgreSQL from a Pod

If your application needs to connect to PostgreSQL, use the following connection string format:

```
postgresql://<username>:<password>@postgres-postgresql.db.svc.cluster.local:5432/<database-name>
```

For example:
```
postgresql://eeemil:password123@postgres-postgresql.db.svc.cluster.local:5432/eeemil
``` 
