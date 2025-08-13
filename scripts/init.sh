#!/bin/bash

# Check if Homebrew is installed
if ! command -v brew &> /dev/null
then
    echo "Homebrew is not installed. Installing it now..."
    
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Set Homebrew path (for macOS)
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
    eval "$(/opt/homebrew/bin/brew shellenv)"
    
    echo "Homebrew installation completed."
else
    echo "Homebrew is already installed."
fi

# Install SwiftFormat
echo "Installing SwiftFormat..."
brew install swiftformat

# Verify SwiftFormat installation
if command -v swiftformat &> /dev/null
then
    echo "SwiftFormat installation completed."
else
    echo "SwiftFormat installation failed."
    exit 1
fi

# Environment variable setup (for zsh, ~/.zshrc is updated; for bash, you might need to update ~/.bash_profile)
echo "Environment variables have been set. Please check your ~/.zshrc file."

# Create a pre-push hook
cp -f scripts/hooks/pre-push .git/hooks/pre-push && chmod +x .git/hooks/pre-push
echo "Pre-push hook has been set up."

# Clone env repository only if .env directory does not exist
if [ ! -d ".env" ]; then
    echo ".env folder not found. Cloning guita-env.."
    git clone https://github.com/ADA-4th-C3/guita-env .env
else
    echo ".env folder already exists. Skipping clone."
fi

# Create symbolic link for fastlane/.env if it does not exist
if [ ! -e "fastlane/.env" ]; then
    echo "Creating symbolic link for fastlane/.env..."
    ln -s ../.env/.env.fastlane fastlane/.env
else
    echo "fastlane/.env already exists. Skipping link creation."
fi