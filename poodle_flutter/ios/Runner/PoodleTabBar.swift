import Flutter
import UIKit

/// Kept in the runner so navigation needs no additional package or global overlay window.
final class PoodleTabBarFactory: NSObject, FlutterPlatformViewFactory {
  private let messenger: FlutterBinaryMessenger

  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }

  func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    FlutterStandardMessageCodec.sharedInstance()
  }

  func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?)
    -> FlutterPlatformView
  {
    // Dart only requests this view after checking the native OS version.
    if #available(iOS 26.0, *) {
      return PoodleTabBarPlatformView(frame: frame, id: viewId, args: args, messenger: messenger)
    }
    return PoodleEmptyPlatformView()
  }
}

private final class PoodleEmptyPlatformView: NSObject, FlutterPlatformView {
  private let surface = UIView()
  func view() -> UIView { surface }
}

@available(iOS 26.0, *)
private final class PoodleTabBarPlatformView: NSObject, FlutterPlatformView {
  private let surface: PoodleTabBarSurface
  private let channel: FlutterMethodChannel

  init(frame: CGRect, id: Int64, args: Any?, messenger: FlutterBinaryMessenger) {
    surface = PoodleTabBarSurface(frame: frame)
    channel = FlutterMethodChannel(name: "poodle/ios_navigation/\(id)", binaryMessenger: messenger)
    super.init()
    surface.onSelect = { [weak self] index in
      self?.channel.invokeMethod("select", arguments: index)
    }
    surface.onExpand = { [weak self] in
      self?.channel.invokeMethod("expand", arguments: nil)
    }
    surface.update(args)
    channel.setMethodCallHandler { [weak self] call, result in
      guard call.method == "update" else {
        result(FlutterMethodNotImplemented)
        return
      }
      self?.surface.update(call.arguments)
      result(nil)
    }
  }

  func view() -> UIView { surface }

  deinit { channel.setMethodCallHandler(nil) }
}

/// System Liquid Glass materials and native buttons, with Flutter owning routes and scroll state.
@available(iOS 26.0, *)
private final class PoodleTabBarSurface: UIView {
  var onSelect: ((Int) -> Void)?
  var onExpand: (() -> Void)?

  private let group: UIVisualEffectView
  private let selection = UIView()
  private var buttons: [UIButton] = []
  private let search = UIButton(type: .system)
  private var selectedIndex = 0
  private var minimized = false
  private var reduceMotion = false
  private var labels: [String] = []
  private var textScale: CGFloat = 1
  private var accent: UIColor = .systemOrange
  private let symbols = ["house", "book.closed", "calendar", "bell", "magnifyingglass"]
  private let selectedSymbols = ["house.fill", "book.closed.fill", "calendar", "bell.fill", "magnifyingglass"]

  override init(frame: CGRect) {
    let glass = UIGlassEffect(style: .regular)
    glass.isInteractive = true
    group = UIVisualEffectView(effect: glass)
    super.init(frame: frame)
    backgroundColor = .clear
    isOpaque = false
    overrideUserInterfaceStyle = .light
    group.clipsToBounds = true
    group.contentView.addSubview(selection)
    selection.isUserInteractionEnabled = false
    addSubview(group)

    for index in 0..<4 {
      let button = UIButton(type: .system)
      button.tag = index
      button.accessibilityIdentifier = "poodle-tab-\(index)"
      button.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
      group.contentView.addSubview(button)
      buttons.append(button)
    }
    search.tag = 4
    search.accessibilityIdentifier = "poodle-tab-4"
    search.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
    addSubview(search)
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  func update(_ arguments: Any?) {
    guard let data = arguments as? [String: Any],
      let titles = data["labels"] as? [String], titles.count == 5,
      let index = data["selectedIndex"] as? Int, (0..<5).contains(index)
    else { return }
    let wasMinimized = minimized
    let selectionChanged = !labels.isEmpty && selectedIndex != index
    layoutIfNeeded()
    labels = titles
    selectedIndex = index
    minimized = data["minimized"] as? Bool ?? false
    reduceMotion = (data["reduceMotion"] as? Bool ?? false) || UIAccessibility.isReduceMotionEnabled
    textScale = CGFloat((data["textScale"] as? NSNumber)?.doubleValue ?? 1)
    if let color = data["tint"] as? NSNumber {
      let argb = color.uint32Value
      accent = UIColor(
        red: CGFloat((argb >> 16) & 255) / 255,
        green: CGFloat((argb >> 8) & 255) / 255,
        blue: CGFloat(argb & 255) / 255,
        alpha: 1)
    }
    if selectionChanged && !reduceMotion {
      UIView.transition(with: self, duration: 0.18,
        options: [.transitionCrossDissolve, .beginFromCurrentState, .allowUserInteraction]) {
        self.configureButtons()
      }
      setNeedsLayout()
      UIView.animate(withDuration: 0.28, delay: 0, usingSpringWithDamping: 0.82,
        initialSpringVelocity: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
        self.layoutIfNeeded()
      }
      return
    }
    configureButtons()
    setNeedsLayout()
    if wasMinimized != minimized && !reduceMotion {
      UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
        self.layoutIfNeeded()
      }
    }
  }

  private func configureButtons() {
    guard labels.count == 5 else { return }
    for index in 0..<4 {
      let button = buttons[index]
      let selected = selectedIndex == index
      var config = UIButton.Configuration.plain()
      config.image = UIImage(systemName: selected ? selectedSymbols[index] : symbols[index])
      config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 23, weight: .medium)
      config.title = minimized ? nil : labels[index]
      config.imagePlacement = .top
      config.imagePadding = 4
      config.titleAlignment = .center
      config.titleLineBreakMode = .byClipping
      config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 4, bottom: 6, trailing: 4)
      config.baseForegroundColor = selected ? accent : .label
      let font = UIFont.systemFont(ofSize: 10 * textScale, weight: selected ? .semibold : .medium)
      config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
        var attributes = incoming
        attributes.font = font
        return attributes
      }
      button.configuration = config
      button.titleLabel?.numberOfLines = 1
      button.titleLabel?.lineBreakMode = .byClipping
      // Keep the full localized title on one line, including narrow iPhones.
      button.titleLabel?.adjustsFontSizeToFitWidth = true
      button.titleLabel?.minimumScaleFactor = 0.3
      button.titleLabel?.baselineAdjustment = .alignCenters
      button.titleLabel?.textAlignment = .center
      button.accessibilityLabel = labels[index]
      button.accessibilityTraits = selected ? [.button, .selected] : [.button]
      // Selection is drawn once by our capsule. UIKit's selected button state
      // adds a second system highlight over it on iOS 26.
      button.isSelected = false
    }
    var config = UIButton.Configuration.glass()
    config.image = UIImage(systemName: "magnifyingglass")
    config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium)
    config.cornerStyle = .capsule
    config.baseForegroundColor = selectedIndex == 4 ? accent : .label
    search.configuration = config
    search.accessibilityLabel = labels[4]
    search.accessibilityTraits = selectedIndex == 4 ? [.button, .selected] : [.button]
    search.isSelected = false
    selection.backgroundColor = accent.withAlphaComponent(0.14)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    let side: CGFloat = 12
    let searchSize: CGFloat = 56
    let height = max(56, bounds.height - 16)
    let groupWidth = minimized ? 64 : max(0, bounds.width - side * 2 - searchSize - 12)
    let groupHeight = minimized ? 56 : height
    group.frame = CGRect(x: side, y: (bounds.height - groupHeight) / 2, width: groupWidth, height: groupHeight)
    group.layer.cornerRadius = groupHeight / 2
    search.frame = CGRect(x: bounds.width - side - searchSize, y: (bounds.height - searchSize) / 2, width: searchSize, height: searchSize)
    let inset: CGFloat = minimized ? 4 : 6
    let width = (groupWidth - inset * 2) / (minimized ? 1 : 4)
    let visibleIndex = min(selectedIndex, 3)
    for index in 0..<4 {
      let button = buttons[index]
      button.isHidden = minimized && index != visibleIndex
      button.frame = CGRect(x: inset + (minimized ? 0 : CGFloat(index) * width), y: inset, width: width, height: groupHeight - inset * 2)
    }
    selection.alpha = selectedIndex == 4 ? 0 : 1
    if selectedIndex != 4 || selection.frame.isEmpty {
      selection.frame = buttons[visibleIndex].frame.insetBy(dx: minimized ? 0 : 2, dy: 0)
    }
    selection.layer.cornerRadius = selection.bounds.height / 2
    accessibilityElements = buttons.filter { !$0.isHidden } + [search]
  }

  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    group.frame.contains(point) || search.frame.contains(point)
  }

  @objc private func tapped(_ sender: UIButton) {
    if minimized && sender !== search {
      onExpand?()
    } else {
      onSelect?(sender.tag)
    }
  }
}
