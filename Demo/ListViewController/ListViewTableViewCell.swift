//
//  ListViewTableViewCell.swift
//  Demo
//
//  Created by Pisit W on 6/6/2563 BE.
//  Copyright © 2563 confusians. All rights reserved.
//

import UIKit

class ListViewTableViewCell: UITableViewCell {

    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var titleLbale: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.selectionStyle = .blue
        
        titleLbale.setStyle(font: .systemFont(ofSize: 14), color: .gray4F4)
        dateLabel.setStyle(font: .systemFont(ofSize: 12), color: .gray828)
        timeLabel.setStyle(font: .systemFont(ofSize: 12), color: .gray828)
        iconView.backgroundColor = .dodgerBlue459
        self.backgroundColor = .primaryBackgroundF8F
        mainImageView.layer.cornerRadius = mainImageView.frame.size.height / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconView?.layer.cornerRadius = (iconView?.frame.size.height ?? 0)/2
    }
    
}
