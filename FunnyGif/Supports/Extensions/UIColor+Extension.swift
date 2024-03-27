//
//  UIColor+Extension.swift
//  CustomCamera
//
//  Created by AppnapWS11 on 19/3/23.
//

import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
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
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    //    let color = UIColor(red: 0xFF, green: 0xFF, blue: 0xFF)
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    //    let color2 = UIColor(rgb: 0xFFFFFF)
    //    let semitransparentBlack = UIColor(rgb: 0x000000).withAlphaComponent(0.5)
    
    func UIColorToGrayScale() -> CGFloat{
        var white: CGFloat = 0
        var alpha: CGFloat = 0
        guard self.getWhite(&white, alpha: &alpha) else {
            
            return 0
        }
        return white
    }
    
}

//MARK: Color Theme
extension UIColor{
    static let theme = ColorTheme()
}

struct ColorTheme{
    
    /* Accent */
    let accentUIColor = UIColor(named: "AccentColor")
    
    /* Background */
    
    let accentBackgroundColor = UIColor(named: "AccentBackgroundColor")
    let tabBarBackgroundColor = UIColor(named: "TabBarColor")
    let dressUpPageButtonBackground = UIColor(named: "buttonBackground")
    
    /* Toast */
    
    /// - `Confirm`
    let toastConfirmBackgroundUIColor = UIColor(named: "toast_confirm_background")
    
    let toastConfirmBorderUIColor = UIColor(named: "toast_confirm_border")
    
    /// - `Destructive`
    let toastDestructiveBackgroundUIColor = UIColor(named: "toast_destructive_background")
    
    let toastDestructiveBorderUIColor = UIColor(named: "toast_destructive_border")
    
    /// - `Neutral`
    let toastNeutralBackgroundUIColor = UIColor(named: "toast_neutral_background")
    
    let toastNeutralBorderUIColor = UIColor(named: "toast_neutral_border")
}
