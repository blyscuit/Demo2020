//
//  BaseViewController.swift
//  Demo
//
//  Created by Pisit W on 6/6/2563 BE.
//  Copyright © 2563 confusians. All rights reserved.
//

import UIKit


class BaseViewController: UIViewController {

    var onFinish: (()->Void)?
    
    var presentationDelegate: CustomPresentationDelegate?
    
    var interactionController: UIPercentDrivenInteractiveTransition?
    
    let customTransitionDelegate = TransitioningDelegate()
    
    var interactor:Interactor? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
        
        // Do any additional setup after loading the view.
        
        if navigationController?.children.count ?? 1 < 1 {
            addBackButton()
        }
        
    }
    
    func addObserver() {
        
    }
    
    var bbt_back: UIBarButtonItem?
    func addBackButton(color: UIColor = UIColor.white, text: String? = nil) {
        bbt_back = UIBarButtonItem(title: text, style: .plain, target: self, action: #selector(backPress))
        bbt_back?.tintColor = color
        navigationItem.leftBarButtonItem = bbt_back
    }
    

    @objc func backPress() {
        var nav = navigationController
        while nav?.navigationController != nil {
            nav = nav?.navigationController!
        }
        if let children = nav?.children.count, children > 1 {
            nav?.popViewController(animated: true)
        } else {
            nav?.dismiss(animated: true, completion: nil)
        }
    }

    enum SwipeBackType {case Full, Edge, None }

}

enum SwipeBackType {case Full, Edge, None }

extension UIViewController {
    
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, transition: CATransition, completion: (() -> Void)? = nil) {
        view.window!.layer.add(transition, forKey: kCATransition)
        present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    func presentFromRightToLeft(_ viewControllerToPresent: UIViewController, animated flag: Bool, addSwipeBack: SwipeBackType = .None, completion: (() -> Void)? = nil) {
        viewControllerToPresent.modalPresentationStyle = .custom
        if let _selfVC = self as? PresentableWithCustomPercentageAnimation, let _viewControllerToPresent = viewControllerToPresent as? PresentableWithCustomPercentageAnimation {
            if let navVC = _viewControllerToPresent as? UINavigationController, let childVC = navVC.children.first as? BaseViewController, let _selfBase = _selfVC as? BaseViewController {
                childVC.presentationDelegate = _selfBase
            }
            _viewControllerToPresent.presentationDelegate = _selfVC as? CustomPresentationDelegate
            _selfVC.interactionController = UIPercentDrivenInteractiveTransition()
            _selfVC.interactionController?.wantsInteractiveStart = false
            if #available(iOS 11, *) {
                _viewControllerToPresent.customTransitionDelegate.interactionController = _selfVC.interactionController
            }
            viewControllerToPresent.transitioningDelegate = _viewControllerToPresent.customTransitionDelegate
            viewControllerToPresent.addSwipeBackGesture(addSwipeBack)
        }
        
        present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    func addSwipeBackGesture(_ swipeBackType: SwipeBackType) {
        if swipeBackType == .None { return }
        guard let _viewControllerToPresent = self as? PresentableWithCustomPercentageAnimation else { return }
        var edge: UIGestureRecognizer!
        if swipeBackType == .Full {
            edge = UIPanGestureRecognizer(target: self, action: #selector(_viewControllerToPresent.handleGesture(_:)))
        } else if swipeBackType == .Edge {
            let _edge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(_viewControllerToPresent.handleGesture(_:)))
            _edge.edges = [.left]
            edge = _edge
        }
        if let navi = self as? UINavigationController {
            navi.children.first?.view.addGestureRecognizer(edge)
        } else {
            self.view.addGestureRecognizer(edge)
        }
    }
    
    func dismiss(animated flag: Bool, transition: CATransition, completion: (() -> Void)? = nil) {
        view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: flag, completion: completion)
    }
    
    @objc func dismissFromLeftToRight(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismiss(animated: true, completion: completion)
    }
}

extension BaseViewController: PresentableWithCustomPercentageAnimation {
    
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
            if (percent > 0.5 && velocity.x >= 0) || velocity.x > 800 {
                interactionController?.finish()
                presentationDelegate?.viewControllerDidDismissed(self)
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
        }
    }
    
}

extension BaseViewController: CustomPresentationDelegate {
    func viewControllerDidDismissed(_ fromVC: UIViewController) {
        self.viewWillAppear(true)
        self.viewDidAppear(true)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        self.presentationDelegate?.viewControllerDidDismissed(self)
    }
    
}

protocol RTLocalizable {
    func performLocalization()
}
