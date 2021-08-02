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
  internal static let _0090Ff = ColorAsset(name: "0090FF")
  internal static let _00D3Ff = ColorAsset(name: "00D3FF")
  internal static let _0D043A = ColorAsset(name: "0D043A")
  internal static let _151616 = ColorAsset(name: "151616")
  internal static let _241861 = ColorAsset(name: "241861")
  internal static let _3B3070 = ColorAsset(name: "3B3070")
  internal static let backOpacity00 = ColorAsset(name: "backOpacity00")
  internal static let backOpacity30 = ColorAsset(name: "backOpacity30")
  internal static let backOpacity60 = ColorAsset(name: "backOpacity60")
  internal static let brightskyblue = ColorAsset(name: "brightskyblue")
  internal static let colorBg = ColorAsset(name: "colorBg")
  internal static let cyan = ColorAsset(name: "Cyan")
  internal static let green = ColorAsset(name: "Green")
  internal static let `none` = ColorAsset(name: "None")
  internal static let orange = ColorAsset(name: "Orange")
  internal static let pink = ColorAsset(name: "Pink")
  internal static let purple = ColorAsset(name: "Purple")
  internal static let yellow = ColorAsset(name: "Yellow")
  internal static let white = ColorAsset(name: "white")
  internal static let midnight = ColorAsset(name: "midnight")
  internal static let white30 = ColorAsset(name: "white30")
  internal static let bgCharging = ImageAsset(name: "bgCharging")
  internal static let bgAnimation = ImageAsset(name: "bg_animation")
  internal static let icAnimation = ImageAsset(name: "ic_animation")
  internal static let icAnimationDetail = ImageAsset(name: "ic_animation_detail")
  internal static let icHomeCharging = ImageAsset(name: "ic_home_charging")
  internal static let icSelectionHome = ImageAsset(name: "ic_selection_home")
  internal static let icSetting = ImageAsset(name: "ic_setting")
  internal static let pinWhite = ImageAsset(name: "pin_white")
  internal static let settingWhite = ImageAsset(name: "setting_white")
  internal static let textLogoHome = ImageAsset(name: "textLogoHome")
  internal static let howToUseAnimation1 = ImageAsset(name: "HowToUseAnimation-1")
  internal static let howToUseAnimation10 = ImageAsset(name: "HowToUseAnimation-10")
  internal static let howToUseAnimation11 = ImageAsset(name: "HowToUseAnimation-11")
  internal static let howToUseAnimation2 = ImageAsset(name: "HowToUseAnimation-2")
  internal static let howToUseAnimation3 = ImageAsset(name: "HowToUseAnimation-3")
  internal static let howToUseAnimation4 = ImageAsset(name: "HowToUseAnimation-4")
  internal static let howToUseAnimation5 = ImageAsset(name: "HowToUseAnimation-5")
  internal static let howToUseAnimation6 = ImageAsset(name: "HowToUseAnimation-6")
  internal static let howToUseAnimation7 = ImageAsset(name: "HowToUseAnimation-7")
  internal static let howToUseAnimation8 = ImageAsset(name: "HowToUseAnimation-8")
  internal static let howToUseAnimation9 = ImageAsset(name: "HowToUseAnimation-9")
  internal static let icIntroduceDown = ImageAsset(name: "ic_introduce_down")
  internal static let icIntroduceUp = ImageAsset(name: "ic_introduce_up")
  internal static let icSelectionColor = ImageAsset(name: "ic_selection_color")
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
  internal static let icPauseSound = ImageAsset(name: "ic_pause_sound")
  internal static let icPlaySound = ImageAsset(name: "ic_play_sound")
  internal static let icBackSelection = ImageAsset(name: "ic_back_selection")
  internal static let icSelectionIcon = ImageAsset(name: "ic_selection_icon")
  internal static let icSelectionRight = ImageAsset(name: "ic_selection_right")
  internal static let icSeletionColor = ImageAsset(name: "ic_seletion_color")
  internal static let icSound = ImageAsset(name: "ic_sound")
  internal static let icPreniumSetting1 = ImageAsset(name: "ic_prenium_setting-1")
  internal static let icPreniumSetting = ImageAsset(name: "ic_prenium_setting")
  internal static let icSettingContact = ImageAsset(name: "ic_setting_contact")
  internal static let icSettingPrivacy = ImageAsset(name: "ic_setting_privacy")
  internal static let icSettingSetting = ImageAsset(name: "ic_setting_setting")
  internal static let icSettingShare = ImageAsset(name: "ic_setting_share")
  internal static let icSettingTerm = ImageAsset(name: "ic_setting_term")
  internal static let icUseAnimation = ImageAsset(name: "ic_use_animation")
  internal static let icSplash = ImageAsset(name: "ic_splash")
  internal static let logoSplash = ImageAsset(name: "logo_splash")
  internal static let _70e67e82e96dc7050e02274d368698b7 = ImageAsset(name: "70e67e82e96dc7050e02274d368698b7")
  internal static let chargingAnimation = ImageAsset(name: "charging_animation")
  internal static let close = ImageAsset(name: "close")
  internal static let group21985 = ImageAsset(name: "group_21985")
  internal static let group21987 = ImageAsset(name: "group_21987")
  internal static let group22560 = ImageAsset(name: "group_22560")
  internal static let group22561 = ImageAsset(name: "group_22561")
  internal static let group22562 = ImageAsset(name: "group_22562")
  internal static let group22563 = ImageAsset(name: "group_22563")
  internal static let group22564 = ImageAsset(name: "group_22564")
  internal static let group22565 = ImageAsset(name: "group_22565")
  internal static let group22579 = ImageAsset(name: "group_22579")
  internal static let group22580 = ImageAsset(name: "group_22580")
  internal static let group22581 = ImageAsset(name: "group_22581")
  internal static let group22582 = ImageAsset(name: "group_22582")
  internal static let group22583 = ImageAsset(name: "group_22583")
  internal static let group22584 = ImageAsset(name: "group_22584")
  internal static let group22585 = ImageAsset(name: "group_22585")
  internal static let group22586 = ImageAsset(name: "group_22586")
  internal static let group22587 = ImageAsset(name: "group_22587")
  internal static let group22588 = ImageAsset(name: "group_22588")
  internal static let group22589 = ImageAsset(name: "group_22589")
  internal static let group22590 = ImageAsset(name: "group_22590")
  internal static let group22591 = ImageAsset(name: "group_22591")
  internal static let group22592 = ImageAsset(name: "group_22592")
  internal static let group22593 = ImageAsset(name: "group_22593")
  internal static let group22594 = ImageAsset(name: "group_22594")
  internal static let group22595 = ImageAsset(name: "group_22595")
  internal static let group22596 = ImageAsset(name: "group_22596")
  internal static let group22597 = ImageAsset(name: "group_22597")
  internal static let group22598 = ImageAsset(name: "group_22598")
  internal static let group22599 = ImageAsset(name: "group_22599")
  internal static let group22601 = ImageAsset(name: "group_22601")
  internal static let group22602 = ImageAsset(name: "group_22602")
  internal static let group22603 = ImageAsset(name: "group_22603")
  internal static let group22604 = ImageAsset(name: "group_22604")
  internal static let group22605 = ImageAsset(name: "group_22605")
  internal static let group22606 = ImageAsset(name: "group_22606")
  internal static let group22608 = ImageAsset(name: "group_22608")
  internal static let group22609 = ImageAsset(name: "group_22609")
  internal static let group22610 = ImageAsset(name: "group_22610")
  internal static let group22611 = ImageAsset(name: "group_22611")
  internal static let group22612 = ImageAsset(name: "group_22612")
  internal static let group22614 = ImageAsset(name: "group_22614")
  internal static let group22616 = ImageAsset(name: "group_22616")
  internal static let group22617 = ImageAsset(name: "group_22617")
  internal static let group22618 = ImageAsset(name: "group_22618")
  internal static let group22619 = ImageAsset(name: "group_22619")
  internal static let group22620 = ImageAsset(name: "group_22620")
  internal static let makeAnimation = ImageAsset(name: "make_animation")
  internal static let maskGroup117 = ImageAsset(name: "mask_group_117")
  internal static let maskGroup118 = ImageAsset(name: "mask_group_118")
  internal static let maskGroup119 = ImageAsset(name: "mask_group_119")
  internal static let maskGroup120 = ImageAsset(name: "mask_group_120")
  internal static let maskGroup121 = ImageAsset(name: "mask_group_121")
  internal static let maskGroup122 = ImageAsset(name: "mask_group_122")
  internal static let page1 = ImageAsset(name: "page_1")
  internal static let path3790 = ImageAsset(name: "path_3790")
  internal static let path3800 = ImageAsset(name: "path_3800")
  internal static let path3801 = ImageAsset(name: "path_3801")
  internal static let path3802 = ImageAsset(name: "path_3802")
  internal static let path3806 = ImageAsset(name: "path_3806")
  internal static let path6110 = ImageAsset(name: "path_6110")
  internal static let path6113 = ImageAsset(name: "path_6113")
  internal static let polygon7 = ImageAsset(name: "polygon_7")
  internal static let setting = ImageAsset(name: "setting")
  internal static let subtraction169 = ImageAsset(name: "subtraction_169")
  internal static let union12 = ImageAsset(name: "union_12")
  internal static let union14 = ImageAsset(name: "union_14")
  internal static let union4 = ImageAsset(name: "union_4")
  internal static let up = ImageAsset(name: "up")
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
