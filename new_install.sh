#!/bin/bash

# Fonction pour vérifier si une commande existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Vérification et installation de Homebrew
if ! command_exists brew; then
    echo "Installation de Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Ajout de Homebrew au PATH
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew est déjà installé"
fi

# Installation des paquets via Homebrew
echo "Installation des paquets via Homebrew..."
brew install node
brew install --cask visual-studio-code
brew install php
brew install gcc

# Vérification et installation de Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installation de Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    # Sauvegarde de l'ancien .zshrc si nécessaire
    if [ -f "$HOME/.zshrc.pre-oh-my-zsh" ]; then
        mv "$HOME/.zshrc.pre-oh-my-zsh" "$HOME/.zshrc.backup"
    fi
else
    echo "Oh My Zsh est déjà installé"
fi

# Ajout des alias dans .zshrc
echo "Ajout des alias dans .zshrc..."
cat << 'EOF' >> "$HOME/.zshrc"

# Alias personnalisés
alias ohmyzsh="nano ~/.oh-my-zsh"
alias zshconfig="nano ~/.zshrc"
alias pubip4="dig +short txt ch whoami.cloudflare @1.0.0.1"
alias pubip6="dig -6 TXT +short o-o.myaddr.l.google.com @ns1.google.com"
alias update="brew update"
alias upgrade="brew upgrade"
EOF

echo "Alias ajoutés avec succès"

# Vérification des installations
echo "Vérification des versions installées:"
echo "Node version: $(node --version)"
echo "VSCode installé: $(command_exists code && echo "Oui" || echo "Non")"

# Recharger le shell
echo "Configuration terminée. Rechargement du shell..."
exec zsh -l
