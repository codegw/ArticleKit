# Styling Guide

ArticleKit provides a comprehensive styling system that allows you to customize the appearance of your articles while maintaining accessibility and readability. 

## Predefined Styles

ArticleKit includes several ready-to-use styles optimized for different use cases:

### Available Styles

```swift
// Default article style with sans serif fonts
ArticleView(article: article).articleStyle(.classic)

// Clean, contemporary appearance with modern spacing and rounded corners
ArticleView(article: article).articleStyle(.modern)

// Traditional article layout with serif fonts and classic spacing  
ArticleView(article: article).articleStyle(.newspaper)

// Optimized for extended reading with sepia tones and sans-serif typography
ArticleView(article: article).articleStyle(.reading)

// Developer-focused theme with monospace fonts and dark colors
ArticleView(article: article).articleStyle(.developer)
```

## Theme Configuration

### Color Themes

ArticleKit supports multiple color themes that adapt to your app's aesthetic:

```swift
// Automatically adapts to light/dark mode (recommended)
.articleStyle(ArticleStyle(theme: .dynamic, ...))

// Warm sepia tones for comfortable reading
.articleStyle(ArticleStyle(theme: .sepia, ...))

// Deep dark theme with blue accents
.articleStyle(ArticleStyle(theme: .midnight, ...))

// Custom theme with your own colors
.articleStyle(ArticleStyle(theme: .custom(myThemeConfig), ...))
```

### Theme Properties

Each theme defines:
- **Background Color**: Main article background
- **Text Color**: Primary text color
- **Accent Color**: Links, highlights, and interactive elements
- **Secondary Color**: Captions, metadata, and secondary text
- **Card Background**: Code blocks, quotes, and card elements

> Ensure your article is accessible and conforms to WCAG requirements by providing clear structure, captions for images, and sufficient color contrast

## Typography Configuration

### Font Styles

```swift
// System serif fonts for traditional reading
.articleStyle(ArticleStyle(fontStyle: .serif, ...))

// Clean sans-serif fonts (default system fonts)
.articleStyle(ArticleStyle(fontStyle: .sansSerif, ...))

// Expanded width fonts for impact
.articleStyle(ArticleStyle(fontStyle: .expanded, ...))

// Rounded system fonts for friendly appearance
.articleStyle(ArticleStyle(fontStyle: .rounded, ...))

// Monospace fonts for technical content
.articleStyle(ArticleStyle(fontStyle: .monospace, ...))
```

### Custom Font Configuration

Create your own typography hierarchy:

```swift
let customFonts = FontStyleConfiguration(
    titleFont: .system(.largeTitle, weight: .heavy),
    headingFont: .system(.title2, weight: .bold),
    bodyFont: .system(.body),
    captionFont: .system(.caption, weight: .medium)
)
    
let customStyle = ArticleStyle(
    theme: .dynamic,
    imageStyle: .modern,
    headerImageStyle: .modern,
    fontStyle: .custom(customFonts),
    authorStyle: .classic
)

ArticleView(article: article)
    .articleStyle(customStyle)
```

## Image Styling

### Header Image Styles

Control how hero images appear in your articles:

```swift
// Modern: Rounded corners with horizontal padding
headerImageStyle: .modern

// Classic: Full-width without rounded corners  
headerImageStyle: .classic
```

### Content Image Styles

Style images within article content:

```swift
// Modern: Rounded corners, integrated captions
imageStyle: .modern

// Classic: Full-width, external captions
imageStyle: .classic
```

### Image Source Examples

```swift
// Local asset
.heroImage(.asset(name: "hero-image"))

// Remote URL with fallback
.heroImage(.remote(url: URL(string: "https://example.com/hero.jpg")!))

// Content image with caption
.image(.asset(name: "diagram"), caption: "System architecture overview")
```

## Author Display Styles

### Author Style Options

```swift
// Minimal: Author name only
authorStyle: .minimal

// Classic: Name with small avatar
authorStyle: .classic  

// Detail: Large avatar with name and bio
authorStyle: .detail
```

## Creating Custom Styles

### Complete Custom Style Example

```swift
let customStyle = ArticleStyle(
    theme: .custom(ArticleThemeConfiguration(
        backgroundColor: Color(red: 0.98, green: 0.98, blue: 0.95),
        textColor: Color(red: 0.15, green: 0.15, blue: 0.15),
        accentColor: Color(red: 0.2, green: 0.5, blue: 0.8),
        secondaryColor: Color(red: 0.4, green: 0.4, blue: 0.4),
        cardBackground: Color(red: 0.94, green: 0.94, blue: 0.90)
    )),
    imageStyle: .modern,
    headerImageStyle: .modern,
    fontStyle: .custom(FontStyleConfiguration(
        titleFont: .system(.largeTitle, design: .serif, weight: .bold),
        headingFont: .system(.title2, design: .serif, weight: .semibold),
        bodyFont: .system(.body, design: .serif),
        captionFont: .system(.caption, design: .serif, weight: .medium)
    )),
    authorStyle: .detail
)

ArticleView(article: article)
    .articleStyle(customStyle)
```
