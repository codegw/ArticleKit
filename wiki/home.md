# ArticleKit Wiki

**ArticleKit** is a SwiftUI framework designed to create beautiful, accessible articles with minimal setup while providing extensive customization options. Built entirely in SwiftUI, ArticleKit offers native performance and seamless integration with your iOS applications. Simply provide your article data, and ArticleKit handles the complex layout, styling, and accessibility features automatically.

## Why use ArticleKit?

ArticleKit is designed for apps that need rich article content, whether you're building step-by-step guides, integrated blogs, documentation, or educational content. Instead of building complex layouts from scratch, ArticleKit provides a comprehensive system of content blocks, themes, and styling options that work together seamlessly.

### Key Benefits

- **Rich Content Support**: Text, images, code blocks, quotes, lists, and more
- **Dual Creation Methods**: Build articles with Swift structs or load from JSON  
- **Flexible Image Handling**: Support for both local assets and remote URLs
- **Professional Styling**: Five predefined themes plus full customization options

## Core Philosophy

ArticleKit follows three core principles:

1. **Simplicity**: Create rich articles with minimal code - no complex layout logic required
2. **Flexibility**: Customize every aspect of appearance while maintaining consistency  
3. **Accessibility**: Ensure content is accessible to all users automatically

## Quick Start Example

```swift
import ArticleKit

let article = Article(
    id: "getting-started",
    header: [
        .heroImage(.remote(url: URL(string: "https://example.com/hero.jpg")!)),
        .title("Welcome to ArticleKit"),
        .author("Your Name", bio: "iOS Developer")
    ],
    content: [
        .heading("Introduction"),
        .body("ArticleKit makes creating beautiful articles effortless..."),
        .image(.asset(name: "screenshot"), caption: "ArticleKit in action")
    ]
)

struct ContentView: View {
    var body: some View {
        ArticleView(article: article)
            .articleStyle(.modern)
    }
}
```

## Architecture Overview

### Content Blocks
ArticleKit uses a block-based system where articles are composed of individual content blocks:
- **Header Blocks**: Hero images, titles, author info, publication dates
- **Content Blocks**: Headings, paragraphs, images, quotes, lists, code blocks

### Styling System  
A comprehensive theming system with:
- **Themes**: Color schemes (dynamic, sepia, midnight, custom)
- **Typography**: Font configurations (serif, sans-serif, monospace, custom)
- **Layout**: Image presentation and author display styles

### Data Sources
Flexible content creation:
- **Swift-based**: Type-safe article creation with structs and enums
- **JSON-based**: Load articles from files

## Documentation

### Essential Guides
- [Getting Started](getting-started.md) - Installation and first article
- [Creating Articles](creating-articles.md) - Swift and JSON article creation
- [Styling Guide](styling-guide.md) - Themes, fonts, and customization

### Reference Materials  
- [API Functions](api-functions.md) - Complete API documentation
