# Ingress Annotations in Kubernetes

## What are Annotations?

Annotations in Kubernetes are key-value pairs that provide additional metadata to resources. Unlike labels, annotations are not used for identifying and selecting objects but rather for storing non-identifying auxiliary data that tools and libraries can use.

Annotations can be used to:
- Store build, release, or image information
- Attach timestamps
- Store information about the person or tool responsible for the resource
- Provide hints to controllers about how to handle the resource

## How Annotations Work with Ingress Controllers

Ingress controllers use annotations to configure how they handle incoming traffic. These annotations can control various aspects of the ingress behavior, such as:

- SSL/TLS configuration
- Load balancing algorithms
- Custom headers
- Rate limiting
- Rewrite rules
- And much more

## External-DNS Annotations

External-DNS is a Kubernetes add-on that synchronizes exposed Kubernetes Services and Ingresses with DNS providers. It allows you to control DNS records dynamically using Kubernetes resources.

### Key External-DNS Annotations

- `external-dns.alpha.kubernetes.io/hostname`: Specifies the hostname for the DNS record
- `external-dns.alpha.kubernetes.io/ttl`: Sets the TTL (Time To Live) for the DNS record
- `external-dns.alpha.kubernetes.io/target`: Overrides the target for the DNS record

### Example Usage

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
  annotations:
    external-dns.alpha.kubernetes.io/hostname: example.domain.com
    external-dns.alpha.kubernetes.io/ttl: "300"
spec:
  # ... rest of ingress spec
```

## Cert-Manager Annotations

Cert-Manager is a Kubernetes add-on that automates the management and issuance of TLS certificates from various issuing sources. It will ensure certificates are valid and up to date, and will attempt to renew certificates at a configured time before expiry.

### Key Cert-Manager Annotations

- `cert-manager.io/cluster-issuer`: Specifies which ClusterIssuer to use for obtaining the certificate
- `cert-manager.io/issuer`: Specifies which Issuer to use (namespace-scoped)
- `cert-manager.io/common-name`: Overrides the CommonName field in the certificate
- `cert-manager.io/duration`: Specifies the duration for which the certificate should be valid
- `cert-manager.io/renew-before`: Specifies how long before expiry the certificate should be renewed

### Example Usage

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
spec:
  tls:
  - hosts:
    - example.domain.com
    secretName: example-tls
  # ... rest of ingress spec
```

## ClusterIssuers in Our Setup

Our cluster has two ClusterIssuers configured for Let's Encrypt:

### letsencrypt-http01

This ClusterIssuer uses the HTTP-01 challenge method to validate domain ownership. It works by:

1. Cert-Manager creates a temporary HTTP endpoint on your domain
2. Let's Encrypt makes a request to this endpoint
3. If the request succeeds, Let's Encrypt knows you control the domain

**Advantages:**
- Works with any DNS provider
- Simpler to set up

**Disadvantages:**
- Requires your service to be publicly accessible
- May not work if you have certain security policies in place

### letsencrypt-dns01

This ClusterIssuer uses the DNS-01 challenge method to validate domain ownership. It works by:

1. Cert-Manager creates a TXT record in your DNS zone
2. Let's Encrypt checks for this record
3. If the record exists with the correct value, Let's Encrypt knows you control the domain

**Advantages:**
- Works even if your service is not publicly accessible
- More secure as it doesn't require exposing HTTP endpoints

**Disadvantages:**
- Requires API access to your DNS provider
- More complex to set up

## Further Information

For more detailed information about our setup, you can explore:

- Cert-Manager configuration: `terraform/aws/live/accounts/kumpan-kurs/pod-identity/cert-manager/terragrunt.hcl`
- External-DNS configuration: `terraform/aws/live/accounts/kumpan-kurs/pod-identity/external-dns/terragrunt.hcl`
- Helm values for cert-manager: `helm/cert-manager/values.yaml`
- Helm values for external-dns: `helm/external-dns/values.yaml`

These files contain the specific configurations used in our cluster and can provide insights into how these components are set up. 
