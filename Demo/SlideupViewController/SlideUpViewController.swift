//
//  SlideUpViewController.swift
//  Demo
//
//  Created by Pisit W on 6/6/2563 BE.
//  Copyright © 2563 confusians. All rights reserved.
//

import UIKit

@objc protocol SlideUpViewChildren {
    @objc optional func slideDidMoveto(percentage: CGFloat)
    @objc optional func slideDidMoveUp(duration: Double)
    @objc optional func slideDidMoveDown(duration: Double)
    @objc optional func slideMovingAt(percentage: CGFloat)
    @objc optional func slideMovingTo(percentage: CGFloat, duration: Double)
    @objc var tapMoveToggle: (() -> Void)? {get set}
    @objc var slideShouldMoveToHeight: ((_ height: CGFloat) -> Void)? {get set}
}

class SlideUpViewController: BaseViewController {
    lazy var drawer: DrawerView! = {
        let d = DrawerView(dragViewAnimatedTopSpace: 26, viewDefaultHeightConstant: 150, gesture: true, navBar: self.navigationController?.navigationBar)
        d.drawerDelegate = self
        return d
    }()
    var childView: SlideUpViewChildren!
    var parentView: SlideUpViewChildren!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.addSubview(drawer)
        
    }
    
    func setChildViewController(_ controller: UIViewController) {
        addChild(controller)
        controller.view.frame = drawer.bounds
        drawer.addSubview(controller.view)
        controller.view.topAnchor.constraint(equalTo: drawer.topAnchor, constant: 0).isActive = true
        controller.view.rightAnchor.constraint(equalTo: drawer.rightAnchor, constant: 0).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: drawer.bottomAnchor, constant: 0).isActive = true
        controller.view.leftAnchor.constraint(equalTo: drawer.leftAnchor, constant: 0).isActive = true
        if let _ = controller as? SlideUpViewChildren {
            var slideVC = controller as! SlideUpViewChildren
            childView = slideVC
            slideVC.tapMoveToggle = { [unowned self] () -> Void in
                self.drawer.toggleDrawer()
            }
            slideVC.slideShouldMoveToHeight = { [unowned self] (_ height: CGFloat) -> Void in
                self.drawer.moveOutAndResetLowerBoundHeight(newHeight: height)
            }
        }
        controller.didMove(toParent: self)
        drawer.clipsToBounds = false
    }
    
    func setParentViewController(_ controller: UIViewController) {
        addChild(controller)
        controller.view.frame = view.bounds
        view.insertSubview(controller.view, at: 0)
        if let _ = controller as? SlideUpViewChildren {
            var slideVC = controller as! SlideUpViewChildren
            parentView = slideVC
            slideVC.tapMoveToggle = { [unowned self] () -> Void in
                self.drawer.toggleDrawer()
            }
        }
        controller.didMove(toParent: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SlideUpViewController: DrawerDelegate {
    func willMoveTo(percentage: CGFloat, duration: Double) {
        childView?.slideMovingTo?(percentage: percentage, duration: duration)
        parentView?.slideMovingTo?(percentage: percentage, duration: duration)
    }
    
    func endMovingAt(percentage: CGFloat) {
//        print(percentage)
        childView?.slideDidMoveto?(percentage: percentage)
        parentView?.slideDidMoveto?(percentage: percentage)
                if percentage >= 1 {
                    childView?.slideDidMoveUp?(duration: 0)
                    parentView?.slideDidMoveUp?(duration: 0)
                } else if percentage <= 0 {
                    childView?.slideDidMoveDown?(duration: 0)
                    parentView?.slideDidMoveDown?(duration: 0)
                }
    }
    
    func willMoveUp(duration: Double) {
        childView?.slideDidMoveUp?(duration: duration)
        parentView?.slideDidMoveUp?(duration: duration)
    }
    func willMoveDown(duration: Double) {
        childView?.slideDidMoveDown?(duration: duration)
        parentView?.slideDidMoveDown?(duration: duration)
    }
    func movingAt(percentage: CGFloat) {
        childView?.slideMovingAt?(percentage: percentage)
        parentView?.slideMovingAt?(percentage: percentage)
//        print(percentage)
        if percentage >= 1 {
            childView?.slideDidMoveUp?(duration: 0)
            parentView?.slideDidMoveUp?(duration: 0)
        } else if percentage <= 0 {
            childView?.slideDidMoveDown?(duration: 0)
            parentView?.slideDidMoveDown?(duration: 0)
        }
    }
}
