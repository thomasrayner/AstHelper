# Contributing to AstHelper

Thank you for your interest in contributing to AstHelper! This document provides guidelines and instructions for contributing to this project.

## Getting Started

1. Fork the repository on GitHub
2. Clone your fork locally
3. Set up the project on your local machine
4. Create a new branch for your contribution

## Development Environment Setup

1. Ensure you have PowerShell 5.1 or higher installed
2. Clone the repository:
   ```
   git clone https://github.com/yourusername/AstHelper.git
   cd AstHelper
   ```
3. Import the module for development:
   ```powershell
   Import-Module ./AstHelper.psd1 -Force
   ```

## Making Changes

When making changes to the module, please follow these guidelines:

### Code Style

- Follow the PowerShell best practices and style guidelines
- Use consistent indentation (preferably tabs as per existing code)
- Use descriptive variable and function names
- Include proper error handling in functions

### Documentation

- Update or add comments in the code as needed
- Update function help documentation using PowerShell comment-based help
- All public functions should include:
  - Synopsis and Description
  - Parameter descriptions
  - Multiple examples
  - Notes section with author information
  - Links to relevant resources

### Testing

- Test your changes thoroughly
- If adding new functionality, include examples of how it works
- Consider adding Pester tests if appropriate

## Pull Requests

1. Update the README.md with details of changes if appropriate
2. Update the version number in AstHelper.psd1 following [SemVer](https://semver.org/) conventions
3. Submit a pull request with a clear description of the changes and their purpose
4. Include any relevant issue numbers in the PR description

## Feature Requests and Bug Reports

- Use the GitHub issue tracker to submit feature requests and bug reports
- Clearly describe the issue/feature and provide steps to reproduce if applicable
- For bug reports, include the PowerShell version and environment information

## Code of Conduct

Please be respectful and inclusive in your communications. We aim to foster an open and welcoming environment.

## License

By contributing to AstHelper, you agree that your contributions will be licensed under the project's MIT License.