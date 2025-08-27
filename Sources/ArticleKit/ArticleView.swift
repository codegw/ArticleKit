//
//  ArticleView.swift
//  ArticleKit
//
//  Created by codegw on 20/08/2025.
//

import SwiftUI

// MARK: - Article View

/// A SwiftUI view that renders an Article with customizable styling
///
/// `ArticleView` provides a complete, scrollable article reading experience with support for all article content types including text, images, lists, quotes, and code blocks.
/// The view automatically adapts to different screen sizes and respects accessibility settings.
///
/// Example:
/// ```
/// ArticleView(article: myArticle)
///     .articleStyle(.modern)
/// ```

public struct ArticleView: View {
    /// The article data to render
    public let article: Article
    
    /// The current article style configuration from the environment
    @Environment(\.articleStyle) private var style
    
    /// Creates a new article view
    /// - Parameter article: The article data to display
    public init(article: Article) {
        self.article = article
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(article.header) { headerContent in
                        HeaderBlockView(block: headerContent.block, style: style)
                    }
                }
                .padding(.bottom, 25)
                
                LazyVStack(spacing: 25) {
                    ForEach(article.content) { articleContent in 
                        ArticleBlockView(block: articleContent.block, style: style)
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .background(style.theme.configuration.backgroundColor)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Article")
    }
}

// MARK: - Article Header

/// Renders individual header blocks within an article
///
/// This view handles the display of all header block types including hero images, titles, subtitles, author information, dates, and topic tags.

struct HeaderBlockView: View {
    let block: HeaderBlock
    let style: ArticleStyle
    
    var body: some View {
        Group {
            switch block {
            case .heroImage(let imageName):
                if UIImage(named: imageName) != nil {
                    style.headerImageStyle.apply(to: Image(imageName))
                        .padding(.vertical, 10)
                } else {
                    style.headerImageStyle.applyFallback()
                }
                
            case .title(let text):
                Text(text)
                    .font(style.fontStyle.configuration.titleFont)
                    .foregroundColor(style.theme.configuration.textColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .accessibilityAddTraits(.isHeader)
                
            case .subtitle(let text):
                Text(text)
                    .font(style.fontStyle.configuration.bodyFont)
                    .foregroundColor(style.theme.configuration.secondaryColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .accessibilityLabel("Subtitle: \(text)")
                    .accessibilityAddTraits(.isStaticText)
                
            case .author(let name, let bio, let avatarImage):
                style.authorStyle.apply(author: name, bio: bio, avatarImage: avatarImage)
                    .padding(.horizontal, 20)
                    .padding(.top, 5)
                
            case .date(let date):
                DateView(date: date, style: style)
                    .padding(.horizontal, 20)
                
            case .topics(let topics):
                TopicsView(topics: topics, style: style)
            }
        }
    }
}

// MARK: - Article Body

/// Renders individual content blocks within an article body
///
/// This view handles the display of all content block types including headings, body text, images, quotes, lists, code blocks, and dividers.
struct ArticleBlockView: View {
    let block: ArticleBlock
    let style: ArticleStyle
    
    var body: some View {
        contentView
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch block {
        case .heading(let text):
            Text(text)
                .font(style.fontStyle.configuration.headingFont)
                .foregroundColor(style.theme.configuration.textColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .accessibilityAddTraits(.isHeader)
            
        case .body(let text):
            Text(text)
                .font(style.fontStyle.configuration.bodyFont)
                .foregroundColor(style.theme.configuration.textColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .accessibilityAddTraits(.isStaticText)
            
        case .image(let imageName, let caption):
            if UIImage(named: imageName) != nil {
                style.imageStyle.apply(to: Image(imageName), imageHeight: 200, caption: caption)
            } else {
                style.imageStyle.applyFallback(imageHeight: 200, imageName: imageName, caption: caption)
            }
            
        case .quote(let text, let author):
            QuoteView(text: text, author: author, style: style)
                .padding(.horizontal, 20)
            
        case .author(let name, let bio, let avatarImage):
            AuthorStyle.detail.apply(author: name, bio: bio, avatarImage: avatarImage)
                .padding(.horizontal, 20)
            
        case .numberedListHeader(let items):
            NumberedListView(items: items, style: style)
                .padding(.horizontal, 20)
            
        case .listItemHeader(let number, let text):
            ListHeaderView(number: number, text: text, style: style)
                .padding(.horizontal, 20)
            
        case .listItem(let items):
            ListItemView(items: items, style: style)
                .padding(.horizontal, 20)
            
        case .numberedListItem(let items):
            NumberListItemView(items: items, style: style)
                .padding(.horizontal, 20)
            
        case .codeBlock(let code, let language, let caption):
            CodeBlockView(code: code, language: language, caption: caption, style: style)
        
        case .divider:
            Divider()
                .frame(height: 2)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .accessibilityLabel("Section divider")
        }
    }
}

// MARK: - Header Views

/// Displays a formatted date in the article header
///
/// Formats dates using a long date style and applies appropriate accessibility labels.
struct DateView: View {
    let date: Date
    let style: ArticleStyle
    
    var body: some View {
        Text(formatDate(date))
            .font(style.fontStyle.configuration.captionFont)
            .foregroundColor(style.theme.configuration.secondaryColor)
            .padding(.vertical, 4)
            .accessibilityLabel("Published on \(formatDate(date))")
            .accessibilityAddTraits(.isStaticText)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

/// Displays article topic tags in a horizontally scrolling view
///
/// Topics are shown as styled capsules that can be scrolled horizontally if they exceed the available width. Includes subtle fade effects at the edges.
struct TopicsView: View {
    let topics: [String]
    let style: ArticleStyle
    
    var body: some View {
        ZStack {
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(topics, id: \.self) { topic in
                        Text(topic.uppercased())
                            .font(style.fontStyle.configuration.captionFont)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background {
                                Capsule()
                                    .fill(style.theme.configuration.accentColor.gradient)
                            }
                            .accessibilityLabel("Topic: \(topic)")
                            .accessibilityAddTraits(.isStaticText)
                    }
                }
                .padding(.horizontal, 20)
            }
            fadingEffect
            
        }
    }
    
    var fadingEffect: some View {
        HStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.systemBackground),
                    Color(.systemBackground).opacity(0)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: 25)
            
            Spacer()
            
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.systemBackground).opacity(0),
                    Color(.systemBackground)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: 25)
        }
        .allowsHitTesting(false)
    }
}

/// A stylized quote view with opening and closing quotation marks
///
/// Displays quoted text with optional author attribution and decorative quote symbols.
struct QuoteView: View {
    let text: String
    let author: String?
    let style: ArticleStyle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: "quote.opening")
                .font(.title)
                .foregroundStyle(style.theme.configuration.accentColor)
                .accessibilityHidden(true)
            
            Text(text)
                .font(style.fontStyle.configuration.headingFont.weight(.semibold))
                .foregroundColor(style.theme.configuration.textColor)
                .accessibilityLabel("Quote: \(text)")
            
            HStack {
                if let author = author {
                    Text("— \(author)")
                        .font(.system(.subheadline))
                        .foregroundStyle(style.theme.configuration.secondaryColor)
                        .accessibilityLabel("Quote author: \(author)")
                }
                
                Spacer()
                
                Image(systemName: "quote.closing")
                    .font(.title)
                    .foregroundStyle(style.theme.configuration.accentColor)
                    .accessibilityHidden(true)
            }
        }
        .padding(.vertical, 8)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Body Views

///Displays a numbered list, which increments by one for each item
struct NumberedListView: View {
    let items: [String]
    let style: ArticleStyle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                HStack(alignment: .top, spacing: 16) {
                    Text("\(index + 1)")
                        .font(style.fontStyle.configuration.bodyFont)
                        .foregroundColor(style.theme.configuration.textColor)
                        .multilineTextAlignment(.center)
                        .frame(width: 32, height: 32)
                        .background {
                            Circle()
                                .fill(style.theme.configuration.cardBackground)
                        }
                        .accessibilityLabel("Number \(index + 1)")
                    
                    Text(item)
                        .font(style.fontStyle.configuration.bodyFont.weight(.semibold))
                        .foregroundColor(style.theme.configuration.textColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityLabel("Item \(index + 1): \(item)")
                }
                .padding(.vertical, 8)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Numbered list with \(items.count) items")
    }
}

/// Creates a header list with a number
///
/// Each number is shown within a circle, with textual data alongside
struct ListHeaderView: View {
    let number: Int
    let text: String
    let style: ArticleStyle
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Text("\(number)")
                .font(style.fontStyle.configuration.bodyFont)
                .foregroundColor(style.theme.configuration.textColor)
                .multilineTextAlignment(.center)
                .frame(width: 32, height: 32)
                .background {
                    Circle()
                        .fill(style.theme.configuration.cardBackground)
                }
                .accessibilityLabel("Section \(number)")
            
            Text(text)
                .font(style.fontStyle.configuration.bodyFont.weight(.semibold))
                .foregroundColor(style.theme.configuration.textColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityLabel("Section title: \(text)")
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
    }
}

/// Displays a list of items with rounded points
struct ListItemView: View {
    let items: [String]
    let style: ArticleStyle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                HStack(alignment: .top, spacing: 12) {
                    Text("•")
                        .foregroundColor(style.theme.configuration.textColor)
                        .accessibilityHidden(true)
                    
                    Text(item)
                        .font(style.fontStyle.configuration.bodyFont)
                        .foregroundColor(style.theme.configuration.textColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityLabel("List item \(index + 1): \(item)")
                }
                .padding(.vertical, 2)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Bulleted list with \(items.count) items")
    }
}

/// Displays a list of items with numbered points, incrementing by 1
struct NumberListItemView: View {
    let items: [String]
    let style: ArticleStyle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                HStack(alignment: .top, spacing: 12) {
                    Text("\(index + 1).")
                        .font(style.fontStyle.configuration.bodyFont)
                        .foregroundColor(style.theme.configuration.textColor)
                        .frame(width: 25)
                        .accessibilityHidden(true)
                    
                    Text(item)
                        .font(style.fontStyle.configuration.bodyFont)
                        .foregroundColor(style.theme.configuration.textColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityLabel("Item \(index + 1): \(item)")
                }
                .padding(.vertical, 2)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Numbered list with \(items.count) items")
    }
}

/// A code block with monospaced font and a copy button
///
/// Displays a code block, with horizontal scrolling, indicated language and copy function
struct CodeBlockView: View {
    let code: String
    let language: String?
    let caption: String?
    let style: ArticleStyle
    @State private var copied = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with language and copy button
            HStack {
                if let language = language {
                    Text(language)
                        .font(style.fontStyle.configuration.captionFont)
                        .fontWeight(.semibold)
                        .foregroundColor(style.theme.configuration.accentColor)
                        .accessibilityLabel("Programming language: \(language)")
                }
                
                Spacer()
                
                Button(action: copyCode) {
                    HStack(spacing: 4) {
                        Image(systemName: copied ? "checkmark" : "doc.on.doc")
                            .font(.caption)
                        Text(copied ? "Copied!" : "Copy")
                            .font(style.fontStyle.configuration.captionFont)
                    }
                    .foregroundColor(style.theme.configuration.accentColor)
                }
                .animation(.easeInOut(duration: 0.2), value: copied)
                .accessibilityLabel(copied ? "Code copied" : "Copy code to clipboard")
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            // Code content
            ScrollView(.horizontal, showsIndicators: false) {
                Text(code)
                    .font(.system(.subheadline, design: .monospaced))
                    .foregroundColor(style.theme.configuration.textColor)
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityLabel("Code block: \(code)")
                    .accessibilityAddTraits(.isStaticText)
            }
            
            // Caption
            if let caption = caption {
                Text(caption)
                    .font(style.fontStyle.configuration.captionFont)
                    .foregroundColor(style.theme.configuration.secondaryColor)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                    .accessibilityLabel("Code caption: \(caption)")
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(style.theme.configuration.cardBackground)
        )
        .padding(.horizontal, 20)
    }
    
    private func copyCode() {
        UIPasteboard.general.string = code
        copied = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            copied = false
        }
    }
}
