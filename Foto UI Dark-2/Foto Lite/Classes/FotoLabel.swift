//
//  FotoLabel.swift
//  Foto Lite
//
//  Created by Anh Vo on 11/5/18.
//  Copyright © 2018 Anh Vo. All rights reserved.
//

import UIKit

class TahrirLabel: UILabel {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.lineBreakMode = .byWordWrapping
        self.numberOfLines = 0
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private func setFrame(){
        let transform = self.transform
        self.transform = CGAffineTransform.identity
        let size = self.sizeThatFits(
            CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        )
        self.frame.size = size
        self.sizeToFit()
        self.transform = transform
    }
    
    //MARK: - Public API
    
    var customText: String? {
        set(value) {
            self.text = value
            self.setFrame()
        }
        
        get{
            return self.text
        }
    }
    
    var pointSize: CGFloat {
        get {
            return self.font.pointSize
        }
    }
    
    var familyName: String {
        get {
            return self.font.familyName
        }
    }
    
    func setFont(name: String, size: CGFloat){
        self.font = UIFont.custom(withName: name, size: size > 8 ? size:8)

        self.setFrame()
    }
    
    func setColor(color: UIColor) {
        self.textColor = color
    }

}
