//
//  TextAttributeCell.swift
//  Foto Lite
//
//  Created by Anh Vo on 11/5/18.
//  Copyright © 2018 Anh Vo. All rights reserved.
//

import UIKit

class TextAttributeCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureView(with info: TextAttributeCellModel) {
        if let font = info.font {
            label.font = font
            label.text = "Sample text\n示范文本\nПример текста"
            label.textAlignment = .center
            label.numberOfLines = 0
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
            label.sizeToFit()
        }else{
            label.text = ""
        }
        
        if let color = info.color {
            imageView.image = UIImage()
            imageView.backgroundColor = color
        }else{
            imageView.backgroundColor = .clear
        }
        
        if let image = info.icon {
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
        }else{
            imageView.image = UIImage()
        }
    }
}
