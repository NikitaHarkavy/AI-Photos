//
//  UIViewController.swift
//  AICombine
//
//  Created by Mikhail Verenich on 27.02.2024.
//

import UIKit
import SafariServices

extension UIViewController {
    
    static func instantiate(storyboardName: String? = nil) -> Self {
        let identifier = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName ?? identifier, bundle: nil)
        return storyboard.instantiateInitialViewController() as! Self
    }
    
    func openURL(_ url: URL, isExternal: Bool = false) {
        if isExternal, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            let safariController = SFSafariViewController(url: url)
            safariController.overrideUserInterfaceStyle = .dark
            safariController.modalPresentationStyle = .overFullScreen
            present(safariController, animated: true)
        }
    }
}
