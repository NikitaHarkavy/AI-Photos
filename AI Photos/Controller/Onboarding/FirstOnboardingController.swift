//
//  FirstOnboardingController.swift
//  AI Photos
//
//  Created by Никита Горьковой on 28.11.24.
//
import UIKit

class FirstOnboardingController: UIViewController {
    
    static let onboardingPaywallWillShow = Notification.Name("OnboardingPaywallWillShow")
    
    var tapCounter: Int = 0
    
    private var currentOffset: CGFloat = 0
    private var screenWidth: CGFloat {
            return UIScreen.main.bounds.width
        }
    let font = UIFont(name: "Inter-SemiBold", size: 26) ?? UIFont.systemFont(ofSize: 26, weight: .semibold)
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var paywallView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var trialLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var stack1: UIStackView!
    @IBOutlet weak var stack2: UIStackView!
    @IBOutlet weak var stack3: UIStackView!
    
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        closeButton.isHidden = true
        nextButton.setAttributedTitle(Constants.Onboarding.continueButton.styled(as: .SemiBold18), for: .normal)
        nextButton.layer.cornerRadius = 4
        skipButton.setAttributedTitle(Constants.Onboarding.skip.styled(as: .Regular17), for: .normal)
        skipButton.titleLabel?.adjustsFontSizeToFitWidth = true
        skipButton.titleLabel?.minimumScaleFactor = 0.5
        nextButton.titleLabel?.adjustsFontSizeToFitWidth = true
        nextButton.titleLabel?.minimumScaleFactor = 0.5
        stack1.isHidden = true
        stack2.isHidden = true
        stack3.isHidden = true
        secondLabel.attributedText = Constants.Paywall.unlimitedGenerations.styled(as: .Medium18)
        thirdLabel.attributedText = Constants.Paywall.hdPhotoQuality.styled(as: .Medium18)
        fourthLabel.attributedText = Constants.Paywall.noWatermark.styled(as: .Medium18)
        monthLabel.attributedText = Constants.Onboarding._1Month.styled(as: .SemiBold16)
        trialLabel.attributedText = Constants.Onboarding._3dayFreeTrial.styled(as: .Regular12)
        priceLabel.attributedText = Constants.Onboarding.than89Month.styled(as: .Regular12)
        
        paywallView.transform = CGAffineTransform(translationX: screenWidth, y: 0)
       
        let fullText = Constants.Onboarding.ideasForYourImage + Constants.Onboarding.withAI
        let firstWordRange = (fullText as NSString).range(of: Constants.Onboarding.ideasForYourImage)
        let secondWordRange = (fullText as NSString).range(of: Constants.Onboarding.withAI)
        let attributedString = NSMutableAttributedString(string: fullText)
        
        attributedString.addAttribute(.foregroundColor, value: UIColor.background, range: firstWordRange)
        attributedString.addAttribute(.font, value: font, range: firstWordRange)
        
        attributedString.addAttribute(.foregroundColor, value: UIColor.accent, range: secondWordRange)
        attributedString.addAttribute(.font, value: font, range: secondWordRange)
        
        firstLabel.attributedText = attributedString
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        let imageView1Offset = imageView1.bounds.width / 2 + screenWidth/2
        if tapCounter == 0 {
            
            let fullText = Constants.Onboarding.tryDifferent + Constants.Onboarding.trendyStyles
            let firstWordRange = (fullText as NSString).range(of: Constants.Onboarding.tryDifferent)
            let secondWordRange = (fullText as NSString).range(of: Constants.Onboarding.trendyStyles)
            let attributedString = NSMutableAttributedString(string: fullText)
            
            attributedString.addAttribute(.foregroundColor, value: UIColor.background, range: firstWordRange)
            attributedString.addAttribute(.font, value: font, range: firstWordRange)
            
            attributedString.addAttribute(.foregroundColor, value: UIColor.accent, range: secondWordRange)
            attributedString.addAttribute(.font, value: font, range: secondWordRange)
            
            firstLabel.attributedText = attributedString
            
            // Анимируем сдвиг
            UIView.animate(withDuration: 0.5, animations: {
                self.image1.image = .onboardingOff
                self.image2.image = .onboardingOn
                self.imageView1.transform = CGAffineTransform(translationX: -imageView1Offset, y: 0)
                self.imageView2.transform = CGAffineTransform(translationX: -imageView1Offset, y: 0)
                self.imageView3.transform = CGAffineTransform(translationX: -imageView1Offset, y: 0)
            })
        } else if tapCounter == 1 {
            let fullText = Constants.Onboarding.GetAllApplication + Constants.Onboarding.getStarted
            let firstWordRange = (fullText as NSString).range(of: Constants.Onboarding.GetAllApplication)
            let secondWordRange = (fullText as NSString).range(of: Constants.Onboarding.getStarted)
            let attributedString = NSMutableAttributedString(string: fullText)
            
            attributedString.addAttribute(.foregroundColor, value: UIColor.background, range: firstWordRange)
            attributedString.addAttribute(.font, value: font, range: firstWordRange)
            
            attributedString.addAttribute(.foregroundColor, value: UIColor.accent, range: secondWordRange)
            attributedString.addAttribute(.font, value: font, range: secondWordRange)
            
            firstLabel.attributedText = attributedString
            
            
            UIView.animate(withDuration: 0.5, animations: {
                self.stack1.isHidden = false
                self.stack2.isHidden = false
                self.stack3.isHidden = false
                self.closeButton.isHidden = false
                self.skipButton.isHidden = true
                self.image2.image = .onboardingOff
                self.image3.image = .onboardingOn
               // self.bottomConstraint.constant = 73
                self.topConstraint.isActive = false
                self.firstLabel.transform = CGAffineTransform(translationX: 0, y: -239)
                self.stack1.transform = CGAffineTransform(translationX: 0, y: -239)
                self.stack2.transform = CGAffineTransform(translationX: 0, y: -239)
                self.stack3.transform = CGAffineTransform(translationX: 0, y: -239)
                self.paywallView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.imageView2.transform = CGAffineTransform(translationX: -(self.imageView2.bounds.width + imageView1Offset), y: 0)
                self.imageView3.transform = CGAffineTransform(translationX: -(self.screenWidth + imageView1Offset), y: 0)
            })
        } else {
            
            let hideOnboarding = {
                SplashController.isOnboardingPassed = true
                let animator = UIViewPropertyAnimator(duration: 0.25, curve: UIView.AnimationCurve(rawValue: 7) ?? .easeInOut) {
                    AppDelegate.shared?.onboardingWindow?.transform = .init(translationX: 0, y: UIScreen.main.bounds.height)
                }
                animator.addCompletion { _ in
                    AppDelegate.shared?.onboardingWindow?.removeFromSuperview()
                    AppDelegate.shared?.onboardingWindow = nil
                }
                animator.startAnimation()
            }
            
            if !AppDelegate.isPremium{
                PaywallController.present(in: self, placementIdentifierId: .onboarding, completion: hideOnboarding)
            } else {
                hideOnboarding()
            }
        }
        
        tapCounter += 1

    }
    @IBAction func closeButtonPressed(_ sender: Any) {
        let hideOnboarding = {
            SplashController.isOnboardingPassed = true
            let animator = UIViewPropertyAnimator(duration: 0.25, curve: UIView.AnimationCurve(rawValue: 7) ?? .easeInOut) {
                AppDelegate.shared?.onboardingWindow?.transform = .init(translationX: 0, y: UIScreen.main.bounds.height)
            }
            animator.addCompletion { _ in
                AppDelegate.shared?.onboardingWindow?.removeFromSuperview()
                AppDelegate.shared?.onboardingWindow = nil
            }
            animator.startAnimation()
        }
        hideOnboarding()
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        let hideOnboarding = {
            SplashController.isOnboardingPassed = true
            let animator = UIViewPropertyAnimator(duration: 0.25, curve: UIView.AnimationCurve(rawValue: 7) ?? .easeInOut) {
                AppDelegate.shared?.onboardingWindow?.transform = .init(translationX: 0, y: UIScreen.main.bounds.height)
            }
            animator.addCompletion { _ in
                AppDelegate.shared?.onboardingWindow?.removeFromSuperview()
                AppDelegate.shared?.onboardingWindow = nil
            }
            animator.startAnimation()
        }
        hideOnboarding()
    }
}
