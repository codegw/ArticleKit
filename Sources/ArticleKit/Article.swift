//
//  Article.swift
//  ArticleKit
//
//  Created by codegw on 20/08/2025.
//

import Foundation

/// A flexible article model for creating rich content in SwiftUI applications
///
/// `Article` provides a structured way to define article content with separate header and body sections.
/// It supports JSON serialization and is designed to work seamlessly with `ArticleView` for rendering.
///
/// ## Overview
/// Articles are composed of header blocks (metadata, titles, author info) and content blocks (text, images, lists, code).
/// Each block type has specific styling and behavior, creating a consistent reading experience.
///
/// ## Creating Articles
/// You can create articles using Swift structs or load them from JSON:
///
/// ```swift
/// // Swift-based creation
/// let article = Article(
///     header: [
///         .heroImage("hero.jpg"),
///         .title("My SwiftUI Article"),
///         .author("Jane Developer", bio: "iOS Expert", avatarImage: "jane.png")
///     ],
///     content: [
///         .heading("Introduction"),
///         .body("SwiftUI makes building UIs incredibly easy..."),
///         .image("example.png", caption: "SwiftUI in action")
///     ]
/// )
///
/// // JSON-based creation
/// let article = try Article.from(jsonString: jsonContent)
/// ```
///
/// ## JSON Format
/// The JSON structure uses type discriminators for clean, readable format:
/// ```json
/// {
///   "header": [
///     { "type": "title", "title": "My Article" },
///     { "type": "author", "author": { "name": "John", "bio": "Developer" } }
///   ],
///   "content": [
///     { "type": "body", "body": "Article content here..." }
///   ]
/// }
/// ```
///
/// ## Styling
/// Articles automatically adapt to the current `ArticleStyle` environment value:
/// ```swift
/// ArticleView(article: article)
///     .articleStyle(.modern)  // Apply modern styling
/// ```

public struct Article: Identifiable, Hashable, Codable, Sendable{
    public let id: UUID
    
    /// Header content including title, subtitle, author, hero image, and metadata
    ///
    /// Header blocks appear at the top of the article and typically contain:
    /// - Hero images (`.heroImage`)
    /// - Article titles (`.title`) and subtitles (`.subtitle`)
    /// - Author information (`.author`)
    /// - Publication dates (`.date`)
    /// - Topic tags (`.topics`)
    public let header: [HeaderContent]
    
    /// Main article content including text, images, lists, quotes, and code blocks
    ///
    /// Content blocks make up the article body and support:
    /// - Text content (`.heading`, `.body`)
    /// - Media (`.image` with optional captions)
    /// - Quotes (`.quote` with optional attribution)
    /// - Lists (`.listItem`, `.numberedListItem`, `.numberedListHeader`)
    /// - Code (`.codeBlock` with syntax highlighting)
    /// - Layout (`.divider` for visual separation)
    public let content: [ArticleContent]
    
    /// Optional publication or creation date for the article
    public let date: Date?
    
    /// Optional topic or category classification for the article
    public let topic: String?
    
    /// Creates a new article with the specified header and content blocks
    /// - Parameters:
    ///   - header: Array of header blocks defining article metadata and introduction
    ///   - content: Array of content blocks containing the main article body
    ///   - date: Optional publication date
    ///   - topic: Optional topic or category string
    
    public init(
        header: [HeaderBlock],
        content: [ArticleBlock],
        date: Date? = nil,
        topic: String? = nil
    ) {
        self.id = UUID()
        self.header = header.map { HeaderContent(block: $0) }
        self.content = content.map { ArticleContent(block: $0) }
        self.date = date
        self.topic = topic
    }
    
    // MARK: - JSON Serialization
        
    /// Coding keys for JSON serialization (excludes `id` to keep JSON clean)
    ///
    /// The `id` property is intentionally excluded from JSON to maintain clean format.
    private enum CodingKeys: String, CodingKey {
        case header, content, date, topic
    }
    
    /// Creates an Article from JSON data
    ///
    /// Decodes JSON using the clean object-based format with type discriminators.
    /// Each block's ID is auto-generated during decoding for SwiftUI performance.
    ///
    /// - Parameter decoder: The decoder instance from JSON parsing
    ///
    /// ## JSON Structure Expected
    /// ```json
    /// {
    ///   "header": [
    ///     { "type": "title", "title": "Article Title" }
    ///   ],
    ///   "content": [
    ///     { "type": "body", "body": "Article content..." }
    ///   ],
    ///   "date": "2024-08-24T10:30:00Z",
    ///   "topic": "Development"
    /// }
    /// ```
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let headerBlocks = try container.decode([HeaderBlock].self, forKey: .header)
        let contentBlocks = try container.decode([ArticleBlock].self, forKey: .content)
        
        self.id = UUID()
        self.header = headerBlocks.map { HeaderContent(block: $0) }
        self.content = contentBlocks.map { ArticleContent(block: $0) }
        self.date = try container.decodeIfPresent(Date.self, forKey: .date)
        self.topic = try container.decodeIfPresent(String.self, forKey: .topic)
    }
    
    /// Encodes Article to JSON format
    ///
    /// Creates clean JSON without internal IDs, using type discriminators for block identification.
    ///
    /// - Parameter encoder: The encoder instance for JSON generation
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(header.map { $0.block }, forKey: .header)
        try container.encode(content.map { $0.block }, forKey: .content)
        try container.encodeIfPresent(date, forKey: .date)
        try container.encodeIfPresent(topic, forKey: .topic)
    }
}

/// Wrapper for header blocks that provides stable identity for SwiftUI rendering
///
/// This wrapper ensures each header block has a unique, stable identifier that persists across SwiftUI view updates, preventing unnecessary re-renders.
public struct HeaderContent: Identifiable, Hashable, Codable, Sendable {
    public let id: UUID
    public let block: HeaderBlock
    
    public init(block: HeaderBlock) {
        self.id = UUID()
        self.block = block
    }
    
    public init(from decoder: Decoder) throws {
        self.id = UUID()
        self.block = try HeaderBlock(from: decoder)
    }
    
    public func encode(to encoder: Encoder) throws {
        try block.encode(to: encoder)
    }
}

/// Wrapper for article blocks that provides stable identity for SwiftUI rendering
///
/// This wrapper ensures each article block has a unique, stable identifier that persists across SwiftUI view updates, preventing unnecessary re-renders.
public struct ArticleContent: Identifiable, Hashable, Codable, Sendable {
    public let id: UUID
    public let block: ArticleBlock
    
    public init(block: ArticleBlock) {
        self.id = UUID()
        self.block = block
    }
    
    // ArticleContent is never directly encoded/decoded - only used internally
    public init(from decoder: Decoder) throws {
        self.id = UUID()
        self.block = try ArticleBlock(from: decoder)
    }
    
    public func encode(to encoder: Encoder) throws {
        try block.encode(to: encoder)
    }
}

/// Defines the types of content blocks available for article headers
///
/// Header blocks appear at the top of an article and typically contain metadata, titles, author information, and introductory elements.
public enum HeaderBlock: Hashable, Codable, Sendable {
    /// A hero image displayed prominently at the article top
    /// - Parameter imageName: The name of the image asset to display
    case heroImage(String)
    
    /// The main article title
    /// - Parameter title: The title text to display
    case title(String)
    
    /// The subtitle
    /// - Parameter subtitle: The subtitle to display
    case subtitle(String)
    
    /// Author information with optional bio and avatar
    /// - Parameters:
    ///   - name: The author's name
    ///   - bio: Optional bio information
    ///   - avatarImage: Optional avatar image name
    case author(String, bio: String? = nil, avatarImage: String? = nil)
    
    /// Publication or creation date
    /// - Parameter date: The date to display
    case date(Date)
    
    /// Topic tags or categories for the article
    /// - Parameter topics: Array of topic strings to display as tags
    case topics([String])
}

/// Defines the types of content blocks available for article body content
///
/// Content blocks make up the main body of an article and support various content types including text, images, lists, quotes, and code.
public enum ArticleBlock: Hashable, Codable, Sendable {
    /// A section heading within the article
    /// - Parameter text: The heading text to display
    case heading(String)
    
    /// A paragraph of body text
    /// - Parameter text: The body text content
    case body(String)
    
    /// An image with optional caption
    /// - Parameters:
    ///   - imageName: The name of the image
    ///   - caption: Optional caption text below the image
    case image(String, caption: String? = nil)
    
    /// A blockquote with optional attribution
    /// - Parameters:
    ///   - text: The quoted text
    ///   - author: Optional attribution for the quote
    case quote(String, author: String? = nil)
    
    /// A numbered list with header-style items
    /// - Parameter items: Array of list items, to display as headers
    case numberedListHeader([String])
    
    /// A numbered list item header with custom numbering
    /// - Parameters:
    ///   - number: The number to display
    ///   - text: The header text
    case listItemHeader(number: Int, text: String)
    
    /// A bulleted list of items
    /// - Parameter items: Array of list item strings
    case listItem([String])
    
    /// A numbered list of items with automatic numbering
    /// - Parameter items: Array of list item strings
    case numberedListItem([String])
    
    /// A syntax-highlighted code block
    /// - Parameters:
    ///   - code: The source code text
    ///   - language: Optional programming language
    ///   - caption: Optional caption describing the code
    case codeBlock(String, language: String? = nil, caption: String? = nil)
    
    /// Author information block within content
    /// - Parameters:
    ///   - name: The author's name
    ///   - bio: Optional biographical information
    ///   - avatarImage: Optional avatar image asset name
    case author(String, bio: String? = nil, avatarImage: String? = nil)
    
    /// A visual divider between content sections
    case divider
}

/// Errors that can occur when working with Article instances
public enum ArticleError: Error, LocalizedError {
    /// Thrown when JSON data cannot be decoded into an Article
    case invalidJSON
    
    /// Thrown when an Article cannot be encoded to JSON
    case encodingFailed
    
    /// Thrown when a referenced image asset cannot be found
    /// - Parameter imageName: The name of the missing image
    case imageNotFound(String)
    
    /// Error descriptions
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
}

// MARK: - JSON Convenience Methods
public extension Article {
    /// Create an article from JSON data
    /// - Parameter jsonData: The JSON data to decode
    /// - Returns: A decoded Article instance
    /// - Throws: ArticleError.invalidJSON if decoding fails
    static func from(jsonData: Data) throws -> Article {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(Article.self, from: jsonData)
        } catch {
            throw ArticleError.invalidJSON
        }
    }
    
    /// Create an article from a JSON string
    /// - Parameter jsonString: The JSON string to decode
    /// - Returns: A decoded Article instance
    /// - Throws: ArticleError.invalidJSON if decoding fails
    static func from(jsonString: String) throws -> Article {
        guard let data = jsonString.data(using: .utf8) else {
            throw ArticleError.invalidJSON
        }
        return try from(jsonData: data)
    }
    
    /// Convert the article to JSON data
    /// - Returns: JSON data representation of the article
    /// - Throws: ArticleError.encodingFailed if encoding fails
    func toJSONData() throws -> Data {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .prettyPrinted
            return try encoder.encode(self)
        } catch {
            throw ArticleError.encodingFailed
        }
    }
    
    /// Convert the article to a JSON string
    /// - Returns: JSON string representation of the article
    /// - Throws: ArticleError.encodingFailed if encoding fails
    func toJSONString() throws -> String {
        let data = try toJSONData()
        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw ArticleError.encodingFailed
        }
        return jsonString
    }
}

// MARK: - Helper structs for clean JSON structure

/// Helper struct for clean author JSON representation
private struct AuthorData: Codable {
    let name: String
    let bio: String?
    let avatarImage: String?
}

/// Helper struct for clean image JSON representation
private struct ImageData: Codable {
    let imageName: String
    let caption: String?
}

/// Helper struct for clean quote JSON representation
private struct QuoteData: Codable {
    let text: String
    let author: String?
}

/// Helper struct for clean code block JSON representation
private struct CodeBlockData: Codable {
    let code: String
    let language: String?
    let caption: String?
}

/// Helper struct for clean list item header JSON representation
private struct ListItemHeaderData: Codable {
    let number: Int
    let text: String
}

// MARK: - Header Block Types

/// Defines the types of content blocks available for article headers
///
/// Header blocks appear at the top of an article and typically contain metadata,
/// titles, author information, and introductory elements. Each case corresponds
/// to a specific visual component in the rendered article.
///
/// ## Available Types
/// - **Visual**: `.heroImage` for prominent header images
/// - **Text**: `.title`, `.subtitle` for article identification
/// - **Metadata**: `.author`, `.date`, `.topics` for article information
///
/// ## JSON Representation
/// ```json
/// { "type": "author", "author": { "name": "...", "bio": "...", "avatarImage": "..." } }
/// ```

extension HeaderBlock {
    private enum CodingKeys: String, CodingKey {
        case type, heroImage, title, subtitle, author, date, topics
    }
    
    private enum BlockType: String, Codable {
        case heroImage, title, subtitle, author, date, topics
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(BlockType.self, forKey: .type)
        
        switch type {
        case .heroImage:
            let imageName = try container.decode(String.self, forKey: .heroImage)
            self = .heroImage(imageName)
            
        case .title:
            let title = try container.decode(String.self, forKey: .title)
            self = .title(title)
            
        case .subtitle:
            let subtitle = try container.decode(String.self, forKey: .subtitle)
            self = .subtitle(subtitle)
            
        case .author:
            let authorData = try container.decode(AuthorData.self, forKey: .author)
            self = .author(authorData.name, bio: authorData.bio, avatarImage: authorData.avatarImage)
            
        case .date:
            let date = try container.decode(Date.self, forKey: .date)
            self = .date(date)
            
        case .topics:
            let topics = try container.decode([String].self, forKey: .topics)
            self = .topics(topics)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .heroImage(let imageName):
            try container.encode(BlockType.heroImage, forKey: .type)
            try container.encode(imageName, forKey: .heroImage)
            
        case .title(let title):
            try container.encode(BlockType.title, forKey: .type)
            try container.encode(title, forKey: .title)
            
        case .subtitle(let subtitle):
            try container.encode(BlockType.subtitle, forKey: .type)
            try container.encode(subtitle, forKey: .subtitle)
            
        case .author(let name, let bio, let avatarImage):
            try container.encode(BlockType.author, forKey: .type)
            try container.encode(AuthorData(name: name, bio: bio, avatarImage: avatarImage), forKey: .author)
            
        case .date(let date):
            try container.encode(BlockType.date, forKey: .type)
            try container.encode(date, forKey: .date)
            
        case .topics(let topics):
            try container.encode(BlockType.topics, forKey: .type)
            try container.encode(topics, forKey: .topics)
        }
    }
}

// MARK: - Article Block Types

/// Defines the types of content blocks available for article body content
///
/// Content blocks make up the main body of an article and support various content
/// types including text, images, lists, quotes, and code. Each block type has
/// specific styling and behavior optimized for readability.
///
/// ## Categories
/// - **Text**: `.heading`, `.body` for structured content
/// - **Media**: `.image` with captions for visual content
/// - **Interactive**: `.quote` for highlighted text, `.codeBlock` with syntax highlighting
/// - **Lists**: Various list types for organized information
/// - **Layout**: `.divider`, `.author` for content organization
///

extension ArticleBlock {
    private enum CodingKeys: String, CodingKey {
        case type, heading, body, image, quote, numberedListHeader, listItemHeader,
             listItem, numberedListItem, codeBlock, author, divider
    }
    
    private enum BlockType: String, Codable {
        case heading, body, image, quote, numberedListHeader, listItemHeader,
             listItem, numberedListItem, codeBlock, author, divider
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(BlockType.self, forKey: .type)
        
        switch type {
        case .heading:
            let text = try container.decode(String.self, forKey: .heading)
            self = .heading(text)
            
        case .body:
            let text = try container.decode(String.self, forKey: .body)
            self = .body(text)
            
        case .image:
            let imageData = try container.decode(ImageData.self, forKey: .image)
            self = .image(imageData.imageName, caption: imageData.caption)
            
        case .quote:
            let quoteData = try container.decode(QuoteData.self, forKey: .quote)
            self = .quote(quoteData.text, author: quoteData.author)
            
        case .numberedListHeader:
            let items = try container.decode([String].self, forKey: .numberedListHeader)
            self = .numberedListHeader(items)
            
        case .listItemHeader:
            let headerData = try container.decode(ListItemHeaderData.self, forKey: .listItemHeader)
            self = .listItemHeader(number: headerData.number, text: headerData.text)
            
        case .listItem:
            let items = try container.decode([String].self, forKey: .listItem)
            self = .listItem(items)
            
        case .numberedListItem:
            let items = try container.decode([String].self, forKey: .numberedListItem)
            self = .numberedListItem(items)
            
        case .codeBlock:
            let codeData = try container.decode(CodeBlockData.self, forKey: .codeBlock)
            self = .codeBlock(codeData.code, language: codeData.language, caption: codeData.caption)
            
        case .author:
            let authorData = try container.decode(AuthorData.self, forKey: .author)
            self = .author(authorData.name, bio: authorData.bio, avatarImage: authorData.avatarImage)
            
        case .divider:
            self = .divider
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .heading(let text):
            try container.encode(BlockType.heading, forKey: .type)
            try container.encode(text, forKey: .heading)
            
        case .body(let text):
            try container.encode(BlockType.body, forKey: .type)
            try container.encode(text, forKey: .body)
            
        case .image(let imageName, let caption):
            try container.encode(BlockType.image, forKey: .type)
            try container.encode(ImageData(imageName: imageName, caption: caption), forKey: .image)
            
        case .quote(let text, let author):
            try container.encode(BlockType.quote, forKey: .type)
            try container.encode(QuoteData(text: text, author: author), forKey: .quote)
            
        case .numberedListHeader(let items):
            try container.encode(BlockType.numberedListHeader, forKey: .type)
            try container.encode(items, forKey: .numberedListHeader)
            
        case .listItemHeader(let number, let text):
            try container.encode(BlockType.listItemHeader, forKey: .type)
            try container.encode(ListItemHeaderData(number: number, text: text), forKey: .listItemHeader)
            
        case .listItem(let items):
            try container.encode(BlockType.listItem, forKey: .type)
            try container.encode(items, forKey: .listItem)
            
        case .numberedListItem(let items):
            try container.encode(BlockType.numberedListItem, forKey: .type)
            try container.encode(items, forKey: .numberedListItem)
            
        case .codeBlock(let code, let language, let caption):
            try container.encode(BlockType.codeBlock, forKey: .type)
            try container.encode(CodeBlockData(code: code, language: language, caption: caption), forKey: .codeBlock)
            
        case .author(let name, let bio, let avatarImage):
            try container.encode(BlockType.author, forKey: .type)
            try container.encode(AuthorData(name: name, bio: bio, avatarImage: avatarImage), forKey: .author)
            
        case .divider:
            try container.encode(BlockType.divider, forKey: .type)
        }
    }
}

public extension Article {
    /// Convenience computed properties for easy access to header information
    
    /// Extracts the article title from header blocks
    var title: String {
        for headerContent in header {
            if case .title(let title) = headerContent.block {
                return title
            }
        }
        return "Untitled Article"
    }
    
    /// Extracts the article subtitle from header blocks
    var subtitle: String? {
        for headerContent in header {
            if case .subtitle(let subtitle) = headerContent.block {
                return subtitle
            }
        }
        return nil
    }
    
    /// Extracts the author name from header blocks
    var authorName: String? {
        for headerContent in header {
            if case .author(let name, _, _) = headerContent.block {
                return name
            }
        }
        return nil
    }
    
    /// Extracts the author bio from header blocks
    var authorBio: String? {
        for headerContent in header {
            if case .author(_, let bio, _) = headerContent.block {
                return bio
            }
        }
        return nil
    }
    
    /// Extracts the author avatar image from header blocks
    var authorAvatarImage: String? {
        for headerContent in header {
            if case .author(_, _, let avatarImage) = headerContent.block {
                return avatarImage
            }
        }
        return nil
    }
    
    /// Extracts the hero image from header blocks
    var heroImageName: String? {
        for headerContent in header {
            if case .heroImage(let imageName) = headerContent.block {
                return imageName
            }
        }
        return nil
    }
    
    /// Extracts all topics from header blocks
    var topics: [String] {
        for headerContent in header {
            if case .topics(let topics) = headerContent.block {
                return topics
            }
        }
        return []
    }
    
    /// Gets the first topic as a primary category
    var primaryTopic: String? {
        return topics.first
    }
    
    /// Extracts the publication date from header blocks
    var publicationDate: Date? {
        for headerContent in header {
            if case .date(let date) = headerContent.block {
                return date
            }
        }
        return date // Falls back to article's date property
    }
    
    /// Gets a preview of the article content (first body block)
    var contentPreview: String? {
        for articleContent in content {
            if case .body(let text) = articleContent.block {
                return text
            }
        }
        return nil
    }
    
    /// Gets the first image in the content
    var firstContentImageName: String? {
        for articleContent in content {
            if case .image(let imageName, _) = articleContent.block {
                return imageName
            }
        }
        return nil
    }
}

// MARK: - Article Summary Helper

/// A helper struct that makes it easy to work with article metadata
public struct ArticleSummary {
    public let id: UUID
    public let title: String
    public let subtitle: String?
    public let authorName: String?
    public let heroImageName: String?
    public let primaryTopic: String?
    public let date: Date?
    public let contentPreview: String?
    
    public init(from article: Article) {
        self.id = article.id
        self.title = article.title
        self.subtitle = article.subtitle
        self.authorName = article.authorName
        self.heroImageName = article.heroImageName
        self.primaryTopic = article.primaryTopic
        self.date = article.publicationDate
        self.contentPreview = article.contentPreview
    }
}

public extension Article {
    /// Creates a summary object for easier UI binding
    var summary: ArticleSummary {
        return ArticleSummary(from: self)
    }
}
