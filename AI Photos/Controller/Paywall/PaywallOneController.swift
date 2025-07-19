//
//  PaywallOneController.swift
//  AI Photos
//
//  Created by Никита Горьковой on 29.11.24.
//
import UIKit
import ApphudSDK
import StoreKit

class PaywallOneController: PaywallController {
    
    var paywall: ApphudPaywall?
    var isMonthSelected = true
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet weak var yearButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var monthTrialLabel: UILabel!
    @IBOutlet weak var monthPriceLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var yearTrialLabel: UILabel!
    @IBOutlet weak var yearPriceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        update()
        
        Task {
            updateUI()
        }
        
        if let paywall = self.paywall {
                Apphud.paywallShown(paywall)
            }
        
        let buttons: [UIButton] = [
            monthButton, yearButton, continueButton, restoreButton, termsButton,
            privacyButton]
        
        buttons.forEach { button in
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.minimumScaleFactor = 0.5
        }
        
        monthLabel.attributedText = Constants.Paywall._1Month.styled(as: .SemiBold16)
        monthTrialLabel.attributedText = Constants.Paywall.freeTrial.styled(as: .Regular12)
        monthPriceLabel.attributedText = (Constants.Paywall.than + "-" + Constants.Paywall.month).styled(as: .Regular12)
        
        yearLabel.attributedText = Constants.Paywall._1Year.styled(as: .SemiBold16)
        yearTrialLabel.attributedText = Constants.Paywall.freeTrial.styled(as: .Regular12)
        yearPriceLabel.attributedText = (Constants.Paywall.than + "-" + Constants.Paywall.month).styled(as: .Regular12)
        
        firstLabel.attributedText = Constants.Paywall.getFullAssess.styled(as: .SemiBold24)
        secondLabel.attributedText = Constants.Paywall.unlimitedGenerations.styled(as: .Medium18)
        thirdLabel.attributedText = Constants.Paywall.hdPhotoQuality.styled(as: .Medium18)
        fourthLabel.attributedText = Constants.Paywall.noWatermark.styled(as: .Medium18)
        restoreButton.setAttributedTitle(Constants.Paywall.restore.styled(as: .Regular14), for: .normal)
        termsButton.setAttributedTitle(Constants.Paywall.terms.styled(as: .Regular14), for: .normal)
        privacyButton.setAttributedTitle(Constants.Paywall.privacy.styled(as: .Regular14), for: .normal)
        continueButton.setAttributedTitle(Constants.Onboarding.continueButton.styled(as: .SemiBold18), for: .normal)
        continueButton.layer.cornerRadius = 4
    }
    
    func update() {
        if isMonthSelected {
            monthButton.setBackgroundImage(.paywallButtonOn, for: .normal)
            yearButton.setBackgroundImage(.paywallButtonOff, for: .normal)
        } else {
            yearButton.setBackgroundImage(.paywallButtonOn, for: .normal)
            monthButton.setBackgroundImage(.paywallButtonOff, for: .normal)
        }
    }
    
   
    
    func updateUI() {
        guard let paywall = paywall else { return }
                let products = paywall.products
                
                guard products.count >= 2 else {
                    print("Недостаточно продуктов в paywall")
                    return
                }
        let topProduct = products[0]
        let bottomProduct = products[1]
        
        monthPriceLabel.attributedText = (Constants.Paywall.than + (topProduct.skProduct?.localizedPrice ?? "-") + Constants.Paywall.month).styled(as: .Regular12)
        yearPriceLabel.attributedText = (Constants.Paywall.than + (bottomProduct.skProduct?.localizedPrice ?? "-") + Constants.Paywall.year).styled(as: .Regular12)
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        guard let paywall = paywall else { return }
                let products = paywall.products
                guard products.count >= 2 else { return }
        guard let month = products.first(where: {$0.productId == "pro.subscription.monthly"}) else { return }
        guard let year = products.first(where: {$0.productId == "pro.subscription.yearly"}) else {return}
        if isMonthSelected {
            purchase(month)
        } else {
            purchase(year)
        }
    }
    
    @IBAction func monthButtonTapped(_ sender: Any) {
        isMonthSelected = true
        update()
    }
    
    @IBAction func yearButtonTapped(_ sender: Any) {
        isMonthSelected = false
        update()
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        if let paywall = self.paywall {
                Apphud.paywallClosed(paywall)
            }
        close()
    }
    
    @IBAction func restoreButtonTapped(_ sender: Any) {
        restorePurchases()
    }
    
    @IBAction func termsButtonTapped(_ sender: Any) {
        openURL(.terms)
    }
    
    @IBAction func privacyButtonTapped(_ sender: Any) {
        openURL(.privacy)
    }
}

public extension SKProduct {
    var localizedPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price)
    }
}
