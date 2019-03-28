//
//  UIView+Ext.swift
//  Foto Lite
//
//  Created by Anh Vo on 11/17/18.
//  Copyright © 2018 Anh Vo. All rights reserved.
//

import UIKit

extension UIView {
    func round(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

