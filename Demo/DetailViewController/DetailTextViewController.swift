//
//  DetailTextViewController.swift
//  Demo
//
//  Created by Pisit W on 6/6/2563 BE.
//  Copyright © 2563 confusians. All rights reserved.
//

import UIKit

class DetailTextViewController: SlideChildViewController {
    @IBOutlet weak var titleLabel: UILabel!
    static let id = "DetailTextViewController"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .grayBDB
        view.clipsToBounds = false
        view.layer.cornerRadius = 10
        view.addDropShadow(offSetX: 0, offSetY: -4)
    }
}
