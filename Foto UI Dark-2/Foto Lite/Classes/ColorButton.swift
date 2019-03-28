//
//  ColorButton.swift
//  Drawing app
//
//  Created by Isabelle Xu on 9/30/18.
//  Copyright © 2018 WashU. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
// Custom UIButton class for circular color swatches
class ColorButton: UIButton {
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.width/2.0
        clipsToBounds = true
    }
}

