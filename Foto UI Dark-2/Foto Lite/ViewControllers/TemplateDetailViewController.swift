//
//  TemplateDetailViewController.swift
//  Foto1
//
//  Created by Isabelle Xu on 11/29/18.
//  Copyright © 2018 Maysam Shahsavari. All rights reserved.
//

import Foundation

import UIKit

class TemplateDetailViewController: UIViewController {
    
    var delegate: SendBackDataDelegate?
    
    @IBOutlet var templateView: UIView!
    @IBOutlet weak var templateImage: UIImageView!
    @IBOutlet weak var header: UITextView!
    @IBOutlet weak var body: UITextView!
    
    var currentTemp : Template?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        templateImage.image = currentTemp?.tempImg
        header.text = currentTemp?.header
        body.text = currentTemp?.body
        if currentTemp?.id == 1 {
            body.textAlignment = .center
        }
        self.hideKeyboardWhenTappedAround() 
        
    }
    
    @IBAction func finishBtn(_ sender: Any) {
        // Once template editing is finished, take a screenshot/ convert text fields into UI text and port to main screen
        let image = screenshot()!
        saveAlertPopUp(image : image)
    }
    
    open func screenshot() -> UIImage? {
        var screenshotImage :UIImage?
        let layer = templateView.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(self.templateImage.bounds.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
//        if let image = screenshotImage, shouldSave {
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//        }
        return screenshotImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.isMovingToParent{
            let parent = self.parent as? MainViewController
            parent?.imageView.image = screenshot()!
        }
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        if parent == nil {
            if let delegate = self.delegate {
                // delegate.setNew(image: self.screenshot(), originalImage: self.originalImage)
                let data = [self.templateImage.image,self.screenshot()]
                delegate.dataReceived(identifier: "UpdateImage", info: data)
            }
        }
    }
    
    func saveAlertPopUp(image : UIImage){
        let alert = UIAlertController(title: "Save?", message: "Do you want to save?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
}
