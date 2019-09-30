//
//  Extensions.swift
//  tbtApp
//
//  Created by Selin Ersev on 1.08.2018.
//  Copyright © 2018 Selin Ersev. All rights reserved.
//

import UIKit


extension UIView {
    func toImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else{return nil}
        self.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
}

//extension UIApplication {
//    
//    var statusBarView: UIView? {
//        return value(forKey: "statusBar") as? UIView
//    }
//    
//}
