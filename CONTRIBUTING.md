# Contributing to ArticleKit

Thank you for your interest in contributing to ArticleKit! This document provides guidelines and information for contributing to the project.

## Code of Conduct

We expect all contributors to adhere to the [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## How to Report Issues

Before opening a new issue, please check the [issue tracker](https://github.com/codegw/ArticleKit/issues) to avoid duplicates.

When filing a bug report, include:

- **Clear title** describing the issue
- **Detailed description** of the problem
- **Steps to reproduce** the issue
- **Expected vs actual behavior**
- **Environment details**:
  - iOS version
  - Xcode version  
  - ArticleKit version
  - Device model (if relevant)
- **Code sample** demonstrating the issue

## How to Propose Features

Feature requests are welcome! Please:

1. Check existing [feature requests](https://github.com/codegw/ArticleKit/issues?q=state%3Aopen%20label%3Aenhancement)
2. Open a new issue with the "enhancement" label
3. Provide detailed description including:
   - Use case and motivation
   - Proposed API (if applicable)
   - Alternative solutions considered
   - Impact on existing functionality

## Submitting Code Changes

1. Fork the repository
   ```bash
   git clone https://github.com/yourusername/ArticleKit.git
   cd ArticleKit
   ```

2. Create development branch
   ```bash
   git checkout -b feature/my-feature-name
   ```

3. Make your changes

4. Commit with a clear message, such as:
    ```bash
    feat: add support for remote image caching
    fix: resolve memory leak in ArticleView
    docs: update API reference for ImageSource
    test: add unit tests for JSON serialization
    refactor: improve ArticleBlock rendering performance
    ```
5. Push and open a Pull Request against 

## Development Setup
   - Ensure Xcode 16.0+ is installed
   - iOS 16+ deployment target
   - Open `ArticleKit.xcodeproj` or use Swift Package Manager
   
## Updating Documentation

Documentation improvements are welcome! You can:

- Update the README.md with installation, usage, or examples
- Contribute to the Wiki for tutorials
- Add or modify project assets in the assets/ folder (e.g., images, screenshots)
- Please ensure all docs remain clear, concise, and consistent with the project’s tone.

## License

By contributing to ArticleKit, you agree that your contributions will be licensed under the same MIT License that covers the project.
