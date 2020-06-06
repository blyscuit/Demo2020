//
//  PullLeftAnimationController.swift
//  CustomTransitionDemo
//
//  Created by Robert Ryan on 2/13/17.
//  Copyright © 2017 Robert Ryan. All rights reserved.
//

import UIKit

class FadeAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum TransitionType {
        case presenting
        case dismissing
    }
    
    let transitionType: TransitionType
    
    init(transitionType: TransitionType) {
        self.transitionType = transitionType
        
        super.init()
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let inView   = transitionContext.containerView
        let toView   = transitionContext.viewController(forKey: .to)!.view!
        let fromView = transitionContext.viewController(forKey: .from)!.view!
        
        fromView.alpha = 1.0
        toView.alpha = 0.0
        
        inView.addSubview(toView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView.alpha = 1.0
            toView.alpha = 1.0
        }, completion: { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.33
    }
}

class FadeTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    
    weak var interactionController: UIPercentDrivenInteractiveTransition?
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeAnimationController(transitionType: .presenting)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeAnimationController(transitionType: .dismissing)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
}
