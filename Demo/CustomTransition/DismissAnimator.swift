//
//  DismissAnimator.swift
//  ThaiSmile
//
//  Created by Pisit W on 1/5/2562 BE.
//  Copyright © 2562 ekachai limpisoot. All rights reserved.
//

import UIKit

class DismissAnimator: NSObject {
}

extension DismissAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
//           , let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else {
                return
        }
        let containerView = transitionContext.containerView
//        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        let screenBounds = UIScreen.main.bounds
        let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
        
        UIView.animate(withDuration:
            transitionDuration(using: transitionContext),
            animations: {
                fromVC.view.frame = finalFrame
        },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        )
    }
}


class Interactor: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
}
