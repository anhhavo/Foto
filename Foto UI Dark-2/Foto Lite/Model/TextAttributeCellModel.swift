//
//  TextAttributeCellModel.swift
//  Foto Lite
//
//  Created by Anh Vo on 11/6/18.
//  Copyright © 2018 Anh Vo. All rights reserved.
//

import UIKit

struct TextAttributeCellModel {
    let font: UIFont?
    let icon: UIImage?
    let color: UIColor?
}

enum CollectionViewType: Equatable {
    case Fonts
    case Colors
    case Options
    case None
}
