# Creating Articles

ArticleKit supports two primary methods for creating articles, using Swift structs or JSON. This flexibility allows you to choose the approach that best fits your workflow.

## Swift-Based Article Creation

### Basic Article Structure

```swift
let article = Article(
    id: "unique-article-id",     // Required unique identifier
    header: [HeaderBlock],       // Header content blocks
    content: [ArticleBlock],     // Main content blocks
    date: Date?,                 // Optional publication date
    topic: String?               // Optional topic category
)
```

### Complete Example

```swift
let articleKitIntroduction = Article(
    id: "articlekit-introduction",
    header: [
        .title("ArticleKit for SwiftUI"),
        .subtitle("Build beautiful, readable articles with minimal setup"),
        .topics(["SwiftUI", "iOS", "Framework", "Open Source"])
    ],
    content: [
        .heading("What is ArticleKit?"),
        .body("ArticleKit is a SwiftUI framework designed to create simple and readable articles with minimal setup"),
        .heading("Core Features"),
        .numberedListItem([
            "Rich content blocks: headings, body text, images, quotes, code blocks, and lists",
            "Flexible image sources supporting both local assets and remote URLs",
            "Multiple predefined styles: classic, modern, newspaper, reading, and developer",
            "Complete JSON serialization support for dynamic content",
            "Built-in accessibility features with VoiceOver support",
        ]),
        .heading("Quick Start"),
        .body("Creating your first article takes just a few lines of code:"),
        .quote("ArticleKit turns complex article layouts into simple, declarative code that just works.", 
               author: "iOS Developer Review"),
        .divider
    ]
)
```

## Image Sources

ArticleKit supports both local assets and remote URLs:

### Local Assets
```swift
// Hero image from app bundle
.heroImage(.asset(name: "swift-tutorial-hero"))

// Author avatar from assets
.author("John Doe", avatarImage: .asset(name: "john-avatar"))

// Content image from assets
.image(.asset(name: "xcode-screenshot"), caption: "Xcode interface")
```

### Remote URLs
```swift
// Hero image from remote URL
.heroImage(.remote(url: URL(string: "https://example.com/hero.jpg")!))

// Author avatar from remote URL
.author("John Doe", avatarImage: .remote(url: URL(string: "https://github.com/example.avatar")!))

// Content image from remote URL
.image(.remote(url: URL(string: "https://example.com/coffee.png")!), 
       caption: "A cappuccino is a coffee drink made with equal parts espresso, steamed milk, and milk foam")
```

## JSON-Based Article Creation

### JSON Structure

ArticleKit uses a clean, type-discriminated JSON format:

```json
{
  "id": "unique-article-id",
  "header": [
    { "type": "title", "title": "Article Title" },
    { "type": "author", "author": { 
        "name": "Author Name", 
        "bio": "Author biography",
        "avatarImage": { "remote": { "url": "https://example.com/avatar.jpg" }}
    }}
  ],
  "content": [
    { "type": "heading", "heading": "Section Heading" },
    { "type": "body", "body": "Paragraph content here." }
  ],
  "date": "2024-08-24T10:30:00Z",
  "topic": "Category"
}
```

### Image Sources in JSON

```json
// Local asset
{
  "type": "heroImage",
  "heroImage": { "asset": { "name": "hero-image" }}
}

// Remote URL
{
  "type": "heroImage", 
  "heroImage": { "remote": { "url": "https://example.com/hero.jpg" }}
}

// Author with remote avatar
{
  "type": "author",
  "author": {
    "name": "John Doe",
    "bio": "Technical writer and developer",
    "avatarImage": { "remote": { "url": "https://example.com/avatar.jpg" }}
  }
}
```

### Complete JSON Example

```json
{
  "id": "articlekit-introduction",
  "header": [
    {
      "type": "title",
      "title": "ArticleKit for SwiftUI"
    },
    {
      "type": "subtitle",
      "subtitle": "Build simple, readable articles with minimal setup"
    },
    {
      "type": "topics",
      "topics": ["SwiftUI", "iOS", "Framework", "Open Source"]
    }
  ],
  "content": [
    {
      "type": "heading",
      "heading": "What is ArticleKit?"
    },
    {
      "type": "body",
      "body": "ArticleKit is a SwiftUI framework designed to create simple and readable articles with minimal setup."
    },
    {
      "type": "heading",
      "heading": "Core Features"
    },
    {
      "type": "numberedListItem",
      "numberedListItem": [
        "Rich content blocks: headings, body text, images, quotes, code blocks, and lists",
        "Flexible image sources supporting both local assets and remote URLs",
        "Multiple predefined styles: classic, modern, newspaper, reading, and developer",
        "Complete JSON serialization support for dynamic content",
        "Built-in accessibility features with VoiceOver support",
      ]
    }
  ]
}
```

### Loading JSON Articles

```swift
let article = try Article.from(jsonString: YourArticle)
```

## Block Types Reference

### Header Blocks

| Block Type | Swift | JSON |
|------------|-------|------|
| Hero Image | `.heroImage(.asset(name: "image"))` | `{"type": "heroImage", "heroImage": {"asset": {"name": "image"}}}` |
| Title | `.title("Title")` | `{"type": "title", "title": "Title"}` |
| Subtitle | `.subtitle("Subtitle")` | `{"type": "subtitle", "subtitle": "Subtitle"}` |
| Author | `.author("Name", bio: "Bio", avatarImage: .asset(name: "img"))` | `{"type": "author", "author": {...}}` |
| Date | `.date(Date())` | `{"type": "date", "date": "2024-08-24T10:30:00Z"}` |
| Topics | `.topics(["Topic1", "Topic2"])` | `{"type": "topics", "topics": ["Topic1"]}` |

### Content Blocks

| Block Type | Swift | JSON |
|------------|-------|------|
| Heading | `.heading("Text")` | `{"type": "heading", "heading": "Text"}` |
| Body | `.body("Text")` | `{"type": "body", "body": "Text"}` |
| Image | `.image(.asset(name: "img"), caption: "Caption")` | `{"type": "image", "image": {...}}` |
| Quote | `.quote("Text", author: "Author")` | `{"type": "quote", "quote": {...}}` |
| List Items | `.listItem(["Item1", "Item2"])` | `{"type": "listItem", "listItem": [...]}` |
| Numbered List | `.numberedListItem(["Item1"])` | `{"type": "numberedListItem", "numberedListItem": [...]}` |
| List Header | `.listItemHeader(number: 1, text: "Text")` | `{"type": "listItemHeader", "listItemHeader": {...}}` |
| Code Block | `.codeBlock("code", language: "swift", caption: "Caption")` | `{"type": "codeBlock", "codeBlock": {...}}` |
| Author Info | `.author("Name", bio: "Bio", avatarImage: .asset(name: "img"))` | `{"type": "author", "author": {...}}` |
| Divider | `.divider` | `{"type": "divider"}` |

## Error Handling

ArticleKit provides specific error types for better debugging:

```swift
do {
    let article = try Article.from(jsonString: jsonString)
    let view = ArticleView(article: article)
} catch ArticleError.invalidJSON {
    // Handle malformed JSON
    print("JSON format is invalid - check structure and syntax")
} catch ArticleError.encodingFailed {
    // Handle encoding issues
    print("Failed to encode article to JSON")
} catch ArticleError.imageNotFound(let imageName) {
    // Handle missing local images
    print("Local image '\(imageName)' not found in bundle")
} catch {
    // Handle other errors
    print("Unknown error: \(error.localizedDescription)")
}
```
