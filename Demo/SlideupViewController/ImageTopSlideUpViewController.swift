//
//  ImageTopSlideUpViewController.swift
//  Demo
//
//  Created by Pisit W on 6/6/2563 BE.
//  Copyright © 2563 confusians. All rights reserved.
//

import UIKit

protocol ImageSizeDelegate {
    var didChangeImageSize: ((CGSize) -> ())? { get set }
}

class ImageTopSlideUpViewController: SlideUpViewController {

    var s1: BaseViewController!
    var s2: SlideChildViewController!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        s1 = StoryboardViewController("Temp", viewController: "s1") as! BaseViewController
//        s2 = StoryboardViewController("Temp", viewController: "s2") as! SCGSlideChildViewController
        
        setParentViewController(s1)
        setChildViewController(s2)
//        drawer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        if var s1 = s1 as? ImageSizeDelegate {
            s1.didChangeImageSize = { (size) in
                let ratio = size.height / size.width
                let height = (self.view.frame.size.height - 100) - (self.view.frame.size.width * ratio)
                self.drawer.changeLowerBoundHeight(newHeight: height, moveto: true, animation: false)
                self.drawer.alpha = 1
                self.drawer.resize()//.frame = CGRect(x: self.drawer.frame.origin.x, y: self.drawer.frame.origin.y, width: self.drawer.frame.size.width, height: self.drawer.frame)
            }
        }
    }
    
}
