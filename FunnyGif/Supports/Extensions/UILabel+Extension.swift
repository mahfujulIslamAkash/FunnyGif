//
//  UILabel+Extension.swift
//  CustomCamera
//
//  Created by AppnapWS09 on 16/7/23.
//

import Foundation
import UIKit

extension UILabel {

    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = .center
        paragraphStyle.lineHeightMultiple = lineHeightMultiple

        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))


        // (Swift 4.1 and 4.0) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
    }
    
    func label(title: String = "",
               textColor: UIColor = UIColor.clear,
               lines: Int = 0,
               fontStyle: UIFont? = nil,
               backgroundColor: UIColor? = nil,
               allignment: NSTextAlignment = .center) -> UILabel {
        let finalFont = fontStyle?.withSize(UIScreen.main.bounds.width>528 ? fontStyle!.pointSize*1.5 : fontStyle!.pointSize)
        let label = UILabel()
        label.text = title
        label.textColor = textColor
        label.backgroundColor = backgroundColor
        label.font = finalFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = lines
        label.minimumScaleFactor = 0.7
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = allignment
        return label
    }
    
    func addTextDropShadow(shadowcolor: CGColor = UIColor.black.cgColor,
                           shadowRadius: CGFloat = 4.0,
                           shadowOpacity: Float = 1.0) {
        self.layer.shadowColor = shadowcolor
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.masksToBounds = false
    }
}

extension String {

    static func emojiFlag(for countryCode: String) -> String! {
        func isLowercaseASCIIScalar(_ scalar: Unicode.Scalar) -> Bool {
            return scalar.value >= 0x61 && scalar.value <= 0x7A
        }

        func regionalIndicatorSymbol(for scalar: Unicode.Scalar) -> Unicode.Scalar {
            precondition(isLowercaseASCIIScalar(scalar))

            return Unicode.Scalar(scalar.value + (0x1F1E6 - 0x61))!
        }

        let lowercasedCode = countryCode.lowercased()
        guard lowercasedCode.count == 2 else { return nil }
        guard lowercasedCode.unicodeScalars.reduce(true, { accum, scalar in accum && isLowercaseASCIIScalar(scalar) }) else { return nil }

        let indicatorSymbols = lowercasedCode.unicodeScalars.map({ regionalIndicatorSymbol(for: $0) })
        return String(indicatorSymbols.map({ Character($0) }))
    }
}
