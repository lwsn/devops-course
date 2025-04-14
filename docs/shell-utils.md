# Shell Utilities

This document outlines recommended shell tools and extensions to enhance your experience during this course.

## Zsh with Oh My Zsh

For this course, I recommend using [Zsh](https://www.zsh.org/) (Z shell) with the [Oh My Zsh](https://ohmyz.sh/) framework. Zsh is a powerful shell that offers extensive customization options, while Oh My Zsh makes it easy to manage these customizations.

### Installation

#### Zsh
- **macOS**: Zsh is the default shell since macOS Catalina (10.15)
- **Ubuntu/Debian**: `sudo apt install zsh`

#### Oh My Zsh
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Recommended Plugins

#### kubectl
The [kubectl plugin](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kubectl) for Oh My Zsh provides useful aliases and functions for working with Kubernetes:

- `k` - Alias for `kubectl`
- `kgp` - `kubectl get pods`
- `kgs` - `kubectl get services`
- `kns` - Switch namespace, e.g. `kns default` (switches to default workspace). In this course, you should be working in a namespace with the same name as your github user

To enable this plugin, add `kubectl` to your plugins list in `~/.zshrc`:
```bash
plugins=(... kubectl)
```

#### aws
The [aws plugin](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/aws) for Oh My Zsh provides useful aliases, tab completion and functions for working with AWS:

- `asp PROFILE-NAME` - Set AWS profile
- `asp kumpan-devops login` - logs in to AWS SSO with the kumpan-devops profile

For more information about AWS profiles and SSO configuration, see [AWS CLI documentation](aws-cli.md).

To enable this plugin, add `aws` to your plugins list in `~/.zshrc`:
```bash
plugins=(... aws)
```

## Fuzzy Finder (fzf)

[fzf](https://github.com/junegunn/fzf) is a general-purpose command-line fuzzy finder that significantly improves your command-line experience:

- Fuzzy search through command history
- Fuzzy search through files and directories
- Fuzzy search through git commits and branches
- Integration with various tools like kubectl, docker, etc.

### Installation

#### macOS
```bash
brew install fzf
$(brew --prefix)/opt/fzf/install
```

#### Ubuntu/Debian
```bash
sudo apt install fzf
```

## Additional Tips

- Consider using [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) for fish-like autosuggestions
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) provides syntax highlighting for commands

These tools will significantly improve your productivity when working with Kubernetes and AWS during this course. 
