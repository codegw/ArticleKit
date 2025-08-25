//
//  ArticleStyle.swift
//  ArticleKit
//
//  Created by codegw on 20/08/2025.
//

import SwiftUI

// MARK: - Article Style

/// A comprehensive styling system for customizing the appearance of articles
///
/// `ArticleStyle` provides a unified way to customize all visual aspects of an article,
/// including typography, colors, image presentation, and author display styles.
/// It follows a composable design where individual style components can be mixed and matched.
///
/// Example:
/// ```
/// let customStyle = ArticleStyle(
///     theme: .dark,
///     imageStyle: .modern,
///     headerImageStyle: .modern,
///     fontStyle: .serif,
///     authorStyle: .classic
/// )
/// ```

public struct ArticleStyle: Sendable{
    /// Color theme configuration for the article
    public var theme: ArticleTheme
    
    /// Styling for content images within the article body
    public var imageStyle: ImageStyle
    
    /// Styling for hero images within the article header
    public var headerImageStyle: HeaderImageStyle
    
    /// Typography configuration for all text elements
    public var fontStyle: FontStyle
    
    /// Styling for author information display
    public var authorStyle: AuthorStyle
    
    
    /// Creates a new article style configuration
    /// - Parameters:
    ///   - theme: Color theme to apply
    ///   - imageStyle: Style for content images
    ///   - headerImageStyle: Style for hero images
    ///   - fontStyle: Typography configuration
    ///   - authorStyle: Author information display style

    public init(
        theme: ArticleTheme,
        imageStyle: ImageStyle,
        headerImageStyle: HeaderImageStyle,
        fontStyle: FontStyle,
        authorStyle: AuthorStyle
    ) {
        self.theme = theme
        self.imageStyle = imageStyle
        self.headerImageStyle = headerImageStyle
        self.fontStyle = fontStyle
        self.authorStyle = authorStyle
    }
}

// MARK: - Font Style

/// Typography configuration options for article text elements
///
/// Provides predefined font combinations optimized for readability and visual hierarchy.
/// Each style defines fonts for titles, headings, body text, and captions.
/// Defines the font options for text within articles

public enum FontStyle: Sendable{
    case serif
    case sansSerif
    case expanded
    case rounded
    case monospace
    case custom(FontStyleConfiguration)
    
    public var configuration: FontStyleConfiguration {
        switch self {
        case .serif:
            return FontStyleConfiguration(
                titleFont: .system(.title, design: .serif, weight: .bold),
                headingFont: .system(.title3, design: .serif, weight: .semibold),
                bodyFont: .system(.body, design: .serif),
                captionFont: .system(.footnote, design: .serif)
            )
        case .sansSerif:
            return FontStyleConfiguration(
                titleFont: .system(.title, weight: .bold),
                headingFont: .system(.title3, weight: .semibold),
                bodyFont: .system(.body),
                captionFont: .system(.footnote)
            )
        case .expanded:
            return FontStyleConfiguration(
                titleFont: .system(.title, weight: .bold).width(.expanded),
                headingFont: .system(.title3, weight: .semibold).width(.condensed),
                bodyFont: .system(.body),
                captionFont: .system(.footnote).width(.condensed)
            )
        case .rounded:
            return FontStyleConfiguration(
                titleFont: .system(.title, design: .rounded, weight: .bold),
                headingFont: .system(.title3, design: .rounded, weight: .semibold),
                bodyFont: .system(.body, design: .rounded),
                captionFont: .system(.footnote, design: .rounded)
            )
        case .monospace:
            return FontStyleConfiguration(
                titleFont: .system(.title, design: .monospaced, weight: .bold),
                headingFont: .system(.title3, design: .monospaced, weight: .semibold),
                bodyFont: .system(.body, design: .monospaced),
                captionFont: .system(.footnote, design: .monospaced)
            )
        case .custom(let config):
            return config
        }
    }
}

/// Font configuration that defines all typography used in articles
///
/// Provides specific font definitions for different text hierarchy levels.
/// A custom option allows you to configure different levels of typography.
public struct FontStyleConfiguration: Sendable{
    /// Primary font for article titles
    public let titleFont: Font
    
    /// Font for section headings within articles
    public let headingFont: Font
    
    /// Font for body within articles
    public let bodyFont: Font
    
    /// Font for captions and secondary text within articles
    public let captionFont: Font
    
    public init(titleFont: Font, headingFont: Font, bodyFont: Font, captionFont: Font) {
        self.titleFont = titleFont
        self.headingFont = headingFont
        self.bodyFont = bodyFont
        self.captionFont = captionFont
    }
}

// MARK: - Header Image Style

/// Styling options for hero images displayed in article headers
///
/// Controls how header images are presented, including corner radius, padding, and fallback appearance when images are unavailable.

public enum HeaderImageStyle: Sendable{
    case classic
    case modern
    
    @ViewBuilder
    public func apply(to image: Image) -> some View {
        switch self {
        /// Modern header with horizontal padding and rounded corners
        case .modern:
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: 250)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)
                .clipped()
                .accessibilityLabel("Article hero image")
        
        /// Classic full-width header image with no rounded corners
        case .classic:
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: 250)
                .clipped()
                .accessibilityLabel("Article hero image")
        }
    }
    
    /// Provides a fallback view when the header image cannot be loaded.
    @ViewBuilder
    public func applyFallback() -> some View {
        switch self {
        case .modern:
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)
                .overlay(
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                )
                .accessibilityLabel("Article hero image unavailable")
        case .classic:
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(height: 250)
                .overlay(
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                )
                .accessibilityLabel("Article hero image unavailable")
        }
    }
}

// MARK: - Image Style

/// Styling options for content images within article bodies
///
/// Controls the presentation of images embedded in article content, including caption styling and fallback appearance.

public enum ImageStyle: Sendable{
    case classic
    case modern
    
    @ViewBuilder
    public func apply(to image: Image, imageHeight: CGFloat, caption: String? = nil, fontConfig: FontStyleConfiguration) -> some View {
        switch self {
        /// Modern image, with padding, rounded corners, and a caption within the container
        case .modern:
            VStack(spacing: 0) {
                ZStack (alignment: .topTrailing){
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .accessibilityHidden(true)
                }
                if let caption = caption {
                    ZStack {
                        Rectangle()
                            .fill(.thickMaterial)
                        Text(caption)
                            .font(fontConfig.captionFont)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                    }
                }
            }
            .mask {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
            }
            .padding(.horizontal, 20)
        
        /// Classic image, full-width, and a caption outside the container
        case .classic:
            VStack(spacing: 8) {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .accessibilityLabel(caption ?? "Article image")
                
                if let caption = caption {
                    Text(caption)
                        .font(fontConfig.captionFont) // Now uses proper caption font
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .accessibilityLabel("Image caption: \(caption)")
                }
            }
        }
    }
    
    /// Provides a fallback view when the image cannot be loaded.
    @ViewBuilder
    public func applyFallback(imageHeight: CGFloat, imageName: String, caption: String? = nil, fontConfig: FontStyleConfiguration) -> some View {
        VStack(spacing: 8) {
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(height: 250)
                .overlay(
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                )
                .accessibilityLabel("Image '\(imageName)' not available")
            
            if let caption = caption {
                Text(caption)
                    .font(fontConfig.captionFont)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .accessibilityLabel("Image caption: \(caption)")
            }
        }
    }
}


// MARK: - Author Style

/// Styling options for author elements within the article
///
/// Controls the presentation of author information, with choice from the name, or bio and profile image

public enum AuthorStyle: Sendable {
    case minimal
    case classic
    case detail
    
    @ViewBuilder
    public func apply(author: String?, bio: String? = nil, avatarImage: String? = nil) -> some View {
        AuthorBlock(style: self, author: author, bio: bio, avatarImage: avatarImage)
    }
}

/// Defines the visual styling options for author styles within the article
private struct AuthorBlock: View {
    let style: AuthorStyle
    let author: String?
    let bio: String?
    let avatarImage: String?
    @Environment(\.articleStyle) private var articleStyle
    
    var fonts: FontStyleConfiguration { articleStyle.fontStyle.configuration }
    var colors: ArticleThemeConfiguration { articleStyle.theme.configuration }
    
    var body: some View {
        switch style {
        
        ///
        case .minimal:
            if let author = author {
                Text(author)
                    .font(fonts.captionFont)
                    .foregroundColor(colors.secondaryColor)
                    .accessibilityLabel("Author: \(author)")
                    .accessibilityAddTraits(.isStaticText)
            }
            
        case .classic:
            HStack(spacing: 10) {
                if let avatarImage = avatarImage {
                    authorAvatar(avatarImage, size: 30)
                }
                
                if let author = author {
                    Text(author)
                        .font(fonts.bodyFont.weight(.medium))
                        .foregroundColor(colors.secondaryColor)
                        .accessibilityLabel("Author: \(author)")
                }
            }
            .accessibilityElement(children: .combine)
            
        case .detail:
            HStack(alignment: .top, spacing: 12) {
                if let avatarImage = avatarImage {
                    authorAvatar(avatarImage, size: 75)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    if let author = author {
                        Text(author)
                            .font(fonts.bodyFont.weight(.medium))
                            .foregroundColor(colors.textColor)
                            .accessibilityLabel("Author: \(author)")
                    }
                    
                    if let bio = bio {
                        Text(bio)
                            .font(fonts.captionFont)
                            .foregroundColor(colors.secondaryColor)
                            .accessibilityLabel("Author bio: \(bio)")
                    }
                }
            }
            .accessibilityElement(children: .combine)
        }
    }
    
    @ViewBuilder
    private func authorAvatar(_ imageName: String, size: CGFloat) -> some View {
        if UIImage(named: imageName) != nil {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(Circle())
                .accessibilityLabel("Author profile picture")
        } else {
            Circle()
                .fill(Color(.systemGray5))
                .frame(width: size, height: size)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: size * 0.6))
                        .foregroundColor(.secondary)
                )
                .accessibilityLabel("Author profile picture placeholder")
        }
    }
}

// MARK: - Theme Configuration

/// Styling options for colors and typography color within the article
///
/// It is recommended that you use the `.dynamic` theme for support with Light and Dark mode
/// Other themes are additionally provided for your control, such as sepia and midnight
///
/// - Important: Before using a custom theme, **always check WCAG compliance.**

public struct ArticleThemeConfiguration: Sendable {
    public let backgroundColor: Color
    public let textColor: Color
    public let accentColor: Color
    public let secondaryColor: Color
    public let cardBackground: Color
    
    public init(
        backgroundColor: Color,
        textColor: Color,
        accentColor: Color,
        secondaryColor: Color,
        cardBackground: Color
    ) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.accentColor = accentColor
        self.secondaryColor = secondaryColor
        self.cardBackground = cardBackground
    }
}

public enum ArticleTheme: Sendable{
    case light
    case dark
    case dynamic
    case sepia
    case vibrant
    case midnight
    case custom(ArticleThemeConfiguration)
    
    public var configuration: ArticleThemeConfiguration {
        switch self {
        case .light:
            return ArticleThemeConfiguration(
                backgroundColor: Color(.systemBackground),
                textColor: Color(.label),
                accentColor: Color.blue,
                secondaryColor: Color(.secondaryLabel),
                cardBackground: Color(.secondarySystemBackground)
            )
        case .dark:
            return ArticleThemeConfiguration(
                backgroundColor: Color(.black),
                textColor: Color(.white),
                accentColor: Color(.systemBlue),
                secondaryColor: Color(.secondaryLabel),
                cardBackground: Color(.systemGray6)
            )
        case .dynamic:
            return ArticleThemeConfiguration(
                backgroundColor: Color(.systemBackground),
                textColor: Color(.label),
                accentColor: Color(.tintColor),
                secondaryColor: Color(.secondaryLabel),
                cardBackground: Color(.secondarySystemBackground)
            )
        case .sepia:
            return ArticleThemeConfiguration(
                backgroundColor: Color(red: 0.96, green: 0.93, blue: 0.85),
                textColor: Color(red: 0.24, green: 0.18, blue: 0.12),
                accentColor: Color(red: 0.65, green: 0.49, blue: 0.00),
                secondaryColor: Color(red: 0.32, green: 0.23, blue: 0.00),
                cardBackground: Color(red: 0.91, green: 0.85, blue: 0.73)
            )
        case .midnight:
            return ArticleThemeConfiguration(
                backgroundColor: Color(red: 0.05, green: 0.07, blue: 0.15),
                textColor: Color.white,
                accentColor: Color(red: 0.4, green: 0.7, blue: 1.0),
                secondaryColor: Color(red: 0.7, green: 0.75, blue: 0.8),
                cardBackground: Color(red: 0.2, green: 0.20, blue: 0.2)
            )
        case .vibrant:
            return ArticleThemeConfiguration(
                backgroundColor: Color(.black),
                textColor: Color(red: 0.37, green: 0.96, blue: 0.84),
                accentColor: Color(red: 1.00, green: 0.44, blue: 0.00),
                secondaryColor: Color(red: 1, green: 0.41, blue: 0.66),
                cardBackground: Color(red: 0.18, green: 0.18, blue: 0.18)
            )
        case .custom(let config):
            return config
        }
    }
}

// MARK: - Pre-defined Styles

/// Created pre-defined styles for easy theming
public extension ArticleStyle {
    static let classic = ArticleStyle(
        theme: .dynamic,
        imageStyle: .classic,
        headerImageStyle: .classic,
        fontStyle: .serif,
        authorStyle: .classic
    )
    
    static let modern = ArticleStyle(
        theme: .dynamic,
        imageStyle: .modern,
        headerImageStyle: .modern,
        fontStyle: .sansSerif,
        authorStyle: .minimal
    )
    
    static let reading = ArticleStyle(
        theme: .sepia,
        imageStyle: .classic,
        headerImageStyle: .classic,
        fontStyle: .serif,
        authorStyle: .minimal
    )
    
    static let developer = ArticleStyle(
        theme: .midnight,
        imageStyle: .classic,
        headerImageStyle: .classic,
        fontStyle: .monospace,
        authorStyle: .classic
    )
}

// MARK: - Environment Support
private struct ArticleStyleKey: EnvironmentKey {
    static let defaultValue: ArticleStyle = .classic
}

public extension EnvironmentValues {
    var articleStyle: ArticleStyle {
        get { self[ArticleStyleKey.self] }
        set { self[ArticleStyleKey.self] = newValue }
    }
}

public extension View {
    func articleStyle(_ style: ArticleStyle) -> some View {
        environment(\.articleStyle, style)
    }
}
