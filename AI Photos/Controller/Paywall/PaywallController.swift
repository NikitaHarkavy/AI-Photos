//
//  PaywallController.swift
//  AI Photos
//
//  Created by Никита Горьковой on 29.11.24.
//
import UIKit
import ApphudSDK

class PaywallController: UIViewController {
    
    enum PlacementIdentifier: String, CaseIterable {
        case main, onboarding
    }
    
    var completionHandler: (() -> Void)?
    var isBackgroundHidden: Bool = false
    
    // Закрыть paywall
    func close() {
            completionHandler?() ?? dismiss(animated: true)
        }
        
        // MARK: - Покупка
        func purchase(_ product: ApphudProduct) {
            Apphud.purchase(product) { [weak self] result in
                guard let self = self else { return }
                
                if let sub = result.subscription, sub.isActive(), result.error == nil {
                    // Подписка активна
                    print("Покупка успешна!")
                    AppDelegate.updateSubscriptionStatus()
                    self.close()
                } else {
                    print("Покупка не удалась: \(String(describing: result.error))")
                }
            }
        }
        
        // MARK: - Восстановление покупок
        func restorePurchases() {
            Apphud.restorePurchases { [weak self] subscriptions, purchases, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Ошибка при восстановлении: \(error.localizedDescription)")
                    return
                }
                let hasActive = Apphud.hasActiveSubscription()
                AppDelegate.isPremium = hasActive
                self.close()
            }
            
        }
        
        // MARK: - Презентация контроллера
        class func present(
            in controller: UIViewController,
            placementIdentifierId: PlacementIdentifier, // идентификатор пейволла, если нужно
            completion: (() -> Void)? = nil
        ) {
            guard let paywallController = get(placementIdentifierId: placementIdentifierId,
                                              isBackgroundHidden: false,
                                              completion: completion) else {
                let alert = UIAlertController(
                    title: "Ошибка сети",
                    message: "Пожалуйста, проверьте интернет",
                    preferredStyle: .alert
                )
                alert.addAction(.init(title: "OK", style: .cancel))
                controller.present(alert, animated: true)
                return
            }
            
            controller.present(paywallController, animated: true)
        }
        
        // MARK: - Получение инстанса PaywallController
        class func get(placementIdentifierId: PlacementIdentifier,
                       isBackgroundHidden: Bool,
                       completion: (() -> Void)?) -> PaywallController? {
            
            // Тут мы должны взять Paywall из AppDelegate.cachedPaywall
            // Или, если у нас есть несколько пейволлов,
            // можем с помощью Apphud.paywall(paywallId) достать конкретный пейволл.
            
            // Пример, если мы кэшируем только один пейволл:
            guard let paywall = AppDelegate.cachedPaywalls?[placementIdentifierId] else {
                print("Paywall ещё не загружен")
                return nil
            }
            
            let storyboard = UIStoryboard(name: "PaywallOneController", bundle: nil)
            guard let paywallOne = storyboard.instantiateInitialViewController() as? PaywallOneController else {
                return nil
            }
            
            paywallOne.completionHandler = completion
            paywallOne.isBackgroundHidden = isBackgroundHidden
            paywallOne.paywall = paywall
            
            return paywallOne
        }

    }
