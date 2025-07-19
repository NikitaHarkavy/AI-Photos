//
//  Constants.swift
//  AI Photos
//
//  Created by Никита Горьковой on 25.11.24.
//

import Foundation

struct Constants {
    private init() {}
    
    struct Shared {
        private init() {}
        
        static var home: String {
            return NSLocalizedString("home", bundle: BundleLocalization.bundle, comment: "")
        }
        static var outFit: String {
            return NSLocalizedString("outFit", bundle: BundleLocalization.bundle, comment: "")
        }
        static var hairstyle: String {
            return NSLocalizedString("hairstyle", bundle: BundleLocalization.bundle, comment: "")
        }
    }
    
    struct HomeScreen {
        private init() {}
        
        static var buildYourFirstCollection: String {
            return NSLocalizedString("buildYourFirstCollection", bundle: BundleLocalization.bundle, comment: "")
        }
        static var addTheFirstPhoto: String {
            return NSLocalizedString("addTheFirstPhoto", bundle: BundleLocalization.bundle, comment: "")
        }
        static var newOutfit: String {
            return NSLocalizedString("newOutfit", bundle: BundleLocalization.bundle, comment: "")
        }
        static var myCollections: String {
            return NSLocalizedString("myCollections", bundle: BundleLocalization.bundle, comment: "")
        }
        static var mensCollections: String {
            return NSLocalizedString("mensCollections", bundle: BundleLocalization.bundle, comment: "")
        }
        static var womensCollections: String {
            return NSLocalizedString("womensCollections", bundle: BundleLocalization.bundle, comment: "")
        }
    }
    
    struct PhotoSelectionScreen {
        private init() {}
        
        static var takeYourPhoto: String {
            return NSLocalizedString("takeYourPhoto", bundle: BundleLocalization.bundle, comment: "")
        }
        static var orImportFromTheGallery: String {
            return NSLocalizedString("orImportFromTheGallery", bundle: BundleLocalization.bundle, comment: "")
        }
        static var importFromGallery: String {
            return NSLocalizedString("importFromGallery", bundle: BundleLocalization.bundle, comment: "")
        }
        static var takeAPhoto: String {
            return NSLocalizedString("takeAPhoto", bundle: BundleLocalization.bundle, comment: "")
        }
    }
    
    struct OutFitAndHairScreen {
        private init() {}
        
        static var virtualTryOn: String {
            return NSLocalizedString("virtualTryOn", bundle: BundleLocalization.bundle, comment: "")
        }
        static var hairstyle: String {
            return NSLocalizedString("hairstyle", bundle: BundleLocalization.bundle, comment: "")
        }
        static var womens: String {
            return NSLocalizedString("womens", bundle: BundleLocalization.bundle, comment: "")
        }
        static var mens: String {
            return NSLocalizedString("mens", bundle: BundleLocalization.bundle, comment: "")
        }
        static var all: String {
            return NSLocalizedString("all", bundle: BundleLocalization.bundle, comment: "")
        }
        static var mensCollection: String {
            return NSLocalizedString("mensCollection", bundle: BundleLocalization.bundle, comment: "")
        }
        static var womansCollection: String {
            return NSLocalizedString("womansCollection", bundle: BundleLocalization.bundle, comment: "")
        }
        static var casual: String {
            return NSLocalizedString("casual", bundle: BundleLocalization.bundle, comment: "")
        }
    }
    
    struct CropScreen {
        private init() {}
        
        static var letsGo: String {
            return NSLocalizedString("letsGo", bundle: BundleLocalization.bundle, comment: "")
        }
    }
    
    struct ChooseCategoryScreen {
        private init() {}
        
        static var lastStep: String {
            return NSLocalizedString("lastStep", bundle: BundleLocalization.bundle, comment: "")
        }
        static var chooseCategory: String {
            return NSLocalizedString("chooseCategory", bundle: BundleLocalization.bundle, comment: "")
        }
        static var party: String {
            return NSLocalizedString("party", bundle: BundleLocalization.bundle, comment: "")
        }
        static var formal: String {
            return NSLocalizedString("formal", bundle: BundleLocalization.bundle, comment: "")
        }
        static var travel: String {
            return NSLocalizedString("travel", bundle: BundleLocalization.bundle, comment: "")
        }
        static var special: String {
            return NSLocalizedString("special", bundle: BundleLocalization.bundle, comment: "")
        }
        static var casual: String {
            return NSLocalizedString("casual", bundle: BundleLocalization.bundle, comment: "")
        }
        static var work: String {
            return NSLocalizedString("work", bundle: BundleLocalization.bundle, comment: "")
        }
        static var daily: String {
            return NSLocalizedString("daily", bundle: BundleLocalization.bundle, comment: "")
        }
        static var sport: String {
            return NSLocalizedString("sport", bundle: BundleLocalization.bundle, comment: "")
        }
        static var date: String {
            return NSLocalizedString("date", bundle: BundleLocalization.bundle, comment: "")
        }
        static var continueButton: String {
            return NSLocalizedString("continue", bundle: BundleLocalization.bundle, comment: "")
        }
    }
    
    struct ResultScreen {
        private init() {}
        
        static var result: String {
            return NSLocalizedString("result", bundle: BundleLocalization.bundle, comment: "")
        }
        static var stylingIdeas: String {
            return NSLocalizedString("stylingIdeas", bundle: BundleLocalization.bundle, comment: "")
        }
        static var saveToGallery: String {
            return NSLocalizedString("saveToGallery", bundle: BundleLocalization.bundle, comment: "")
        }
        static var moreIdeas: String {
            return NSLocalizedString("moreIdeas", bundle: BundleLocalization.bundle, comment: "")
        }
    }
    
    struct EnlargedPhoto {
        private init() {}
        
        static var holdToSeeOriginal: String {
            return NSLocalizedString("holdToSeeOriginal", bundle: BundleLocalization.bundle, comment: "")
        }
    }
    
    struct Collection {
        private init() {}
        
        static var delete: String {
            return NSLocalizedString("delete", bundle: BundleLocalization.bundle, comment: "")
        }
    }
    
    struct History {
        private init() {}
        
        static var history: String {
            return NSLocalizedString("history", bundle: BundleLocalization.bundle, comment: "")
        }
        static var today: String {
            return NSLocalizedString("today", bundle: BundleLocalization.bundle, comment: "")
        }
        static var yesterday: String {
            return NSLocalizedString("yesterday", bundle: BundleLocalization.bundle, comment: "")
        }
        static var daysAgo: String {
            return NSLocalizedString("daysAgo", bundle: BundleLocalization.bundle, comment: "")
        }
    }
    
    struct Onboarding {
        private init() {}
        
        static var continueButton: String {
            return NSLocalizedString("continue", bundle: BundleLocalization.bundle, comment: "")
        }
        static var ideasForYourImage: String {
            return NSLocalizedString("ideasForYourImage", bundle: BundleLocalization.bundle, comment: "")
        }
        static var withAI: String {
            return NSLocalizedString("withAI", bundle: BundleLocalization.bundle, comment: "")
        }
        static var tryDifferent: String {
            return NSLocalizedString("tryDifferent", bundle: BundleLocalization.bundle, comment: "")
        }
        static var trendyStyles: String {
            return NSLocalizedString("trendyStyles", bundle: BundleLocalization.bundle, comment: "")
        }
        static var GetAllApplication: String {
            return NSLocalizedString("GetAllApplication", bundle: BundleLocalization.bundle, comment: "")
        }
        static var getStarted: String {
            return NSLocalizedString("getStarted", bundle: BundleLocalization.bundle, comment: "")
        }
        static var _1Month: String {
            return NSLocalizedString("_1Month", bundle: BundleLocalization.bundle, comment: "")
        }
        static var _3dayFreeTrial: String {
            return NSLocalizedString("_3dayFreeTrial", bundle: BundleLocalization.bundle, comment: "")
        }
        static var than89Month: String {
            return NSLocalizedString("than89Month", bundle: BundleLocalization.bundle, comment: "")
        }
        static var skip: String {
            return NSLocalizedString("skip", bundle: BundleLocalization.bundle, comment: "")
        }
    }
    
    struct Saved {
        private init() {}
        
        static var saved: String {
            return NSLocalizedString("saved", bundle: BundleLocalization.bundle, comment: "")
        }
        static var outFits: String {
            return NSLocalizedString("outFits", bundle: BundleLocalization.bundle, comment: "")
        }
        static var hairstyles: String {
            return NSLocalizedString("hairstyles", bundle: BundleLocalization.bundle, comment: "")
        }
        static var repeatButton: String {
            return NSLocalizedString("repeat", bundle: BundleLocalization.bundle, comment: "")
        }
    }
    
    struct Paywall {
        private init() {}
        
        static var getFullAssess: String {
            return NSLocalizedString("getFullAssess", bundle: BundleLocalization.bundle, comment: "")
        }
        static var unlimitedGenerations: String {
            return NSLocalizedString("unlimitedGenerations", bundle: BundleLocalization.bundle, comment: "")
        }
        static var hdPhotoQuality: String {
            return NSLocalizedString("hdPhotoQuality", bundle: BundleLocalization.bundle, comment: "")
        }
        static var noWatermark: String {
            return NSLocalizedString("noWatermark", bundle: BundleLocalization.bundle, comment: "")
        }
        static var restore: String {
            return NSLocalizedString("restore", bundle: BundleLocalization.bundle, comment: "")
        }
        static var terms: String {
            return NSLocalizedString("terms", bundle: BundleLocalization.bundle, comment: "")
        }
        static var privacy: String {
            return NSLocalizedString("privacy", bundle: BundleLocalization.bundle, comment: "")
        }
        static var _1Month: String {
            return NSLocalizedString("_1Month", bundle: BundleLocalization.bundle, comment: "")
        }
        static var _1Year: String {
            return NSLocalizedString("_1Year", bundle: BundleLocalization.bundle, comment: "")
        }
        static var freeTrial: String {
            return NSLocalizedString("freeTrial", bundle: BundleLocalization.bundle, comment: "")
        }
        static var than: String {
            return NSLocalizedString("than", bundle: BundleLocalization.bundle, comment: "")
        }
        static var month: String {
            return NSLocalizedString("month", bundle: BundleLocalization.bundle, comment: "")
        }
        static var year: String {
            return NSLocalizedString("year", bundle: BundleLocalization.bundle, comment: "")
        }
        
    }
    
    struct Settings {
        private init() {}
        
        static var saved: String {
            return NSLocalizedString("saved", bundle: BundleLocalization.bundle, comment: "")
        }
        static var languages: String {
            return NSLocalizedString("languages", bundle: BundleLocalization.bundle, comment: "")
        }
        static var rateApp: String {
            return NSLocalizedString("rateApp", bundle: BundleLocalization.bundle, comment: "")
        }
        static var privacyPolicy: String {
            return NSLocalizedString("privacyPolicy", bundle: BundleLocalization.bundle, comment: "")
        }
        static var termsOfUse: String {
            return NSLocalizedString("termsOfUse", bundle: BundleLocalization.bundle, comment: "")
        }
    }
    
    struct Languages {
        private init() {}
        
        static var selectLanguage: String {
            return NSLocalizedString("selectLanguage", bundle: BundleLocalization.bundle, comment: "")
        }
        static var english: String {
            return NSLocalizedString("english", bundle: BundleLocalization.bundle, comment: "")
        }
        static var russian: String {
            return NSLocalizedString("russian", bundle: BundleLocalization.bundle, comment: "")
        }
        static var german: String {
            return NSLocalizedString("german", bundle: BundleLocalization.bundle, comment: "")
        }
        static var spanish: String {
            return NSLocalizedString("spanish", bundle: BundleLocalization.bundle, comment: "")
        }
        static var french: String {
            return NSLocalizedString("french", bundle: BundleLocalization.bundle, comment: "")
        }
        static var select: String {
            return NSLocalizedString("select", bundle: BundleLocalization.bundle, comment: "")
        }
        static var exit: String {
            return NSLocalizedString("exit", bundle: BundleLocalization.bundle, comment: "")
        }
    }
    
    struct NewCollection {
        private init() {}
        
        static var newCollection: String {
            return NSLocalizedString("newCollection", bundle: BundleLocalization.bundle, comment: "")
        }
        static var collectionTitle: String {
            return NSLocalizedString("collectionTitle", bundle: BundleLocalization.bundle, comment: "")
        }
        static var typeHere: String {
            return NSLocalizedString("typeHere", bundle: BundleLocalization.bundle, comment: "")
        }
        static var fromSaved: String {
            return NSLocalizedString("fromSaved", bundle: BundleLocalization.bundle, comment: "")
        }
        static var createNew: String {
            return NSLocalizedString("createNew", bundle: BundleLocalization.bundle, comment: "")
        }
    }
}
