//
//  UIViewController+Extension.swift
//  WalkiTalki-Redesign
//
//  Created by AppnapWS09 on 29/2/24.
//

import UIKit

extension UIViewController {
    //MARK: - DISMISS KEYBOARD BY TAPING ANYWHERE IN THE SCREEN
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
