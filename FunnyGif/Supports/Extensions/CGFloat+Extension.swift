//
//  CGFloat+Extension.swift
//  WalkiTalki-Redesign
//
//  Created by Appnap WS04 on 28/2/24.
//

import UIKit

///
extension CGFloat{
    init(w: CGFloat, for h: CGFloat = 0){
        if UIDevice.current.userInterfaceIdiom == .pad { //iPad 10.2 (8th Gen): 810 ╳ 1080
            if h > 0{
                self.init(.init(h: h) * w / h)
            }else{
                self.init(w / 810 * UIScreen.main.bounds.size.width)
            }
        }else{
            if h > 0{
                self.init(.init(h: h) * w / h)
            }else{
                self.init(w / 414 * UIScreen.main.bounds.size.width)
            }
        }
    }
    
    init(h: CGFloat, for w: CGFloat = 0){
        if UIDevice.current.userInterfaceIdiom == .pad { //iPad 10.2 (8th Gen): 810 ╳ 1080
            if w > 0{
                self.init(.init(w: w) * h / w)
            }else{
                self.init(h / 1080 * UIScreen.main.bounds.size.height)
            }
        }else{
            if w > 0{
                self.init(.init(w: w) * h / w)
            }else{
                self.init(h / 896 * UIScreen.main.bounds.size.height)
            }
        }
    }
}

