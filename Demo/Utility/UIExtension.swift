//
//  UIExtension.swift
//  Demo
//
//  Created by Pisit W on 6/6/2563 BE.
//  Copyright © 2563 confusians. All rights reserved.
//

import UIKit

func HasTopNotch() -> Bool {
    if #available(iOS 13.0,  *) {
        return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0 > 20
    }else{
     return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
    }
}


extension UILabel {
    func setStyle(font: UIFont, color: UIColor) {
        self.font = font
        self.textColor = color
    }
}

extension UIButton {
    func setStyle(font: UIFont, color: UIColor) {
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = font
        self.setTitle(self.titleLabel?.text, for: .normal)
    }
    
}

extension UIColor {
    
    convenience init(hex:Int, alpha:CGFloat = 1.0) {
        self.init(
            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

func StoryboardViewController(_ name: String, viewController: String) -> UIViewController {
    return UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: viewController)
}

extension UIView {
    func addDropShadow(color: UIColor = UIColor.black, opacity: Float = 0.1, offSetX: Double, offSetY: Double, radius: CGFloat = 8) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: offSetX, height: offSetY)
        layer.shadowRadius = radius
    }
}
