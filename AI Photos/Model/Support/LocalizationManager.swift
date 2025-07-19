//
//  LocalizationManager.swift
//  AI Photos
//
//  Created by Никита Горьковой on 2.12.24.
//
import Foundation

class LocalizationManager {
    static let shared = LocalizationManager()

    private init() {
            reloadBundle(for: currentLanguage)
        }

    // Текущий язык
    var currentLanguage: String {
            if #available(iOS 16.0, *) {
                return UserDefaults.standard.string(forKey: "appLanguage") ?? Locale.current.language.languageCode?.identifier ?? "en"
            } else {
                // Для iOS 15 и старше
                return UserDefaults.standard.string(forKey: "appLanguage") ?? Locale.current.languageCode ?? "en"
            }
        }

    // Установить язык
    func setLanguage(_ language: String) {
        guard currentLanguage != language else { return }

        UserDefaults.standard.set(language, forKey: "appLanguage")
        UserDefaults.standard.synchronize()
        reloadBundle(for: language)
    }

    private func reloadBundle(for language: String) {
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            BundleLocalization.bundle = Bundle.main
            return
        }
        BundleLocalization.bundle = bundle
    }
}

// Расширение для кастомного бандла
class BundleLocalization {
    static var bundle: Bundle = .main
}

extension String {
    var localized: String {
        return BundleLocalization.bundle.localizedString(forKey: self, value: nil, table: nil)
    }
}

