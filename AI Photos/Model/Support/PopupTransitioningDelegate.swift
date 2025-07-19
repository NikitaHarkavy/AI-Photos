//
//  PopupTransitioningDelegate.swift
//  AICombine
//
//  Created by Mikhail Verenich on 12.03.2024.
//

import UIKit

class PopupTransitioningDelegate: NSObject {
    
    private var isPresenting = true
    
}

extension PopupTransitioningDelegate: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PopupPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}

extension PopupTransitioningDelegate: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromController = transitionContext.viewController(forKey: .from),
            let toController = transitionContext.viewController(forKey: .to)
        else {
            transitionContext.completeTransition(false)
            return
        }
        let fromControllerFinalFrame = transitionContext.finalFrame(for: fromController)
        let toControllerFinalFrame = transitionContext.finalFrame(for: toController)
        
        if isPresenting {
            toController.view.frame = toControllerFinalFrame
            toController.view.layer.cornerRadius = 16
            toController.view.transform = .init(translationX: 0, y: toControllerFinalFrame.height)
            toController.view.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
            transitionContext.containerView.addSubview(toController.view)
        }
        
        let curve = UIView.AnimationCurve(rawValue: 7) ?? .easeInOut
        let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), curve: curve) {
            if self.isPresenting {
                toController.view.transform = .identity
            } else {
                fromController.view.transform = .init(translationX: 0, y: fromControllerFinalFrame.height)
            }
        }
        animator.addCompletion { _ in
            if !self.isPresenting {
                fromController.view.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        animator.startAnimation()
    }
    
}

class PopupPresentationController: UIPresentationController {
    
    private let dimmingView: UIView
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let containerViewFrame = super.frameOfPresentedViewInContainerView
        guard let contentSize = presentedView?.systemLayoutSizeFitting(containerViewFrame.size, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel) else {
            return containerViewFrame
        }
        let size = CGSize(width: contentSize.width, height: contentSize.height + presentingViewController.view.safeAreaInsets.bottom)
        let origin = CGPoint(x: 0, y: containerViewFrame.height - size.height)
        return .init(origin: origin, size: size)
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        dimmingView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        dimmingView.alpha = 0
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        dimmingView.frame = containerView?.bounds ?? .zero
        dimmingView.alpha = 0
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPresented))
        dimmingView.addGestureRecognizer(tapGestureRecognizer)
        
        containerView?.insertSubview(dimmingView, at: 0)
        
        if let transitionCoordinator = presentedViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { context in
                self.dimmingView.alpha = 1
            }, completion: nil)
        } else {
            self.dimmingView.alpha = 1
        }
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        
        if !completed {
            dimmingView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        if let transitionCoordinator = presentedViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { context in
                self.dimmingView.alpha = 0
            }, completion: nil)
        } else {
            dimmingView.alpha = 0
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
    
    @objc private func dismissPresented() {
        presentedViewController.dismiss(animated: true)
    }
    
}
