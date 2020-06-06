//
//  SlideChildViewController.swift
//  Demo
//
//  Created by Pisit W on 6/6/2563 BE.
//  Copyright © 2563 confusians. All rights reserved.
//

import UIKit

// scrollview delegate
class SlideChildViewController: BaseViewController {
    var model: Any!
    var __scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findScrollView(view: self.view)
        __scrollView?.isScrollEnabled = false
        __scrollView?.delegate = self
        
        view.backgroundColor = .clear
    }
    
    func findScrollView(view: UIView) {
        if let view = view as? UITableView {
            view.backgroundColor = .clear
            self.__scrollView = view
//            return view
        } else if let view = view as? UIScrollView {
            self.__scrollView = view
//            return view
        } else {
            if view.subviews.count > 0 {
                for view in view.subviews {
                    findScrollView(view: view)
                }
//                return nil
            } else {
//                return nil
            }
        }
        
    }
    
    func toggleScrollView(_ on: Bool) {
        __scrollView?.isScrollEnabled = on
    }
    
    var tapMoveToggle: (() -> Void)?
    
    var slideShouldMoveToHeight: ((CGFloat) -> Void)?
    
}

extension SlideChildViewController: SlideUpViewChildren {
    func slideMovingTo(percentage: CGFloat, duration: Double) {
        
    }
    
    func slideDidMoveto(percentage: CGFloat) {
        
    }
    
    func slideDidMoveUp(duration: Double) {
        toggleScrollView(true)
    }
    
    func slideDidMoveDown(duration: Double) {
        toggleScrollView(false)
    }
    func slideMovingAt(percentage: CGFloat) {
        toggleScrollView(percentage >= 0.8)
//        __scrollView?.showsVerticalScrollIndicator = percentage >= 1
//        __scrollView?.subviews.first?.backgroundColor = UIColor(red: percentage, green: 0, blue: 1, alpha: 1)
    }
    
}


extension SlideChildViewController: UIScrollViewDelegate {
}
