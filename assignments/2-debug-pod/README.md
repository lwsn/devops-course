# 🛠️ Assignment 2: Debug a Broken Pod

## 🎯 Purpose
This assignment aims to train your ability to debug a Pod in Kubernetes by using common tools like kubectl, inspecting configurations, analyzing logs, and interacting with the container.

## 📦 Scenario
You have a Pod that is not working correctly. It is designed with several intentional errors, in increasing order of difficulty. Your task is to debug and fix the errors in order. The more errors you identify and solve, the higher grade you can achieve.

## 🛠️ Debugging Tools
Here are some tools that may be useful for debugging:
- `kubectl describe pod` - Display detailed information about a Pod
- `kubectl logs` - View logs from a Pod or container
- `kubectl exec` - Run commands in a container
- `kubectl get` - List and view resources
- `kubectl edit` - Edit resources directly
- `kubectl get events` - View cluster events

## 🧩 Assignment
Your task is to identify and fix the errors in the Pod. Each error you find and solve gives you points. Keep in mind that:
- The errors are of increasing difficulty
- Some errors may be related to configuration
- Other errors may involve runtime issues
- Some errors may require interaction with the container

## ✅ Definition of Done
To successfully complete this assignment, you must ensure:
- The Pod is in `Running` state and runs without crashing for at least 2 minutes
- The `/` route returns the welcome page
- The `/greeting` route returns a greeting message from the database
- The `/download` route successfully returns a random file from the downloads directory

## 🔧 Solution
There are multiple valid approaches to solving the issues in this assignment:
- Rewriting code and rebuilding the application
- Editing the Kubernetes YAML configurations
- Modifying files inside the running pod using `kubectl exec`
- Creating new resources or modifying existing ones

All solutions that achieve the Definition of Done criteria are acceptable. If you discover multiple ways to solve a particular issue, I'd be happy to discuss the pros and cons of each approach. This flexibility encourages creative problem-solving and deeper understanding of Kubernetes concepts.

## 💡 Tips
- Use `kubectl describe` to get detailed information about the Pod
- Check logs with `kubectl logs`
- Use `kubectl exec` to interact with the container
- Don't forget to check the Pod's configuration in YAML format
- Remember to debug systematically and document your steps
- **Note:** For Alpine-based images, use `ash` instead of `bash` with `kubectl exec` (e.g., `kubectl exec -it <pod-name> -- ash`).

**Note:** To generate the yaml files that have deployed the faulty service locally, run `sed -i "s/YOUR-NAMESPACE-HERE/${name}/g" *.yaml` in the `k8s` directory.
