# AWS CLI

## ⚠️ ESSENTIAL: AWS SSO Login

**IMPORTANT**: Before you can use any AWS commands, you must log in using SSO:

```bash
aws sso login --profile kumpan-devops
```

This command:
- Opens your browser to the AWS SSO login page
- Authenticates you with your credentials
- Obtains temporary AWS credentials
- Stores these credentials locally for use with the AWS CLI

**You must run this command before you can access any AWS resources.** The credentials obtained through this process are temporary and will expire after a certain period (typically 8-12 hours), at which point you'll need to run the command again.

## AWS Configuration

Add the following to your `~/.aws/config` file to set up SSO access to the course AWS account:

```ini
[sso-session btlc]
sso_region = eu-north-1
sso_start_url = https://btlc.awsapps.com/start

[profile kumpan-devops]
sso_session = btlc
sso_account_id = 289831833738
sso_role_name = AdministratorAccess
region = eu-north-1
output = yaml
cli_pager = cat
```

This configuration:
- Sets up SSO access to the BTLC AWS account
- Creates a profile named `kumpan-devops` with AdministratorAccess role
- Configures the eu-north-1 region as default
- Sets YAML as the default output format
- Disables the AWS CLI pager for better terminal integration

### Using AWS_PROFILE Environment Variable

Instead of specifying the profile with the `--profile` flag in each command, you can set the `AWS_PROFILE` environment variable:

```bash
# Set the environment variable for the current session
export AWS_PROFILE=kumpan-devops

# Now you can run AWS commands without the --profile flag
aws sts get-caller-identity
```

This is particularly useful in scripts or when you want to avoid typing the profile name repeatedly. You can also add this to your shell's configuration file (like `.bashrc` or `.zshrc`) to make it permanent.

## Kubernetes Access

To get kubectl access to the EKS cluster, run:

```bash
aws eks update-kubeconfig --region eu-north-1 --name kumpan-course-eks --alias kumpan-devops --profile kumpan-devops
```

This command:
- Updates your kubectl configuration to access the EKS cluster
- Creates a context named `kumpan-devops` for easy switching
- Uses the `kumpan-devops` AWS profile for authentication
- Sets the region to eu-north-1 

## AWS SSO/Identity Center vs. Access Keys

AWS SSO (now called AWS IAM Identity Center) and access keys are two different methods for authenticating to AWS services:

### AWS SSO/Identity Center
- **Purpose**: Provides centralized access management across multiple AWS accounts and business applications
- **How it works**: Uses federation with your organization's identity provider (like Active Directory, Okta, etc.)
- **Benefits**:
  - Single sign-on experience
  - Centralized user management
  - Temporary credentials that automatically expire
  - No need to manage long-term access keys
  - Easier compliance with security policies
- **Use case**: Ideal for organizations with multiple AWS accounts and users who need different levels of access

### Access Keys
- **Purpose**: Long-term credentials for programmatic access to AWS services
- **How it works**: Consists of an access key ID and secret access key that are stored in your local environment
- **Benefits**:
  - Simple to set up and use
  - Works well for automated scripts and CI/CD pipelines
  - No additional infrastructure required
- **Drawbacks**:
  - Credentials don't expire unless manually rotated
  - Higher security risk if compromised
  - Difficult to manage across multiple accounts
  - No integration with corporate identity systems

### Best Practices
- Use AWS SSO/Identity Center for human users and interactive sessions
- Use access keys only for automated systems where SSO isn't practical
- Consider using OIDC instead of access keys for CI/CD pipelines
- Regularly rotate access keys and use the principle of least privilege 
