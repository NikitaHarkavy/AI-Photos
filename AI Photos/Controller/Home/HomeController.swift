//
//  FeedController.swift
//  AI Photos
//
//  Created by Никита Горьковой on 24.11.24.
//

import Foundation
import UIKit
import StoreKit

class HomeController: UIViewController {
    
    var collections: [Collection] = []
    var outFitsPatterns: [OutFitPattern] = []
    var hairstylesPatterns: [HairstylePattern] = []
    let languages = ["en", "ru", "de", "es", "fr"]
    var currentNewLanguage = LocalizationManager.shared.currentLanguage
    var defaultOptions = [
        Category(key: "Party",       title: Constants.ChooseCategoryScreen.party),
        Category(key: "Formal",       title: Constants.ChooseCategoryScreen.formal),
        Category(key: "Elegant",      title: Constants.ChooseCategoryScreen.travel),
        Category(key: "Special",        title: Constants.ChooseCategoryScreen.special),
        Category(key: "Casual",    title: Constants.ChooseCategoryScreen.casual),
        Category(key: "Work",      title: Constants.ChooseCategoryScreen.work),
        Category(key: "Romantic",      title: Constants.ChooseCategoryScreen.daily),
        Category(key: "Sport",       title: Constants.ChooseCategoryScreen.sport),
        Category(key: "Date",        title: Constants.ChooseCategoryScreen.date)
    ]
    
    var selectedOutFitFilterIndex: Int = 0 {
        didSet{
            collectionView.reloadData()
        }
    }
    var selectedHairstyleFilterIndex: Int = 0 {
        didSet{
            collectionView.reloadData()
        }
    }
    
    var currentMode: MainTabs = .home {
        didSet {
            updateMode()
        }
    }
    var isNeedToOutFit = false
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var getProButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var outFitButton: UIButton!
    @IBOutlet weak var hairstyleButton: UIButton!
    @IBOutlet weak var firstEmptyLable: UILabel!
    @IBOutlet weak var secondEmptyLable: UILabel!
    @IBOutlet weak var newOutFitButton: UIButton!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var blureView: UIView!
    @IBOutlet var mainTabsButtons: [UIButton]!
    @IBOutlet weak var collectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var burgerButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var outFitFilterButtons: [UIButton]!
    @IBOutlet var hairFilterButtons: [UIButton]!
    @IBOutlet weak var hairScrollView: UIScrollView!
    @IBOutlet weak var savedButton: UIButton!
    @IBOutlet weak var languagesButton: UIButton!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var settingsViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var dimmedView: UIView!
    @IBOutlet weak var languageDimmedView: UIView!
    @IBOutlet weak var selectLanguageLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var russianLabel: UILabel!
    @IBOutlet weak var germanLabel: UILabel!
    @IBOutlet weak var spanishLabel: UILabel!
    @IBOutlet weak var frenchLabel: UILabel!
    @IBOutlet weak var exitLanguageButton: UIButton!
    @IBOutlet weak var selectLanguageButton: UIButton!
    @IBOutlet var languageCheckboxs: [CheckboxView]!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var shortLanguageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateCollections),
            name: Collection.allUpdatedNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showPaywall),
            name: FirstOnboardingController.onboardingPaywallWillShow,
            object: nil
        )
        
        updateMode()
        updateCollections()
        checkCheckboxes()
        
        if isNeedToOutFit {
            currentMode = .outFit
            collectionView.reloadData()
        }
        
        outFitsPatterns = [
            
            // Girl Casual (category = defaultOptions[4])
            .init(name: "Urban comfort", isMan: false, modelImage: .modelGirlCasual1, image: .clothesGirlCasual1, category: defaultOptions[4]),
            .init(name: "Delicate chic", isMan: false, modelImage: .modelGirlCasual2, image: .clothesGirlCasual2, category: defaultOptions[4]),
            .init(name: "Summer tenderness", isMan: false, modelImage: .modelGirlCasual3, image: .clothesGirlCasual3, category: defaultOptions[4]),
//            .init(name: "test", isMan: false, modelImage: .modelGirlCasual4, image: .clothesGirlCasual4, category: defaultOptions[4]),
            .init(name: "Harmony of simplicity", isMan: false, modelImage: .modelGirlCasual5, image: .clothesGirlCasual5, category: defaultOptions[4]),
            .init(name: "Harmony of simplicity", isMan: false, modelImage: .modelGirlCasual6, image: .clothesGirlCasual6, category: defaultOptions[4]),
            .init(name: "Stylish look", isMan: false, modelImage: .modelGirlCasual7, image: .clothesGirlCasual7, category: defaultOptions[4]),
            .init(name: "Stylish look", isMan: false, modelImage: .modelGirlCasual8, image: .clothesGirlCasual8, category: defaultOptions[4]),
            .init(name: "Summer tenderness", isMan: false, modelImage: .modelGirlCasual9, image: .clothesGirlCasual9, category: defaultOptions[4]),

            // Girl Date (category = defaultOptions[8])
            .init(name: "The Mystery of the Evening Star", isMan: false, modelImage: .modelGirlDate1,   image: .clothesGirlDate1,   category: defaultOptions[8]),
            .init(name: "Sun glare on the water", isMan: false, modelImage: .modelGirlDate2,   image: .clothesGirlDate2,   category: defaultOptions[8]),
            .init(name: "Spicy wind", isMan: false, modelImage: .modelGirlDate3,   image: .clothesGirlDate3,   category: defaultOptions[8]),

            // Girl Elegant (category = defaultOptions[2])
            .init(name: "Flower of the evening", isMan: false, modelImage: .modelGirlElegant1, image: .clothesGirlElegant1, category: defaultOptions[2]),
            .init(name: "Moonlight", isMan: false, modelImage: .modelGirlElegant2, image: .clothesGirlElegant2, category: defaultOptions[2]),
            .init(name: "The Veil of Dreams", isMan: false, modelImage: .modelGirlElegant3, image: .clothesGirlElegant3, category: defaultOptions[2]),
            .init(name: "Scarlet Symphony", isMan: false, modelImage: .modelGirlElegant4, image: .clothesGirlElegant4, category: defaultOptions[2]),

            // Girl Formal (category = defaultOptions[1])
            .init(name: "Styling Success", isMan: false, modelImage: .modelGirlFormal1,  image: .clothesGirlFormal1,  category: defaultOptions[1]),
            .init(name: "Confident Charm", isMan: false, modelImage: .modelGirlFormal2,  image: .clothesGirlFormal2,  category: defaultOptions[1]),
            // Обратите внимание на "GiriFormal3":
            .init(name: "Reimagined Business", isMan: false, modelImage: .modelGirlFormal3,  image: .clothesGirlFormal3,  category: defaultOptions[1]),
            .init(name: "Minimalist Style", isMan: false, modelImage: .modelGirlFormal4,  image: .clothesGirlFormal4,  category: defaultOptions[1]),
            .init(name: "Reimagined Business", isMan: false, modelImage: .modelGirlFormal5,  image: .clothesGirlFormal5,  category: defaultOptions[1]),

            // Girl Party (category = defaultOptions[0])
            .init(name: "Berry under the stars", isMan: false, modelImage: .modelGirlParty1,   image: .clothesGirlParty1,   category: defaultOptions[0]),
            .init(name: "Pearl of the evening", isMan: false, modelImage: .modelGirlParty2,   image: .clothesGirlParty2,   category: defaultOptions[0]),

            // Girl Romantic (category = defaultOptions[6])
            .init(name: "Tenderness", isMan: false, modelImage: .modelGirlRomantic1, image: .clothesGirlRomantic1, category: defaultOptions[6]),
            // В списке было "Clothes GirlRomantic2" со скобом, убираем пробел для корректного имени:
            .init(name: "Dance of Lights", isMan: false, modelImage: .modelGirlRomantic2, image: .clothesGirlRomantic2, category: defaultOptions[6]),
            .init(name: "Tenderness", isMan: false, modelImage: .modelGirlRomantic3, image: .clothesGirlRomantic3, category: defaultOptions[6]),

            // Girl Special (category = defaultOptions[3])
            .init(name: "Bold freshness", isMan: false, modelImage: .modelGirlSpecial1,  image: .clothesGirlSpecial1,  category: defaultOptions[3]),
            .init(name: "Bold freshness", isMan: false, modelImage: .modelGirlSpecial2,  image: .clothesGirlSpecial2,  category: defaultOptions[3]),
            .init(name: "Sparks of expectation", isMan: false, modelImage: .modelGirlSpecial3,  image: .clothesGirlSpecial3,  category: defaultOptions[3]),
            .init(name: "Gentle touch", isMan: false, modelImage: .modelGirlSpecial4,  image: .clothesGirlSpecial4,  category: defaultOptions[3]),
            .init(name: "Sparks of expectation", isMan: false, modelImage: .modelGirlSpecial5,  image: .clothesGirlSpecial5,  category: defaultOptions[3]),

            // Girl Sport (category = defaultOptions[7])
            .init(name: "Sports whirlwind", isMan: false, modelImage: .modelGirlSport1,    image: .clothesGirlSport1,    category: defaultOptions[7]),
            // "GirSport2" → используем как есть:
            .init(name: "Energy of movements", isMan: false, modelImage: .modelGirlSport2,     image: .clothesGirlSport2,     category: defaultOptions[7]),
            .init(name: "Indomitable energy", isMan: false, modelImage: .modelGirlSport3,    image: .clothesGirlSport3,    category: defaultOptions[7]),
            .init(name: "Energy of movements", isMan: false, modelImage: .modelGirlSport4,    image: .clothesGirlSport4,    category: defaultOptions[7]),
            .init(name: "The tireless spark", isMan: false, modelImage: .modelGirlSport5,    image: .clothesGirlSport5,    category: defaultOptions[7]),

            // Girl Work (category = defaultOptions[5])
            .init(name: "Business fairy", isMan: false, modelImage: .modelGirlWork1,     image: .clothesGirlWork1,     category: defaultOptions[5]),
            .init(name: "Business Hurricane", isMan: false, modelImage: .modelGirlWork2,     image: .clothesGirlWork2,     category: defaultOptions[5]),
            .init(name: "Business Hurricane", isMan: false, modelImage: .modelGirlWork3,     image: .clothesGirlWork3,     category: defaultOptions[5]),
            .init(name: "Business Panther", isMan: false, modelImage: .modelGirlWork4,     image: .clothesGirlWork4,     category: defaultOptions[5]),

            // Men Casual (category = defaultOptions[4])
            .init(name: "Catcher of moments", isMan: true,  modelImage: .modelMenCasual1,    image: .clothesMenCasual1,    category: defaultOptions[4]),

            // Men Date (category = defaultOptions[8])
            .init(name: "Night Waltz", isMan: true,  modelImage: .modelMenDate1,      image: .clothesMenDate1,      category: defaultOptions[8]),
            .init(name: "Frozen elegance", isMan: true,  modelImage: .modelMenDate2,      image: .clothesMenDate2,      category: defaultOptions[8]),

            // Men Formal (category = defaultOptions[1])
            .init(name: "Storm of thoughts", isMan: true,  modelImage: .modelMenFormal1,    image: .clothesMenFormal1,    category: defaultOptions[1]),
            .init(name: "Mirror of success", isMan: true,  modelImage: .modelMenFormal2,    image: .clothesMenFormal2,    category: defaultOptions[1]),
            .init(name: "Style Cartographer", isMan: true,  modelImage: .modelMenFormal3,    image: .clothesMenFormal3,    category: defaultOptions[1]),

            // Men Party (category = defaultOptions[0])
            .init(name: "Wind of change", isMan: true,  modelImage: .modelMenParty1,     image: .clothesMenParty1,     category: defaultOptions[0]),
            .init(name: "Celestial Traveler", isMan: true,  modelImage: .modelMenParty2,     image: .clothesMenParty2,     category: defaultOptions[0]),
            .init(name: "Wind of change", isMan: true,  modelImage: .modelMenParty3,     image: .clothesMenParty3,     category: defaultOptions[0]),

            // Men Romantic (category = defaultOptions[6])
            // "Romantie1" → трактуем как Romantic1, но имя сохраняем как есть:
            .init(name: "Keeper of Time", isMan: true,  modelImage: .modelMenRomantic1,  image: .clothesMenRomantic1,  category: defaultOptions[6]),
            .init(name: "Keeper of Time", isMan: true,  modelImage: .modelMenRomantic2,  image: .clothesMenRomantic2,  category: defaultOptions[6]),

            // Men Special (category = defaultOptions[3])
            .init(name: "Classics of the era", isMan: true,  modelImage: .modelMenSpecial1,   image: .clothesMenSpecial1,   category: defaultOptions[3]),

            // Men Sport (category = defaultOptions[7])
            .init(name: "The grandeur of the mountains", isMan: true,  modelImage: .modelMenSport1,     image: .clothesMenSport1,     category: defaultOptions[7])
        ]

        
        hairstylesPatterns = [.init(name: "Wayvy French From 1920", isMen: false, hairStyleText: "WayvyFrenchBobvibesfrom1920", modelImage: .wavyFrenchBobVibesfrom1920),
                              .init(name: "Long Curly", isMen: false, hairStyleText: "LongCurly", modelImage: .longCurly),
                              .init(name: "Long Straight", isMen: false, hairStyleText: "LongStraight", modelImage: .longStraight),
                              .init(name: "Ponytail", isMen: false, hairStyleText: "Ponytail", modelImage: .ponytail),
                              .init(name: "Bob Cut", isMen: false, hairStyleText: "BobCut", modelImage: .bobCut),
                              .init(name: "Curly Bob", isMen: false, hairStyleText: "CurlyBob", modelImage: .curlyBob),
                              .init(name: "Longwavy", isMen: false, hairStyleText: "Longwavy", modelImage: .longWavy),
                              .init(name: "Buzz Cut", isMen: true, hairStyleText: "BuzzCut", modelImage: .buzzCut),
                              .init(name: "Undercut", isMen: true, hairStyleText: "UnderCut", modelImage: .underCut),
                              .init(name: "Pompadour", isMen: true, hairStyleText: "Pompadour", modelImage: .pompadour),
                              .init(name: "Slick Back", isMen: true, hairStyleText: "SlickBack", modelImage: .slickBack),
                              .init(name: "Curly Shag", isMen: true, hairStyleText: "CurlyShag", modelImage: .curlyShag),
                              .init(name: "Wavy Shag", isMen: true, hairStyleText: "WavyShag", modelImage: .wavyShag),
                              .init(name: "Faux Hawk", isMen: true, hairStyleText: "FauxHawk", modelImage: .fauxHawk),
                              .init(name: "Spiky", isMen: true, hairStyleText: "Spiky", modelImage: .spiky),
                              .init(name: "Combover", isMen: true, hairStyleText: "CombOver", modelImage: .combOver),
                              .init(name: "Hightight Fade", isMen: true, hairStyleText: "HighTightFade", modelImage: .highTightFade),
                              .init(name: "Man Bun", isMen: true, hairStyleText: "ManBun", modelImage: .manBun),
                              .init(name: "Low Fade", isMen: true, hairStyleText: "LowFade", modelImage: .lowFade),
                              .init(name: "Afro", isMen: true, hairStyleText: "Afro", modelImage: .afro),
                              
        ]
        
        let buttons: [UIButton] = [
            getProButton, homeButton, outFitButton, hairstyleButton, newOutFitButton,
            plusButton, historyButton, burgerButton, savedButton, languagesButton,
            rateButton, privacyButton, termsButton, exitLanguageButton, selectLanguageButton
        ]
        
        buttons.forEach { button in
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.minimumScaleFactor = 0.5 // Минимальное уменьшение шрифта (50%)
        }
        
        languageView.isHidden = true
        languageLabel.attributedText = Constants.Languages.selectLanguage.styled(as: .Medium18)
        englishLabel.attributedText = "English".styled(as: .Medium18)
        russianLabel.attributedText = "Russian".styled(as: .Medium18)
        germanLabel.attributedText = "German".styled(as: .Medium18)
        spanishLabel.attributedText = "Spanish".styled(as: .Medium18)
        frenchLabel.attributedText = "French".styled(as: .Medium18)
        
        
        
        selectLanguageButton.layer.cornerRadius = 4
        exitLanguageButton.layer.cornerRadius = 4
        selectLanguageButton.setAttributedTitle(Constants.Languages.select.styled(as: .SemiBold18), for: .normal)
        exitLanguageButton.setAttributedTitle(Constants.Languages.exit.styled(as: .SemiBold18), for: .normal)
        exitLanguageButton.layer.borderColor = UIColor.languageBorder.cgColor
        exitLanguageButton.layer.borderWidth = 1
        settingsViewConstraint.constant = -300
        languageDimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        languageDimmedView.isHidden = true
        dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimmedView.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeSideMenu))
        dimmedView.addGestureRecognizer(tapGesture)
        
        savedButton.setAttributedTitle(Constants.Settings.saved.styled(as: .Regular21), for: .normal)
        languagesButton.setAttributedTitle(Constants.Settings.languages.styled(as: .Regular21), for: .normal)
        rateButton.setAttributedTitle(Constants.Settings.rateApp.styled(as: .Regular21), for: .normal)
        privacyButton.setAttributedTitle(Constants.Settings.privacyPolicy.styled(as: .Regular21), for: .normal)
        termsButton.setAttributedTitle(Constants.Settings.termsOfUse.styled(as: .Regular21), for: .normal)
        titleLable.attributedText = Constants.Shared.outFit.styled(as: .SemiBold22)
        getProButton.layer.cornerRadius = 3
        getProButton.setAttributedTitle("Get Pro".styled(as: .SemiBold16), for: .normal)
        homeButton.setAttributedTitle(Constants.Shared.home.styled(as: .Medium16), for: .normal)
        homeButton.layer.cornerRadius = 4
        outFitButton.setAttributedTitle(Constants.Shared.outFit.styled(as: .Medium16), for: .normal)
        outFitButton.layer.cornerRadius = 4
        hairstyleButton.setAttributedTitle(Constants.Shared.hairstyle.styled(as: .Medium16), for: .normal)
        hairstyleButton.layer.cornerRadius = 4
        firstEmptyLable.attributedText = Constants.HomeScreen.buildYourFirstCollection.styled(as: .SemiBold20)
        secondEmptyLable.attributedText = Constants.HomeScreen.addTheFirstPhoto.styled(as: .Regular17)
        newOutFitButton.layer.cornerRadius = 4
        newOutFitButton.setAttributedTitle(Constants.HomeScreen.newOutfit.styled(as: .SemiBold17), for: .normal)
        buttonView.layer.cornerRadius = 3
        buttonView.layer.shadowRadius = 10
        buttonView.layer.shadowColor = UIColor.blure.cgColor
        buttonView.layer.shadowOffset = CGSize(width: 0, height: 0)
        buttonView.layer.shadowOpacity = 1
        collectionLabel.attributedText = Constants.HomeScreen.myCollections.styled(as: .Regular16)
        
        for (index, button) in outFitFilterButtons.enumerated() {
            if index > 2 {
                button.setAttributedTitle(defaultOptions[index - 3].title.styled(as: .Regular16), for: .normal)
            } else {
                switch index {
                case 1:
                    button.setAttributedTitle(Constants.OutFitAndHairScreen.mensCollection.styled(as: .Regular16), for: .normal)
                case 2:
                    button.setAttributedTitle(Constants.OutFitAndHairScreen.womansCollection.styled(as: .Regular16), for: .normal)
                default:
                    button.setAttributedTitle(Constants.OutFitAndHairScreen.all.styled(as: .Regular16), for: .normal)
                }
            }
        }
        
        for button in outFitFilterButtons {
            UIView.animate(withDuration: 0.3) {
                button.layer.cornerRadius = 5
                button.isSelected = false
                button.backgroundColor = .collectionBackground
                button.titleLabel?.textColor = .greyCollection
                button.titleLabel?.tintColor = .greyCollection
                button.setTitleColor(.greyCollection, for: .normal)
            }
        }
        
        let sender = outFitFilterButtons[0]
        UIView.animate(withDuration: 0.3) {
            sender.isSelected = true
            sender.backgroundColor = .genLabel
            sender.titleLabel?.textColor = .background
            sender.titleLabel?.tintColor = .background
            sender.setTitleColor(.background, for: .selected)
        }
        
        for (index, button) in hairFilterButtons.enumerated() {
            switch index {
            case 1:
                button.setAttributedTitle(Constants.OutFitAndHairScreen.mens.styled(as: .Regular16), for: .normal)
            default:
                button.setAttributedTitle(Constants.OutFitAndHairScreen.womens.styled(as: .Regular16), for: .normal)
            }
        }
        
        for button in hairFilterButtons {
            UIView.animate(withDuration: 0.3) {
                button.layer.cornerRadius = 5
                button.isSelected = false
                button.backgroundColor = .collectionBackground
                button.titleLabel?.textColor = .greyCollection
                button.titleLabel?.tintColor = .greyCollection
                button.setTitleColor(.greyCollection, for: .normal)
            }
        }
        
        let hairSender = hairFilterButtons[0]
        UIView.animate(withDuration: 0.3) {
            hairSender.isSelected = true
            hairSender.backgroundColor = .genLabel
            hairSender.titleLabel?.textColor = .background
            hairSender.titleLabel?.tintColor = .background
            hairSender.setTitleColor(.background, for: .selected)
        }
    }
    
    func checkCheckboxes() {
        for checkbox in languageCheckboxs {
            checkbox.checkedImage = UIImage.languageOn
            checkbox.uncheckedImage = UIImage.languageOff
            checkbox.isChecked = false
        }
        
        switch LocalizationManager.shared.currentLanguage {
        case "en":
            languageCheckboxs[0].isChecked = true
        case "ru":
            languageCheckboxs[1].isChecked = true
        case "de":
            languageCheckboxs[2].isChecked = true
        case "es":
            languageCheckboxs[3].isChecked = true
        case "fr":
            languageCheckboxs[4].isChecked = true
        default:
            languageCheckboxs[0].isChecked = true
        }
        
        let shortL = {
            switch LocalizationManager.shared.currentLanguage {
            case "en":
                return "ENG"
            case "ru":
                return "RUS"
            case "de":
                return "GER"
            case "es":
                return "SPA"
            case "fr":
                return "FRA"
            default:
                return "ENG"
            }
        }()
        shortLanguageLabel.attributedText = shortL.styled(as: .Medium14)
    }
    
    func updateEmptyView() {
        if currentMode == .home {
            if collections.isEmpty {
                emptyView.isHidden = false
                collectionLabel.isHidden = true
                plusButton.isHidden = true
            } else {
                emptyView.isHidden = true
                collectionLabel.isHidden = false
                plusButton.isHidden = false
            }
        } else {
            emptyView.isHidden = true
            collectionLabel.isHidden = true
            plusButton.isHidden = true
        }
    }
    
    func updateMode() {
        updateEmptyView()
        
        switch currentMode {
        case .home:
            UIView.animate(withDuration: 0.3) {
                self.collectionLabel.isHidden = false
                self.collectionViewConstraint.constant = 63
                self.scrollView.isHidden = true
                self.hairScrollView.isHidden = true
                self.historyButton.isHidden = true
                self.burgerButton.isHidden = false
                self.getProButton.isHidden = false
                self.titleLable.attributedText = Constants.Shared.outFit.styled(as: .SemiBold22)
                self.homeButton.backgroundColor = .accent
                self.homeButton.setTitleColor(.background, for: .normal)
                self.outFitButton.backgroundColor = .clear
                self.outFitButton.setTitleColor(.secondaryButton, for: .normal)
                self.hairstyleButton.backgroundColor = .clear
                self.hairstyleButton.setTitleColor(.secondaryButton, for: .normal)
            }
        case .outFit:
            UIView.animate(withDuration: 0.3) {
                self.collectionLabel.isHidden = true
                self.collectionViewConstraint.constant = 96
                self.scrollView.isHidden = false
                self.hairScrollView.isHidden = true
                self.historyButton.isHidden = false
                self.burgerButton.isHidden = true
                self.getProButton.isHidden = true
                self.titleLable.attributedText = Constants.OutFitAndHairScreen.virtualTryOn.styled(as: .SemiBold22)
                self.outFitButton.backgroundColor = .accent
                self.outFitButton.setTitleColor(.background, for: .normal)
                self.homeButton.backgroundColor = .clear
                self.homeButton.setTitleColor(.secondaryButton, for: .normal)
                self.hairstyleButton.backgroundColor = .clear
                self.hairstyleButton.setTitleColor(.secondaryButton, for: .normal)
            }
        case .hairStyle:
            UIView.animate(withDuration: 0.3) {
                self.collectionLabel.isHidden = true
                self.collectionViewConstraint.constant = 96
                self.scrollView.isHidden = true
                self.hairScrollView.isHidden = false
                self.historyButton.isHidden = false
                self.burgerButton.isHidden = true
                self.getProButton.isHidden = true
                self.titleLable.attributedText = Constants.OutFitAndHairScreen.hairstyle.styled(as: .SemiBold22)
                self.hairstyleButton.backgroundColor = .accent
                self.hairstyleButton.setTitleColor(.background, for: .normal)
                self.outFitButton.backgroundColor = .clear
                self.outFitButton.setTitleColor(.secondaryButton, for: .normal)
                self.homeButton.backgroundColor = .clear
                self.homeButton.setTitleColor(.secondaryButton, for: .normal)
            }
        }
        
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()

    }
    
    func toggleSideMenu() {
        if settingsViewConstraint.constant == 0 {
            self.languageView.isHidden = true
            dimmedView.isHidden = true
            settingsViewConstraint.constant = -300
        } else {
            checkCheckboxes()
            self.languageView.isHidden = true
            settingsViewConstraint.constant = 0
            dimmedView.isHidden = false
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func showPaywall() {
        PaywallController.present(in: self, placementIdentifierId: .main)
    }
    
    @objc func closeSideMenu() {
        self.languageView.isHidden = true
        settingsViewConstraint.constant = -300
        dimmedView.isHidden = true
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func updateCollections() {
        collections = Collection.all.values.sorted(by: { $0.creationDate > $1.creationDate })
        collectionView.reloadData()
        updateEmptyView()
    }
    
  
    
   
    
    @IBAction func languageExitButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.languageView.isHidden = true
            self.languageDimmedView.isHidden = true
        }
    }
    
    @IBAction func languageButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.languageView.isHidden.toggle()
            self.languageDimmedView.isHidden.toggle()
            self.checkCheckboxes()
        }
    }
    
    @IBAction func languageSelectButtonTapped(_ sender: Any) {
        guard LocalizationManager.shared.currentLanguage != currentNewLanguage else {
            return
        }
        LocalizationManager.shared.setLanguage(currentNewLanguage)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let navigationController = NavigationController(rootViewController: HomeController.instantiate())
            present(navigationController, animated: false)
        }
    }
    
    @IBAction func englishCheckboxTapped(_ sender: CheckboxView) {
        for checkbox in languageCheckboxs {
            checkbox.isChecked = false
        }
        sender.isChecked = true
        currentNewLanguage = languages[0]
    }
    
    @IBAction func germanCheckboxTapped(_ sender: CheckboxView) {
        for checkbox in languageCheckboxs {
            checkbox.isChecked = false
        }
        sender.isChecked = true
        currentNewLanguage = languages[2]
    }
    
    @IBAction func russianCheckboxTapped(_ sender: CheckboxView) {
        for checkbox in languageCheckboxs {
            checkbox.isChecked = false
        }
        sender.isChecked = true
        currentNewLanguage = languages[1]
    }
    
    @IBAction func frenchCheckboxTapped(_ sender: CheckboxView) {
        for checkbox in languageCheckboxs {
            checkbox.isChecked = false
        }
        sender.isChecked = true
        currentNewLanguage = languages[4]
    }
    
    @IBAction func spanishCheckboxTapped(_ sender: CheckboxView) {
        for checkbox in languageCheckboxs {
            checkbox.isChecked = false
        }
        sender.isChecked = true
        currentNewLanguage = languages[3]
    }
    
    @IBAction func historyButtonTapped(_ sender: Any) {
        let controller = HistoryController.instantiate()
        if currentMode == .outFit {
            controller.isOutFits = true
        } else {
            controller.isOutFits = false
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func burgerButtonTapped(_ sender: Any) {
        toggleSideMenu()
    }
    
    @IBAction func outFitFilterButtonTapped(_ sender: UIButton) {
        for button in outFitFilterButtons {
            UIView.animate(withDuration: 0.3) {
                button.isSelected = false
                button.backgroundColor = .collectionBackground
                button.titleLabel?.textColor = .greyCollection
                button.titleLabel?.tintColor = .greyCollection
                button.setTitleColor(.greyCollection, for: .normal)
            }
        }
        
        if sender == outFitFilterButtons[0] {
            selectedOutFitFilterIndex = 0
        } else if sender == outFitFilterButtons[1] {
            selectedOutFitFilterIndex = 1
        } else if sender == outFitFilterButtons[2] {
            selectedOutFitFilterIndex = 2
        } else {
            if let index = outFitFilterButtons.firstIndex(of: sender), index >= 3 {
                selectedOutFitFilterIndex = index
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            sender.isSelected = true
            sender.backgroundColor = .genLabel
            sender.titleLabel?.textColor = .background
            sender.titleLabel?.tintColor = .background
            sender.setTitleColor(.background, for: .selected)
        }
    }
   
    @IBAction func hairFilterButtonTapped(_ sender: UIButton) {
        for button in hairFilterButtons {
            UIView.animate(withDuration: 0.3) {
                button.isSelected = false
                button.backgroundColor = .collectionBackground
                button.titleLabel?.textColor = .greyCollection
                button.titleLabel?.tintColor = .greyCollection
                button.setTitleColor(.greyCollection, for: .normal)
            }
        }
        
        if sender == hairFilterButtons[0] {
            selectedHairstyleFilterIndex = 0
        } else {
            selectedHairstyleFilterIndex = 1
        }
        
        UIView.animate(withDuration: 0.3) {
            sender.isSelected = true
            sender.backgroundColor = .genLabel
            sender.titleLabel?.textColor = .background
            sender.titleLabel?.tintColor = .background
            sender.setTitleColor(.background, for: .selected)
        }
    }
    
    @IBAction func mainTabsButtonTapped(_ sender: UIButton) {
        switch sender {
        case homeButton:
            currentMode = .home
        case outFitButton:
            currentMode = .outFit
        case hairstyleButton:
            currentMode = .hairStyle
        default:
            print("error")
        }
    }
    
    @IBAction func newOutFitButtonTapped(_ sender: Any) {
        currentMode = .outFit
    }
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        let controller = NewCollectionController.instantiate()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func savedButtonTapped(_ sender: Any) {
        let controller = SavedController.instantiate()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func rateButtonTapped(_ sender: Any) {
        if let scene = view.window?.windowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    @IBAction func privacyButtonTapped(_ sender: Any) {
        openURL(.privacy)
    }
    
    @IBAction func termsButtonTapped(_ sender: Any) {
        openURL(.terms)
    }
    
    @IBAction func getProButtonTapped(_ sender: Any) {
        PaywallController.present(in: self, placementIdentifierId: .main)
    }
}

extension HomeController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch currentMode {
        case .home:
            return collections.count
        case .outFit:
            let filteredOutFitsPatterns = outFitsPatterns.filter { outFitsPattern in
                switch selectedOutFitFilterIndex {
                case 0:
                    return true
                case 1:
                    return outFitsPattern.isMan == true
                case 2:
                    return outFitsPattern.isMan == false
                default:
                    return outFitsPattern.category == defaultOptions[selectedOutFitFilterIndex - 3]
                }
            }
            return filteredOutFitsPatterns.count
        case .hairStyle:
            let filteredHairstylesPatterns = hairstylesPatterns.filter { hairstylePattern in
                if selectedHairstyleFilterIndex == 0 {
                    return hairstylePattern.isMen == false
                } else {
                    return hairstylePattern.isMen == true
                }
            }
            return filteredHairstylesPatterns.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(of: ClothingCollectionCell.self, for: indexPath)
        switch currentMode {
        case .home:
            let collection = collections[indexPath.item]
            if let first = collection.outFits.last {
                cell.imageView.image = first.image
            } else{
                if let first = collection.hairstyles.last {
                    cell.imageView.image = first.image
                } else {
                    Collection.deleteCollection(at: collection.id)
                    collectionView.reloadData()
                    collectionView.collectionViewLayout.invalidateLayout()
                    collectionView.layoutIfNeeded()
                }
            }
            
            cell.collectionLabel.attributedText = collection.name.styled(as: .Regular16)
            
        case .outFit:
            let filteredOutFitsPatterns = outFitsPatterns.filter { outFitsPattern in
                switch selectedOutFitFilterIndex {
                case 0:
                    return true
                case 1:
                    return outFitsPattern.isMan == true
                case 2:
                    return outFitsPattern.isMan == false
                default:
                    return outFitsPattern.category == defaultOptions[selectedOutFitFilterIndex - 3]
                }
            }
            let object = filteredOutFitsPatterns[indexPath.item]
            
            cell.imageView.image = object.modelImage
            cell.collectionLabel.attributedText = object.name.styled(as: .Regular16)
            
        case .hairStyle:
            let filteredHairstylesPatterns = hairstylesPatterns.filter { hairstylePattern in
                if selectedHairstyleFilterIndex == 0 {
                    return hairstylePattern.isMen == false
                } else {
                    return hairstylePattern.isMen == true
                }
            }
            let object = filteredHairstylesPatterns[indexPath.item]
            
            cell.imageView.image = object.modelImage
            cell.collectionLabel.attributedText = object.name.styled(as: .Regular16)
        }
        return cell
    }
}

extension HomeController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch currentMode {
        case .home:
            let collectionController = CollectionController.instantiate()
            let collection = collections[indexPath.item]
            collectionController.collection = collection
            self.navigationController?.pushViewController(collectionController, animated: true)
        case .outFit:
            guard AppDelegate.isPremium || OutFit.hasFreeOutFits else {
                PaywallController.present(in: self, placementIdentifierId: .main)
                return
            }
            
            let controller = PhotoSelectionController.instantiate()
            
            let filteredOutFitsPatterns = outFitsPatterns.filter { outFitsPattern in
                switch selectedOutFitFilterIndex {
                case 0:
                    return true
                case 1:
                    return outFitsPattern.isMan == true
                case 2:
                    return outFitsPattern.isMan == false
                default:
                    return outFitsPattern.category == defaultOptions[selectedOutFitFilterIndex - 3]
                }
            }
            let object = filteredOutFitsPatterns[indexPath.item]
            controller.patternImage = object.image
            controller.isOutFit = true
            controller.isMen = object.isMan
            controller.category = object.category
            controller.name = object.name
            self.navigationController?.pushViewController(controller, animated: true)
        case .hairStyle:
//            guard AppDelegate.isPremium || Hairstyle.hasFreeHairstyles else {
//                PaywallController.present(in: self, placementId: .main)
//                return
//            }
            
            let controller = PhotoSelectionController.instantiate()
            
            let filteredHairstylesPatterns = hairstylesPatterns.filter { hairstylePattern in
                if selectedHairstyleFilterIndex == 0 {
                    return hairstylePattern.isMen == false
                } else {
                    return hairstylePattern.isMen == true
                }
            }
            let object = filteredHairstylesPatterns[indexPath.item]
            controller.isOutFit = false
            controller.isMen = object.isMen
            controller.hairstyle = object.hairStyleText
            controller.name = object.name
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension HomeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let numberOfColumns: CGFloat = 2
        let totalSpacing = layout.sectionInset.left + (numberOfColumns - 1) * layout.minimumInteritemSpacing + layout.sectionInset.right
        let width = (UIScreen.main.bounds.width - totalSpacing) / numberOfColumns
        let height = width / 173 * 251
        return CGSize(width: width, height: height)
    }
}

enum MainTabs {
    case home, outFit, hairStyle
}

