//
//  FilterCell.swift
//  Foto Lite
//
//  Created by Anh Vo on 11/2/18.
//  Copyright © 2018 Anh Vo. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {

    @IBOutlet weak var filterName: UILabel!
    @IBOutlet weak var mtkView: MetalKitView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(with cell: CIFilterName, context: CIContext, ciImage: CIImage, device: MTLDevice) {
        filterName.text = cell.rawValue
            .replacingOccurrences(of: "CIPhotoEffect", with: "")
            .replacingOccurrences(of: "CI", with: "")
        mtkView.layer.shadowOffset = CGSize(width: 2, height: 2)
        mtkView.layer.shadowColor = UIColor.black.cgColor
        mtkView.layer.shadowRadius = 3
        mtkView.layer.shadowOpacity = 1
        mtkView.render(image: ciImage, context: context, device: device)
        mtkView.setNeedsDisplay()
    }

}
