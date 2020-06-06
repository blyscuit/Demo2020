//
//  DetailViewController.swift
//  Demo
//
//  Created by Pisit W on 6/6/2563 BE.
//  Copyright © 2563 confusians. All rights reserved.
//

import UIKit

class DetailContainerViewController: ImageTopSlideUpViewController {
    
    let _s1 = StoryboardViewController("Main", viewController: DetailImageViewController.id) as? DetailImageViewController
    let _s2 = StoryboardViewController("Main", viewController: DetailTextViewController.id) as? DetailTextViewController
    
    let viewModel = DetailViewModel()
    
    override func viewDidLoad() {
        
        s1 = _s1
        s2 = _s2
        
        super.viewDidLoad()
        
        viewModel.model.notify()
        drawer.changeUpperBoundHeight(newHeight: CGFloat.random(in: 150.0 ... 200.0), moveto: false)
        drawer.changeLowerBoundHeight(newHeight: CGFloat.random(in: 100.0 ... 700.0), moveto: true)
        
        addBackButton(color: .white, text: "Back")
    }
    
    override func addObserver() {
        super.addObserver()
        viewModel.model.addAndNotify(observer: self) { [weak self] (model) in
            guard let model = model, let `self` = self else { return }

            if let text = model.url, let url = URL(string: text) {
                self._s1?.mainImageView?.af_setImage(withURL: url)
            }
            self._s2?.titleLabel?.text = String(repeating: (model.title ?? "") + " ", count: 50)
        }
    }
}
