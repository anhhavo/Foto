//
//  ActionModel.swift
//  Foto Lite
//
//  Created by Anh Vo on 11/15/18.
//  Copyright © 2018 Anh Vo. All rights reserved.
//

import UIKit

enum ActionModel {
    case Font(UIFont)
    case Color(UIColor)
    case Rotation
    case Alignment
}

enum OptionsItem: String {
    case LeftAlign = "leftAlign"
    case RightAlign = "rightAlign"
    case Centered = "centered"
    case RotateLeft = "rotateLeft"
    case RotateRight = "rotateRight"
    case ResetRotation = "resetRotation"
}
