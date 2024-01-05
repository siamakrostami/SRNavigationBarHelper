
import Foundation
import UIKit

// MARK: - NavigationBarBuilder

public class NavigationBarBuilder<T: UIViewController>: NSObject {
    // MARK: Lifecycle

    deinit {
        debugPrint("Navigation Builder Deinited")
        controller = nil
        backType = nil
    }

    // MARK: Internal

    public var controller: T?

    // MARK: Private

    private var backType: BackStyle?

    @objc private func navigateToSupport() {}
    @objc private func navigateToSettings() {}
    @objc private func info() {}
    @objc private func back() {
        guard let backType else {
            return
        }
        switch backType {
        case .pop:
            controller?.navigationController?.popViewController(animated: true)
        case .popToRoot:
            controller?.navigationController?.popToRootViewController(animated: true)
        case .popToViewController(let viewController):
            controller?.navigationController?.popToViewController(ofClass: viewController)
        }
    }
}

extension NavigationBarBuilder {
    @discardableResult
    public func withCustomAppearance(
        backgroundColor: UIColor?, font: UIFont? = nil, titleTextColor: UIColor? = nil, shadowColor: UIColor? = nil) -> Self
    {
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = shadowColor ?? .clear
        appearance.shadowImage = nil
        appearance.backgroundColor = backgroundColor
        appearance.titleTextAttributes = [
            .font: font ?? UIFont.systemFont(ofSize: 18),
            .foregroundColor: titleTextColor ?? UIColor.label,
        ]
        controller?.navigationController?.navigationBar.standardAppearance = appearance
        controller?.navigationController?.navigationBar.compactAppearance = appearance
        controller?.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        if #available(iOS 15.0, *) {
            controller?.navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
        }
        return self
    }

    @discardableResult
    public func withDefaultAppearance() -> Self {
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        appearance.shadowImage = nil
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor.label,
        ]
        controller?.navigationController?.navigationBar.standardAppearance = appearance
        controller?.navigationController?.navigationBar.compactAppearance = appearance
        controller?.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        if #available(iOS 15.0, *) {
            controller?.navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
        }
        return self
    }

    @discardableResult
    public func configureNavigationBar(
        isHidden: Bool,
        isTranslucent: Bool? = nil,
        prefersLargeTitles: Bool? = nil,
        leftItems: [SRNavigationItem]?,
        title: String? = nil,
        logo: String? = nil,
        rightItems: [SRNavigationItem]?) -> Self
    {
        controller?.navigationController?.navigationBar.isTranslucent = isTranslucent ?? false
        controller?.navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles ?? false
        handleNavigationBarVisiblity(isHidden: isHidden)
        setLeftItems(leftItems: leftItems)
        setRightItems(rightItems: rightItems)
        setLogo(logo: logo)
        setTitle(title: title)
        return self
    }

    private func setLeftItems(leftItems: [SRNavigationItem]?) {
        guard let leftItems else {
            controller?.navigationItem.leftBarButtonItems = []
            controller?.navigationItem.hidesBackButton = true
            return
        }
        var items: [UIBarButtonItem] = []

        leftItems.forEach { [weak self] in
            var action: UIBarButtonItem!
            switch $0 {
            case .backButton(let style, let icon, let tint):
                action = UIBarButtonItem(image: icon?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(self?.back))
                action.tintColor = tint
                self?.backType = style
                items.append(action)
            case .button(let tintColor, let icon, let actions):
                action = UIBarButtonItem(image: icon?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: actions)
                action.tintColor = tintColor
                items.append(action)
            case .customView(let view):
                if let view = view {
                    action = UIBarButtonItem(customView: view)
                    items.append(action)
                }
            }
            if !items.isEmpty {
                self?.controller?.navigationItem.setLeftBarButtonItems(items, animated: true)
            } else {
                self?.controller?.navigationItem.leftBarButtonItems = []
                self?.controller?.navigationItem.hidesBackButton = true
            }
        }

    }

    private func handleNavigationBarVisiblity(isHidden: Bool) {
        controller?.navigationController?.setNavigationBarHidden(isHidden, animated: true)
    }

    private func setRightItems(rightItems: [SRNavigationItem]?) {
        guard let rightItems else {
            controller?.navigationItem.rightBarButtonItems = []
            controller?.navigationItem.hidesBackButton = true
            return
        }
        var items: [UIBarButtonItem] = []
        rightItems.forEach { [weak self] in
            var action: UIBarButtonItem!
            switch $0 {
            case .backButton(let style, let icon, let tint):
                action = UIBarButtonItem(image: icon?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(self?.back))
                action.tintColor = tint
                self?.backType = style
                items.append(action)
            case .button(let tintColor, let icon, let actions):
                action = UIBarButtonItem(image: icon?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: actions)
                action.tintColor = tintColor
                items.append(action)
            case .customView(let view):
                if let view = view {
                    action = UIBarButtonItem(customView: view)
                    items.append(action)
                }
            }
            if !items.isEmpty {
                self?.controller?.navigationItem.setRightBarButtonItems(items, animated: true)
            } else {
                self?.controller?.navigationItem.rightBarButtonItems = []
                self?.controller?.navigationItem.hidesBackButton = true
            }
        }

    }

    private func setLogo(logo: String? = nil) {
        guard let logo else {
            return
        }
        guard let image = UIImage(named: logo) else {
            return
        }
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: .init(width: 40, height: 30)))
        titleView.addSubview(imageView)
        imageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = image.withRenderingMode(.alwaysOriginal)
        controller?.navigationItem.titleView = titleView
    }

    private func setTitle(title: String? = nil) {
        guard let title else {
            return
        }
        controller?.title = title
    }
}
