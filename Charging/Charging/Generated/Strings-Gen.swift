// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Add Action 
  internal static let addAction = L10n.tr("Localizable", "Add Action ")
  /// Animation 
  internal static let animation = L10n.tr("Localizable", "Animation ")
  /// App
  internal static let app = L10n.tr("Localizable", "App")
  /// app
  internal static let app2 = L10n.tr("Localizable", "app2")
  /// App
  internal static let app3 = L10n.tr("Localizable", "App3")
  /// Apps 
  internal static let apps = L10n.tr("Localizable", "Apps ")
  /// Ask Before Running 
  internal static let askBeforeRunning = L10n.tr("Localizable", "Ask Before Running ")
  /// button
  internal static let button = L10n.tr("Localizable", "button")
  /// Charger
  internal static let charger = L10n.tr("Localizable", "Charger")
  /// Charging Animation 
  internal static let chargingAnimation = L10n.tr("Localizable", "Charging Animation ")
  /// Create Personal Automation
  internal static let createPersonalAutomation = L10n.tr("Localizable", "Create Personal Automation")
  /// Hot Animation
  internal static let hotAnimation = L10n.tr("Localizable", "Hot Animation")
  /// How to use Animation
  internal static let howToUseAnimation = L10n.tr("Localizable", "How to use Animation")
  /// Is Connected
  internal static let isConnected = L10n.tr("Localizable", "Is Connected")
  /// Next
  internal static let next = L10n.tr("Localizable", "Next")
  /// Shortcuts 
  internal static let shortcuts = L10n.tr("Localizable", "Shortcuts ")
  /// Success
  internal static let success = L10n.tr("Localizable", "Success")
  /// switch button
  internal static let switchButton = L10n.tr("Localizable", "switch button")

  internal enum _1 {
    /// 1.Open 
    internal static let `open` = L10n.tr("Localizable", "1.Open ")
  }

  internal enum _10 {
    /// 10. Turn off the 
    internal static let turnOffThe = L10n.tr("Localizable", "10. Turn off the ")
  }

  internal enum _2 {
    /// 2. Click the 
    internal static let clickThe = L10n.tr("Localizable", "2. Click the ")
  }

  internal enum _3 {
    /// 3. Slide down to the bonttom of table, and select 
    internal static let slideDownToTheBonttomOfTableAndSelect = L10n.tr("Localizable", "3. Slide down to the bonttom of table, and select ")
  }

  internal enum _4 {
    /// 4.Select the 
    internal static let selectThe = L10n.tr("Localizable", "4.Select the ")
  }

  internal enum _5 {
    /// 5. Click the 
    internal static let clickThe = L10n.tr("Localizable", "5. Click the ")
  }

  internal enum _6 {
    /// 6. Click the 
    internal static let clickThe = L10n.tr("Localizable", "6. Click the ")
  }

  internal enum _7 {
    /// 7. Choose 
    internal static let choose = L10n.tr("Localizable", "7. Choose ")
  }

  internal enum _8 {
    /// 8. Select 
    internal static let select = L10n.tr("Localizable", "8. Select ")
  }

  internal enum _9 {
    /// 9. Click 
    internal static let click = L10n.tr("Localizable", "9. Click ")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
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
