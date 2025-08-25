<div align="center">
  <img width="200" height="200" src="assets/ArticleKit.png” alt=“ArticleKit logo">
  <h1>ArticleKit</h1>
  <p>
    A simple SwiftUI framework for creating rich and readable articles with customisable styling support.
  </p>
  <div align="center">
    <img src="https://img.shields.io/badge/Swift-6.1-orange.svg" alt="Swift Version">
    <img src="https://img.shields.io/badge/iOS-16.0+-blue.svg" alt="iOS Version">
    <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License">
  </div>
</div>

--

## Features

- **Rich Content Blocks**: Support for text, images, quotes, code blocks, lists, and more
- **Flexible Styling**: Pre-built themes (classic, modern, reading, developer) with additional customisation
- **JSON Support**: Load articles from JSON with clean, readable format
- **Accessibility First**: Built-in VoiceOver support and accessibility labels

## Installation

### Swift Package Manager

Add ArticleKit to your project through Xcode:

1. Go to **File → Add Package Dependencies**
2. Enter the repository URL: `https://github.com/codegw/ArticleKit`
3. Select **Up to Next Major Version** and click **Add Package**

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/codegw/ArticleKit", from: "1.0.0")
]
```

## Quick Start

### Basic Usage

```swift
import SwiftUI
import ArticleKit

struct ContentView: View {
    let article = Article(
        header: [
            .heroImage("hero-image"),
            .title("Welcome to ArticleKit"),
            .author("John “Appleseed, bio: "iOS Developer", avatarImage: “john-avatar")
        ],
        content: [
            .heading("Getting Started"),
            .body("ArticleKit makes it easy to create beautiful, readable articles"),
            .image("example-image", caption: "A beautiful SwiftUI interface")
        ]
    )
    
    var body: some View {
        ArticleView(article: article)
            .articleStyle(.modern)
    }
}
```

### Loading from JSON

```swift
// Load from bundle
let article = try Article.fromBundle(resourceName: "my-article")

// Load from JSON string
let jsonString = """
{
  "header": [
    { "type": "title", "title": "My Article" },
    { "type": "author", "author": { "name": "John Appleseed” } }
  ],
  "content": [
    { "type": "body", "body": "Article content here..." }
  ]
}
"""
let article = try Article.from(jsonString: jsonString)
```

## Content Blocks

### Header Blocks

- **Hero Image**: `.heroImage("image-name")`
- **Title**: `.title("Article Title")`
- **Subtitle**: `.subtitle("Article Subtitle")`
- **Author**: `.author("Name", bio: "Bio", avatarImage: "avatar")`
- **Date**: `.date(Date())`
- **Topics**: `.topics(["iOS", "SwiftUI"])`

### Content Blocks

- **Headings**: `.heading("Section Title")`
- **Body Text**: `.body("Paragraph content")`
- **Images**: `.image("image-name", caption: "Caption")`
- **Quotes**: `.quote("Quote text", author: "Attribution")`
- **Code**: `.codeBlock("print('Hello')", language: "swift")`
- **Lists**: `.listItem(["Item 1", "Item 2"])`, `.numberedListItem([...])`
- **Dividers**: `.divider`

## Styling

### Pre-built Styles

```swift
ArticleView(article: article)
    .articleStyle(.classic)     // Traditional serif styling
    .articleStyle(.modern)      // Clean, contemporary look
    .articleStyle(.reading)     // Sepia theme for comfortable reading
    .articleStyle(.developer)   // Dark theme with monospace fonts
```

### Custom Styling

```swift
let customStyle = ArticleStyle(
    theme: .custom(ArticleThemeConfiguration(
        backgroundColor: .black,
        textColor: .white,
        accentColor: .blue,
        secondaryColor: .gray,
        cardBackground: .gray
    )),
    imageStyle: .modern,
    headerImageStyle: .classic,
    fontStyle: .serif,
    authorStyle: .detail
)

ArticleView(article: article)
    .articleStyle(customStyle)
```

## JSON Format

ArticleKit uses a simple JSON format:

```json
{
  "header": [
    {
      "type": "heroImage",
      "heroImage": "hero-image"
    },
    {
      "type": "title",
      "title": "Article Title"
    },
    {
      "type": "author",
      "author": {
        "name": "Author Name",
        "bio": "Author Bio",
        "avatarImage": "avatar"
      }
    }
  ],
  "content": [
    {
      "type": "heading",
      "heading": "Section Heading"
    },
    {
      "type": "body",
      "body": "Article content goes here..."
    },
    {
      "type": "image",
      "image": {
        "imageName": "example",
        "caption": "Image caption"
      }
    }
  ],
  "date": "2024-08-25T10:30:00Z",
  "topic": "Development"
}
```

## Contributing

Contributions are welcome! 

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

