// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let accentColor = ColorAsset(name: "AccentColor")
  internal static let _151616 = ColorAsset(name: "151616")
  internal static let backOpacity00 = ColorAsset(name: "backOpacity00")
  internal static let backOpacity30 = ColorAsset(name: "backOpacity30")
  internal static let backOpacity60 = ColorAsset(name: "backOpacity60")
  internal static let brightskyblue = ColorAsset(name: "brightskyblue")
  internal static let cyan = ColorAsset(name: "Cyan")
  internal static let green = ColorAsset(name: "Green")
  internal static let `none` = ColorAsset(name: "None")
  internal static let orange = ColorAsset(name: "Orange")
  internal static let pink = ColorAsset(name: "Pink")
  internal static let purple = ColorAsset(name: "Purple")
  internal static let white = ColorAsset(name: "White")
  internal static let yellow = ColorAsset(name: "Yellow")
  internal static let midnight = ColorAsset(name: "midnight")
  internal static let white30 = ColorAsset(name: "white30")
  internal static let bgCharging = ImageAsset(name: "bgCharging")
  internal static let bgAnimation = ImageAsset(name: "bg_animation")
  internal static let icAnimationDetail = ImageAsset(name: "ic_animation_detail")
  internal static let icHomeCharging = ImageAsset(name: "ic_home_charging")
  internal static let textLogoHome = ImageAsset(name: "textLogoHome")
  internal static let icSelect = ImageAsset(name: "ic_select")
  internal static let _1 = ImageAsset(name: "1")
  internal static let _10 = ImageAsset(name: "10")
  internal static let _11 = ImageAsset(name: "11")
  internal static let _12 = ImageAsset(name: "12")
  internal static let _13 = ImageAsset(name: "13")
  internal static let _14 = ImageAsset(name: "14")
  internal static let _15 = ImageAsset(name: "15")
  internal static let _16 = ImageAsset(name: "16")
  internal static let _17 = ImageAsset(name: "17")
  internal static let _18 = ImageAsset(name: "18")
  internal static let _2 = ImageAsset(name: "2")
  internal static let _3 = ImageAsset(name: "3")
  internal static let _4 = ImageAsset(name: "4")
  internal static let _5 = ImageAsset(name: "5")
  internal static let _6 = ImageAsset(name: "6")
  internal static let _7 = ImageAsset(name: "7")
  internal static let _8 = ImageAsset(name: "8")
  internal static let _9 = ImageAsset(name: "9")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = Color(asset: self)

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image named \(name).")
    }
    return result
  }
}

internal extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
