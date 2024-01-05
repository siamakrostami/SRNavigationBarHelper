# SRNavigationBarHelper

## Overview

`SRNavigationBarHelper` is a Swift package that simplifies the configuration of navigation bars in iOS applications. This package allows you to easily customize the appearance, visibility, and functionality of navigation bars, streamlining the process of creating a consistent user interface across your app.

### Integration

To integrate `SRNavigationBarHelper` into your Swift Package Manager (SPM) project, add the following dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/siamakrostami/SRNavigationBarHelper.git", from: "1.0.0")
],
targets: [
    .target(name: "YourTarget", dependencies: ["SRNavigationBarHelper"])
]
```
## Usage
1. Import the package into your Swift file where you want to configure the navigation bar.
```swift
import SRNavigationBarHelper
```
2. Set BaseNavigation as main UINavigationController inside sceneDelegate file.
```swift
      func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else {
            return
        }
        let controller = FirstViewController()
        window = UIWindow(windowScene: scene)
        window?.rootViewController = BaseNavigation(rootViewController: controller, font: .systemFont(ofSize: 18), textColor: .black, backGroundColor: .systemBackground)
        window?.makeKeyAndVisible()
    }
```

3. Import the class into your view controller or wherever you need to configure the navigation bar.

```swift
import UIKit
class BaseViewController: UIViewController {
    let navigation = NavigationBarBuilder()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigation.controller = self
        // Additional setup if needed.
    }
}
```
## Example

```swift
import UIKit

// MARK: - SecondViewController

class SecondViewController: BaseViewController {
    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        layoutView()

        // Do any additional setup after loading the view.
    }

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        navigation.configureNavigationBar(isHidden: false, leftItems: [.backButton(style: .pop, icon: UIImage(systemName: "chevron.left"), tintColor: .black)],logo: "batman", rightItems: nil)
            .withCustomAppearance(backgroundColor: .red)
    }

    // MARK: Private

    private lazy var button: UIButton = {
        let button = UIButton(type: .system, primaryAction: UIAction(handler: { [weak self] _ in
            let controller = ThirdViewController()
            self?.navigationController?.pushViewController(controller, animated: true)
        }))
        button.setTitle("Navigate", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        return button
    }()
}

extension SecondViewController {
    private func layoutView() {
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
    }
}

```
For a detailed example, see the [SRStackHelperExample](https://github.com/siamakrostami/SRNavigationControllerHelper) repository.
