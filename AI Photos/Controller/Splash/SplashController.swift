//
//  SplashController.swift
//  AI Photos
//
//  Created by Никита Горьковой on 24.11.24.
//

import UIKit

class SplashController: UIViewController {
    
    @UserDefaultsValue(key: "splash_controller_onboarding_passed", defaultValue: false)
    static var isOnboardingPassed: Bool
    
    let group = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        if !AppDelegate.productsLoaded {
            group.enter()
            NotificationCenter.default.addObserver(self, selector: #selector(productsLoaded), name: AppDelegate.productsLoadedNotification, object: nil)
        }
        
        let currentNewLanguage = LocalizationManager.shared.currentLanguage
        LocalizationManager.shared.setLanguage(currentNewLanguage)
        
                DispatchQueue.global().async {
            let result = self.group.wait(timeout: .now() + 5)
            if result == .timedOut {
                print("Время ожидания истекло, продолжаем загрузку приложения")
            }
            DispatchQueue.main.async {
                self.showHome()
                if !Self.isOnboardingPassed {
                    self.showOnboarding()
                }
            }
        }
    }
    
    private func showOnboarding() {
        let onboardingController = FirstOnboardingController.instantiate()
        
        let navigationController = UINavigationController(rootViewController: onboardingController)
        navigationController.isNavigationBarHidden = true
        
        let onboardingWindow = UIWindow(frame: UIScreen.main.bounds)
        onboardingWindow.rootViewController = navigationController
        onboardingWindow.makeKeyAndVisible()
        AppDelegate.shared?.onboardingWindow = onboardingWindow
    }
    
    private func showHome() {
        let navigationController = NavigationController(rootViewController: HomeController.instantiate())
        present(navigationController, animated: true)
    }
    
    @objc private func productsLoaded() {
        NotificationCenter.default.removeObserver(self, name: AppDelegate.productsLoadedNotification, object: nil)
        group.leave()
    }
}
