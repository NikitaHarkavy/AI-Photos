//
//  AppDelegate.swift
//  AI Photos
//
//  Created by Никита Горьковой on 24.11.24.
//

import UIKit
import ApphudSDK

public var isDebug: Bool {
#if DEBUG
    return true
#else
    return false
#endif
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static let privacy = "https://telegra.ph/Privacy-Policy-02-05-75"
    static let terms = "https://telegra.ph/Terms--Conditions-02-05-2"
    
    let testAppHudApiKey = "app_C5dT9EQz1Tb4R8asuAHHWotK8K6xWv"
    let productAppHudApiKey = "ВАШ_APPHUD_API_KEY"
    let mainIdentifier = "paywall_main"
    let onboardingIdentifier = "paywall_onboarding"
    
    static let premiumStatusUpdatedNotification = Notification.Name("AppDelegate.premiumStatusUpdatedNotification")
    static let productsLoadedNotification = Notification.Name("AppDelegate.productsLoadedNotification")
    
    static var isPremium: Bool = false {
        didSet {
            NotificationCenter.default.post(name: premiumStatusUpdatedNotification, object: nil)
        }
    }
    
    static var cachedPaywalls: [PaywallController.PlacementIdentifier : ApphudPaywall]?

        // Флаг, нужна ли тебе проверка "загружены ли продукты"
    static var productsLoaded: Bool = false
    
    var window: UIWindow?
    var onboardingWindow: UIWindow?
    
    static var shared: AppDelegate? { UIApplication.shared.delegate as? AppDelegate }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let key = isDebug ? testAppHudApiKey : productAppHudApiKey
        
            Apphud.start(apiKey: key) {_ in
                Task {
                    let mainPaywall = await Apphud.paywall(self.mainIdentifier)
                    let onboardingPaywall = await Apphud.paywall(self.onboardingIdentifier)

                    if let mainPaywall, let onboardingPaywall {
                        Self.cachedPaywalls = [.main : mainPaywall, .onboarding : onboardingPaywall]

                        Self.productsLoaded = true
                        NotificationCenter.default.post(name: Self.productsLoadedNotification, object: nil)
                    } else {
                        print("Не удалось загрузить paywalls")
                    }
                }
                Self.updateSubscriptionStatus()
            }
            
        
        
        
        return true
    }
    
    
    static func updateSubscriptionStatus() {
           let premium = Apphud.hasActiveSubscription()
           Self.isPremium = premium
       }

    
    func reloadRootViewController() {
        guard let window = self.window else { return }
        let storyboard = UIStoryboard(name: "HomeController", bundle: nil)
        window.rootViewController = storyboard.instantiateInitialViewController()
        window.makeKeyAndVisible()
    }
}
