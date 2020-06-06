//
//  TransparentViewController.swift
//  Demo
//
//  Created by Pisit W on 6/6/2563 BE.
//  Copyright © 2563 confusians. All rights reserved.
//

import UIKit

class TransparentViewController: UINavigationController, PresentableWithCustomPercentageAnimation {

    var presentationDelegate: CustomPresentationDelegate?
    
    var interactionController: UIPercentDrivenInteractiveTransition?
    
    var customTransitionDelegate = TransitioningDelegate()
    
    
        lazy var colorView = { () -> UIView in
            let view = UIView()
            view.isUserInteractionEnabled = false
            navigationBar.addSubview(view)
            navigationBar.sendSubviewToBack(view)
            return view
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
    //        configNavigationBar()
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            clearNavigationBar()

        }

        func clearNavigationBar() {
            // 1 status bar
            colorView.frame = CGRect(x: 0, y: -UIApplication.shared.statusBarFrame.height, width: navigationBar.frame.width, height: UIApplication.shared.statusBarFrame.height)
            
            navigationBar.layer.backgroundColor = UIColor.clear.cgColor
            colorView.backgroundColor = .clear
            self.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationBar.shadowImage = UIImage()
            self.navigationBar.isTranslucent = true
            self.view.backgroundColor = .clear
            
            
            if #available(iOS 13.0, *) {
                self.navigationBar.standardAppearance.backgroundColor = .clear
                self.navigationBar.standardAppearance.backgroundEffect = .none
                self.navigationBar.standardAppearance.shadowColor = .clear
            }
        }
    
    func handleGesture(_ gesture: UIPanGestureRecognizer) {
        let translate = gesture.translation(in: gesture.view)
        let percent   = translate.x / gesture.view!.bounds.size.height
        
        if gesture.state == .began {
            interactionController = UIPercentDrivenInteractiveTransition()
            customTransitionDelegate.interactionController = interactionController
            
            dismiss(animated: true)
        } else if gesture.state == .changed {
            interactionController?.update(percent)
        } else if gesture.state == .ended {
            let velocity = gesture.velocity(in: gesture.view)
            interactionController?.completionSpeed = 0.999  // https://stackoverflow.com/a/42972283/1271826
            if (percent > 0.5 && velocity.x >= 0) || velocity.x > ((gesture.isKind(of: UIScreenEdgePanGestureRecognizer.self)) ? 800 : 1000) {
                interactionController?.finish()
                presentationDelegate?.viewControllerDidDismissed(self)
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
        }
    }
    
}
