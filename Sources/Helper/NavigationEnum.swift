
import Foundation
import UIKit

// MARK: - SRNavigationItem

public enum SRNavigationItem {
    case backButton(style: BackStyle, icon: UIImage?, tintColor: UIColor?)
    case button(tintColor: UIColor?, icon: UIImage?, action: Selector?)
    case customView(view: UIView?)
}

// MARK: - BackStyle

public enum BackStyle {
    case pop
    case popToRoot
    case popToViewController(class: AnyClass)
}
