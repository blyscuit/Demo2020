//
//  DrawerView.swift
//  Demo
//
//  Created by Pisit W on 6/6/2563 BE.
//  Copyright © 2563 confusians. All rights reserved.
//

import UIKit

@objc protocol DrawerDelegate: AnyObject {
    func willMoveUp(duration: Double)
    func willMoveDown(duration: Double)
    func movingAt(percentage: CGFloat)
    func endMovingAt(percentage: CGFloat)
    func willMoveTo(percentage: CGFloat, duration: Double)
}
class DrawerView: UIView {
    weak var drawerDelegate: DrawerDelegate!
    public var viewCornerRadius:CGFloat = 0
    public var viewBackgroundColor:UIColor = UIColor.clear
    
    
    // MARK: - Private properties
    private var dragViewAnimatedTopMargin:CGFloat = 25.0 // View fully visible (upper spacing)
    private var viewDefaultHeight:CGFloat = 80.0// View height when appear
    private var gestureRecognizer = UIPanGestureRecognizer()
    private var dragViewDefaultTopMargin:CGFloat!
    private var viewLastYPosition = 0.0
    private var navigationSize:CGFloat = 0.0
    private var _navBar: UINavigationBar?
    
    private var __scrollView: UIScrollView?
    
    required init(dragViewAnimatedTopSpace:CGFloat, viewDefaultHeightConstant:CGFloat, gesture: Bool = false, navBar: UINavigationBar? = nil)
    {
        dragViewAnimatedTopMargin = (dragViewAnimatedTopSpace + UIApplication.shared.statusBarFrame.height) + (HasTopNotch() ? 0.0 : 8.0)
        viewDefaultHeight = viewDefaultHeightConstant
        
        let screenSize: CGRect = UIScreen.main.bounds
        dragViewDefaultTopMargin = screenSize.height - viewDefaultHeight
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        if let navBar = navBar {
            _navBar = navBar
            navigationSize = navBar.frame.height
            super.init(frame: CGRect(x: 0, y:dragViewDefaultTopMargin , width: screenSize.width, height: screenSize.height - dragViewAnimatedTopMargin - navigationSize - statusBarHeight))
        } else {
            super.init(frame: CGRect(x: 0, y:dragViewDefaultTopMargin , width: screenSize.width, height: screenSize.height - dragViewAnimatedTopMargin - statusBarHeight))
        }
        
        
        self.backgroundColor = viewBackgroundColor//.withAlphaComponent(0.20) //
        self.layer.cornerRadius = self.viewCornerRadius
        
        self.clipsToBounds = true
        
        self.layoutIfNeeded()
        
        if (gesture) {
        gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.addGestureRecognizer(gestureRecognizer)
            gestureRecognizer.delegate = self
        }
        
    }
    
    func resize() {
//        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let screenSize: CGRect = UIScreen.main.bounds
        
        if let navBar = _navBar {
            navigationSize = navBar.frame.height
//            self.frame = CGRect(x: 0, y:dragViewDefaultTopMargin , width: screenSize.width, height: screenSize.height - dragViewAnimatedTopMargin - navigationSize - statusBarHeight)
            self.frame = CGRect(x: 0, y:dragViewDefaultTopMargin , width: screenSize.width, height: screenSize.height - dragViewAnimatedTopMargin)
        } else {
//            self.frame = CGRect(x: 0, y:dragViewDefaultTopMargin , width: screenSize.width, height: screenSize.height - dragViewAnimatedTopMargin - statusBarHeight)
            self.frame = CGRect(x: 0, y:dragViewDefaultTopMargin , width: screenSize.width, height: screenSize.height - dragViewAnimatedTopMargin)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    @IBAction func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            var newTranslation = CGPoint()
            var oldTranslation = CGPoint()
            
            newTranslation = gestureRecognizer.translation(in: self.superview)
            
            __scrollView?.isScrollEnabled = newTranslation.y <= 0.0
            
            if(!(newTranslation.y < 0 && self.frame.origin.y + newTranslation.y <= dragViewAnimatedTopMargin))
            {
                self.translatesAutoresizingMaskIntoConstraints = true
                self.center = CGPoint(x: self.center.x, y: self.center.y + newTranslation.y)
                if (newTranslation.y < 0)
                {
                    if("\(self.frame.size.width)" != "\(String(describing: self.superview?.frame.size.width))")
                    {
                        if self.frame.size.width >= (self.superview?.frame.size.width)!
                        {
                            self.frame = CGRect(x: self.frame.origin.x, y:self.frame.origin.y , width: self.frame.size.width, height: self.frame.size.height)
                        }
                        else{
                            self.frame = CGRect(x: self.frame.origin.x, y:self.frame.origin.y , width: self.frame.size.width, height: self.frame.size.height)
                        }
                    }
                }
                else
                {
                    if("\(self.frame.size.width)" != "\((self.superview?.frame.size.width)! - 20)")
                    {
                        self.frame = CGRect(x: self.frame.origin.x, y:self.frame.origin.y , width: self.frame.size.width, height: self.frame.size.height)
                    }
                }
                
                // self.layoutIfNeeded()
                gestureRecognizer.setTranslation(CGPoint.zero, in: self.superview)
                
                oldTranslation.y = newTranslation.y
            }
            else
            {
                self.frame.origin.y = dragViewAnimatedTopMargin
                self.isUserInteractionEnabled = false
            }
            drawerDelegate?.movingAt(percentage: 1 - ( (((self.frame.origin.y) + newTranslation.y) - dragViewAnimatedTopMargin) / (dragViewDefaultTopMargin - dragViewAnimatedTopMargin)) )
            
        }
        else if (gestureRecognizer.state == .ended)
        {
            
            self.isUserInteractionEnabled = true
            let vel = gestureRecognizer.velocity(in: self.superview)
            
            
            let finalY: CGFloat = 50.0
            let curY: CGFloat = self.frame.origin.y
            let distance: CGFloat = curY - finalY
            
            
            let springVelocity: CGFloat = 1.0 * vel.y / distance
            
            
            if(springVelocity > 0 && self.frame.origin.y <= dragViewAnimatedTopMargin)
            {
                self.frame = CGRect(x: 0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
                drawerDelegate?.endMovingAt(percentage: 1 - ( (((self.frame.origin.y)) - dragViewAnimatedTopMargin) / (dragViewDefaultTopMargin - dragViewAnimatedTopMargin)) )
                drawerDelegate?.willMoveTo(percentage: 1.0, duration: 0.0)
            }
            else if (springVelocity > 1)
            {
                
                if (self.frame.origin.y < (self.superview?.frame.size.height)!/3 && springVelocity < 7)
                {
                    drawerDelegate?.willMoveTo(percentage: 1.0, duration: 0.5)
                    UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                        if("\(self.frame.size.width)" != "\(String(describing: self.superview?.frame.size.width))")
                        {
                            self.frame = CGRect(x: 0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
                        }
                        
                        self.frame.origin.y = self.dragViewAnimatedTopMargin
                    }), completion: { (finished: Bool) in
                        self.drawerDelegate?.endMovingAt(percentage: 1 - ( (((self.frame.origin.y)) - self.dragViewAnimatedTopMargin) / (self.dragViewDefaultTopMargin - self.dragViewAnimatedTopMargin)) )
                    })
                }
                else
                {
                    drawerDelegate?.willMoveTo(percentage: 0.0, duration: 0.5)
                    UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                        
                        if(self.frame.size.width != (self.superview?.frame.size.width)! - 20)
                        {
                            self.frame = CGRect(x: 0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
                        }
                        
                        self.frame.origin.y = self.dragViewDefaultTopMargin
                    }), completion:  { (finished: Bool) in
                    self.drawerDelegate?.endMovingAt(percentage: 1 - ( (((self.frame.origin.y)) - self.dragViewAnimatedTopMargin) / (self.dragViewDefaultTopMargin - self.dragViewAnimatedTopMargin)) )
                    })
                }
            }
            else if (springVelocity > -1 && springVelocity < 1)// If Velocity zero remain at same position
            {
                let percentage = 1 - ( (((self.frame.origin.y)) - self.dragViewAnimatedTopMargin) / (self.dragViewDefaultTopMargin - self.dragViewAnimatedTopMargin))
                if (percentage >= 0.5)
                {
                    drawerDelegate?.willMoveTo(percentage: 1.0, duration: 0.5)
                    UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                        if("\(self.frame.size.width)" != "\(String(describing: self.superview?.frame.size.width))")
                        {
                            self.frame = CGRect(x: 0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
                        }
                        
                        self.frame.origin.y = self.dragViewAnimatedTopMargin
                    }), completion: { (finished: Bool) in
                        self.drawerDelegate?.endMovingAt(percentage: 1 - ( (((self.frame.origin.y)) - self.dragViewAnimatedTopMargin) / (self.dragViewDefaultTopMargin - self.dragViewAnimatedTopMargin)) )
                    })
                }
                else
                {
                    drawerDelegate?.willMoveTo(percentage: 0.0, duration: 0.5)
                    UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                        
                        if(self.frame.size.width != (self.superview?.frame.size.width)! - 20)
                        {
                            self.frame = CGRect(x: 0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
                        }
                        
                        self.frame.origin.y = self.dragViewDefaultTopMargin
                    }), completion:  { (finished: Bool) in
                    self.drawerDelegate?.endMovingAt(percentage: 1 - ( (((self.frame.origin.y)) - self.dragViewAnimatedTopMargin) / (self.dragViewDefaultTopMargin - self.dragViewAnimatedTopMargin)) )
                    })
                }
                
            }
            else
            {
                if("\(self.frame.size.width)" != "\(String(describing: self.superview?.frame.size.width))")
                {
                    self.frame = CGRect(x: 0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
                }
                drawerDelegate?.willMoveTo(percentage: 1.0, duration: 0.5)
                
                
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                    
                    self.frame.origin.y = self.dragViewAnimatedTopMargin
                }), completion: { (finished: Bool) in
                    self.drawerDelegate?.endMovingAt(percentage: 1 - ( (((self.frame.origin.y)) - self.dragViewAnimatedTopMargin) / (self.dragViewDefaultTopMargin - self.dragViewAnimatedTopMargin)) )
                })
            }
            viewLastYPosition = Double(self.frame.origin.y)
            
            self.addGestureRecognizer(gestureRecognizer)
        }
        
    }
    
    func toggleDrawer() {
        if(self.frame.origin.y == dragViewAnimatedTopMargin)
        {
            drawerClose()
            
        }
        else{
            drawerOpen()
        }
    }
    
    func drawerOpen() {
        if(self.frame.origin.y != dragViewAnimatedTopMargin)
        {
            drawerDelegate?.willMoveUp(duration: 0.5)
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                
                self.frame = CGRect(x:0, y:self.dragViewAnimatedTopMargin , width: UIScreen.main.bounds.width, height: self.frame.size.height)
                
            }), completion: nil)
        }
    }
    func drawerClose() {
        if(self.frame.origin.y == dragViewAnimatedTopMargin)
        {
            drawerDelegate?.willMoveDown(duration: 0.5)
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                
                self.frame = CGRect(x: 0, y:self.dragViewDefaultTopMargin , width: UIScreen.main.bounds.width, height: self.frame.size.height)
                
            }), completion: nil)
            
        }
    }
    
    func changeLowerBoundHeight(newHeight: CGFloat, moveto: Bool, animation: Bool = true) {
        viewDefaultHeight = newHeight
        let screenSize: CGRect = UIScreen.main.bounds
        dragViewDefaultTopMargin = screenSize.height - navigationSize - viewDefaultHeight
        if moveto {
            drawerDelegate?.willMoveDown(duration: animation ? 0.5 : 0.0)
            UIView.animate(withDuration: animation ? 0.5 : 0.0, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.2, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                
                self.frame = CGRect(x: 0, y:self.dragViewDefaultTopMargin , width: UIScreen.main.bounds.width, height: self.frame.size.height)
                
            }), completion: nil)
        }
    }
    
    func moveOutAndResetLowerBoundHeight(newHeight: CGFloat) {
        viewDefaultHeight = newHeight
        let screenSize: CGRect = UIScreen.main.bounds
        dragViewDefaultTopMargin = screenSize.height - navigationSize - viewDefaultHeight
            drawerDelegate?.willMoveDown(duration: 0.5)
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.0, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                
                self.frame = CGRect(x: 0, y:screenSize.height , width: UIScreen.main.bounds.width, height: self.frame.size.height)
            }), completion:  { (finished: Bool) in
                UIView.animate(withDuration: 0.3, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 0.2, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                    
                    self.frame = CGRect(x: 0, y:self.dragViewDefaultTopMargin , width: UIScreen.main.bounds.width, height: self.frame.size.height)
                    
                }), completion: nil)
            })
    }
    
    func changeUpperBoundHeight(newHeight: CGFloat, moveto: Bool) {
        dragViewAnimatedTopMargin = newHeight
        if moveto {
            drawerDelegate?.willMoveUp(duration: 0.5)
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                
                self.frame = CGRect(x: 0, y:self.dragViewAnimatedTopMargin , width: UIScreen.main.bounds.width, height: self.frame.size.height)
                
            }), completion: nil)
        }
    }
    
    var lowerLimit: CGFloat {
        get {
            return self.viewDefaultHeight
        }
    }
}


extension DrawerView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let otherGesture = otherGestureRecognizer as? UIPanGestureRecognizer, let scrollView = otherGesture.view as? UIScrollView {
            if let scrollView = scrollView as? UICollectionView { return false }
            __scrollView = scrollView
            return scrollView.contentOffset.y <= 0
        }
        return true
    }
    
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        //
//    }
}
