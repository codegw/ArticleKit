# API Functions Reference

This document provides comprehensive reference for all public APIs, types, and functions available in ArticleKit.

## Core Types

### Article

The main struct representing an article with header and content blocks.

```swift
public struct Article: Identifiable, Hashable, Codable, Sendable
```

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `id` | `String` | Unique identifier for the article |
| `header` | `[HeaderContent]` | Array of header blocks with stable identifiers |
| `content` | `[ArticleContent]` | Array of content blocks with stable identifiers |
| `date` | `Date?` | Optional publication or creation date |
| `topic` | `String?` | Optional topic or category classification |

#### Initializers

```swift
public init(
    id: String,
    header: [HeaderBlock],
    content: [ArticleBlock], 
    date: Date? = nil,
    topic: String? = nil
)
```

#### Convenience Properties

ArticleSummary provides data for showing an article preview

```swift
// Header information extraction
var title: String                    // First title block or "Untitled Article"
var subtitle: String?                // First subtitle block
var authorName: String?              // First author's name
var heroImageSource: ImageSource?    // First hero image source
var publicationDate: Date?           // Date from header blocks or article date property

// Content extraction  
var contentPreview: String?          // First body text for previews

// Summary helper
var summary: ArticleSummary          // Structured summary object
```

### ImageSource

Represents the source for an image, supporting both local assets and remote URLs.

```swift
public enum ImageSource: Hashable, Codable, Sendable
```

#### Cases

```swift
case asset(name: String)    // Local image in app bundle
case remote(url: URL)       // Remote image from URL
```

#### Usage Examples

```swift
// Local asset
let heroImage = ImageSource.asset(name: "hero-banner")

// Remote URL
let remoteImage = ImageSource.remote(url: URL(string: "https://example.com/image.jpg")!)
```

## Header Block Types

### HeaderBlock

Enum defining content blocks for article headers.

```swift
public enum HeaderBlock: Hashable, Codable, Sendable
```

#### Cases

```swift
case heroImage(ImageSource)                                       // Hero image
case title(String)                                                // Article title  
case subtitle(String)                                             // Subtitle
case author(String, bio: String?, avatarImage: ImageSource?)      // Author info
case date(Date)                                                   // Publication date
case topics([String])                                             // Topic tags
```

#### Usage Examples

```swift
let headerBlocks: [HeaderBlock] = [
    .heroImage(.remote(url: URL(string: "https://example.com/hero.jpg")!)),
    .title("My Article Title"),
    .subtitle("An engaging subtitle"),
    .author("Jane Doe", bio: "Writer and developer", avatarImage: .asset(name: "jane-avatar")),
    .date(Date()),
    .topics(["Swift", "iOS", "Tutorial"])
]
```

## Content Block Types

### ArticleBlock

Enum defining content blocks for article body.

```swift
public enum ArticleBlock: Hashable, Codable, Sendable
```

#### Cases

```swift
// Text content
case heading(String)                                              // Section heading
case body(String)                                                 // Paragraph text

// Media content  
case image(ImageSource, caption: String?)                        // Image with caption

// Interactive content
case quote(String, author: String?)                              // Quote with attribution
case codeBlock(String, language: String?, caption: String?)      // Code with syntax info

// List content
case numberedListHeader([String])                                 // Numbered list as headers
case listItemHeader(number: Int, text: String)                   // Custom numbered header
case listItem([String])                                          // Bulleted list
case numberedListItem([String])                                  // Auto-numbered list

// Layout content
case author(String, bio: String?, avatarImage: ImageSource?)     // Author info in content
case divider                                                     // Visual separator
```

#### Usage Examples

```swift
let contentBlocks: [ArticleBlock] = [
    .heading("Introduction"),
    .body("Welcome to this comprehensive guide..."),
    .image(.asset(name: "diagram"), caption: "System architecture"),
    .quote("Knowledge is power.", author: "Francis Bacon"),
    .codeBlock("print('Hello, World!')", language: "swift", caption: "Basic Swift example"),
    .listItem(["First point", "Second point", "Third point"]),
    .divider
]
```

## JSON Serialization

### Static Factory Methods

```swift
// Create from JSON data
static func from(jsonData: Data) throws -> Article

// Create from JSON string  
static func from(jsonString: String) throws -> Article
```

#### Example Usage

```swift
// From string
do {
    let article = try Article.from(jsonString: jsonString)
    let articleView = ArticleView(article: article)
} catch ArticleError.invalidJSON {
    print("Invalid JSON format")
} catch {
    print("Unexpected error: \(error)")
}

// From data (e.g., network request)
Task {
    let url = URL(string: "https://api.example.com/articles/123")!
    let (data, _) = try await URLSession.shared.data(from: url)
    let article = try Article.from(jsonData: data)
    // Use article...
}
```

### Instance Export Methods

```swift
// Export to JSON data
func toJSONData() throws -> Data

// Export to JSON string
func toJSONString() throws -> String
```

#### Example Usage

```swift
do {
    // Create formatted JSON string
    let jsonString = try article.toJSONString()
    print(jsonString)
    
    // Save to file
    let documentsPath = FileManager.default.urls(for: .documentDirectory, 
                                                in: .userDomainMask)[0]
    let fileURL = documentsPath.appendingPathComponent("article.json")
    try jsonString.write(to: fileURL, atomically: true, encoding: .utf8)
    
} catch ArticleError.encodingFailed {
    print("Failed to encode article")
} catch {
    print("File save error: \(error)")
}
```

## Error Handling

### ArticleError

Enum defining possible errors when working with articles.

```swift
public enum ArticleError: Error, LocalizedError
```

#### Cases

```swift
case invalidJSON                    // JSON cannot be decoded
case encodingFailed                 // Article cannot be encoded to JSON
case imageNotFound(String)          // Referenced image asset not found
```

#### Error Descriptions

```swift
public var errorDescription: String? {
    switch self {
    case .invalidJSON:
        return "Invalid JSON format"
    case .encodingFailed:
        return "Failed to encode article to JSON"  
    case .imageNotFound(let name):
        return "Image '\(name)' not found"
    }
}
```
