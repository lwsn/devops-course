# Kubectl Commands Guide

This guide provides useful kubectl commands for working with Kubernetes. It includes information about namespaces, context management, and common operations.

## Namespace Management

### Student Namespaces

**IMPORTANT**: Each student is required to work in their own namespace unless otherwise instructed. Your namespace is your GitHub username in lowercase.

For example, if your GitHub username is `JohnDoe`, your namespace would be `johndoe`.

### Viewing and Setting Namespace

To view your current namespace:

```bash
kubectl config view --minify -o jsonpath='{..namespace}'
```

To view your current context:

```bash
kubectl config current-context
```

To set your namespace for the current context:

```bash
kubectl config set-context --current --namespace=<your-namespace>
```

For example:

```bash
kubectl config set-context --current --namespace=johndoe
```

### Working with Namespaces

All kubectl commands will use the namespace set in your current context by default. You can explicitly specify a different namespace for any command using the `--namespace` or `-n` flag:

```bash
kubectl get pods --namespace other-namespace
```

To list all namespaces:

```bash
kubectl get namespaces
```


## Resource Management

### Viewing Resources

To list all resources in your namespace:

```bash
kubectl get all
```

To list specific resource types:

```bash
kubectl get pods
kubectl get services
kubectl get deployments
kubectl get ingress
```

To get detailed information about a resource:

```bash
kubectl describe <resource-type> <resource-name>
```

For example:

```bash
kubectl describe pod my-pod
```

### Creating and Deleting Resources

To create a resource from a YAML file:

```bash
kubectl apply -f <file-path>
```

To delete a resource:

```bash
kubectl delete <resource-type> <resource-name>
```

To delete all resources of a specific type:

```bash
kubectl delete <resource-type> --all
```

### Debugging

To view logs of a pod:

```bash
kubectl logs <pod-name>
```

To view logs of a specific container in a pod:

```bash
kubectl logs <pod-name> -c <container-name>
```

To follow logs:

```bash
kubectl logs -f <pod-name>
```

To execute a command in a pod:

```bash
kubectl exec -it <pod-name> -- <command>
```

**Note**: For Alpine-based images, use `ash` instead of `bash`:

```bash
kubectl exec -it <pod-name> -- ash
```

## Port Forwarding

To forward a local port to a pod:

```bash
kubectl port-forward <pod-name> <local-port>:<pod-port>
```

For example:

```bash
kubectl port-forward my-pod 8080:80
```

## Context Management

To list all contexts:

```bash
kubectl config get-contexts
```

To switch to a different context:

```bash
kubectl config use-context <context-name>
```

## Labels and Selectors

To get resources with specific labels:

```bash
kubectl get <resource-type> -l <label-key>=<label-value>
```

For example:

```bash
kubectl get pods -l app=my-app
```

## Resource Quotas and Limits

To view resource quotas:

```bash
kubectl describe resourcequota
```

To view limit ranges:

```bash
kubectl describe limitrange
```

## ConfigMaps and Secrets

To view ConfigMaps:

```bash
kubectl get configmaps
```

To view Secrets:

```bash
kubectl get secrets
```

To view the data in a ConfigMap:

```bash
kubectl describe configmap <configmap-name>
```

## Service Accounts

To view service accounts:

```bash
kubectl get serviceaccounts
```

## Events

To view events in your namespace:

```bash
kubectl get events
```

## Shortcuts and Aliases

Here are some useful shortcuts for kubectl commands:

- `kubectl get` → `k get`
- `kubectl describe` → `k describe`
- `kubectl apply` → `k apply`
- `kubectl delete` → `k delete`
- `kubectl logs` → `k logs`
- `kubectl exec` → `k exec`

## Additional Resources

- [Kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Kubectl Reference Documentation](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands) 
