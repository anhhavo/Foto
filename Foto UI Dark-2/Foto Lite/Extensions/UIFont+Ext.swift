//
//  UIFont+Ext.swift
//  Foto Lite
//
//  Created by Anh Vo on 11/5/18.
//  Copyright © 2018 Anh Vo. All rights reserved.
//

import UIKit

extension UIFont {
    class func custom(withName name: String, size: CGFloat) -> UIFont{
        if let font = UIFont(name: name, size: size) {
            return font
        }else{
            return UIFont.systemFont(ofSize: size)
        }
    }
}
