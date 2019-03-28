//
//  DrawViewController.swift
//  Foto1
//
//  Created by Isabelle Xu on 11/22/18.
//  Copyright © 2018 Isabelle Xu. All rights reserved.
//

import Foundation
import UIKit

class DrawViewController: UIViewController {
    var delegate: SendBackDataDelegate?
    // @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var thicknessSlider: UISlider!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var undoBtn: UIButton!
    
    @IBOutlet weak var colorBtn: ColorButton!
    @IBOutlet weak var colorPntr: UIView!
    
    var currentColor: UIColor!
    var currentThickness: CGFloat!
    var currentLine: Line?
    // stores all Line path objects on canvas
    var lines = [Line]()
    
    var isLine = false
    var isSticker = false
    var sticker: UIImageView?
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationItem.backBarButtonItem?.action = #selector(customBackButton())
        imageView.image = image
        currentColor = colorBtn.backgroundColor
        currentThickness = CGFloat(thicknessSlider.value)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.isMovingToParent{
            let parent = self.parent as? MainViewController
            parent?.imageView.image = screenshot()!
        }
    }
    func customBackButton(){
        
        
    }
        /*
         * Creative Portion:
         * 1. Sticker implementation
         * 2. Line Tool
         */
        @IBAction func lineBtn(_ sender: UIButton) {
            isLine = true
            isSticker = false
        }
        
        @IBAction func brushBtn(_ sender: UIButton) {
            isLine = false
            isSticker = false
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            
            // get the location of a user’s first starting touch.
            guard let touchPoint = touches.first?.location(in: imageView) else { return }
            if isSticker == false { // no drawing if in sticker mode
                let frame = CGRect(x: 0, y: 0, width: imageView.frame.width, height: imageView.frame.height)
                currentLine = Line(frame: frame)
                
                // check if drawing line or free draw (creative)
                if isLine == true {
                    currentLine?.isLine = true
                } else {
                    currentLine?.isLine = false
                }
                if (currentLine != nil) {
                    currentLine!.lineData = LineData(thickness: currentThickness, color: currentColor!, CGpoints: [touchPoint])
                }
                
                imageView.addSubview(currentLine!)
            } else {
                // place sticker where screen is touched (creative)
                if (sticker != nil) {
                    let newSticker = UIImageView(image: sticker!.image!)
                    let dimensions = 10 * currentThickness
                    newSticker.frame = CGRect(x: touchPoint.x-dimensions/2, y: touchPoint.y-dimensions/2, width: dimensions, height: dimensions)
                    imageView.addSubview(newSticker)
                }
                
            }
            
        }
        
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            if isSticker == false {
                // record points as line is in process of being drawn
                if (currentLine != nil) {
                    if (currentLine!.lineData != nil) {
                        for t in touches {
                            // allow animation to follow dragging finger if drawing line
                            currentLine!.lineData!.CGpoints.append(t.location(in: imageView))
                        }
                    }
                }
            }
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            // get the location of a user’s touch just before they let go
            guard let touchPoint = touches.first?.location(in: imageView) else { return }
            if isSticker == false {
                if (currentLine != nil) {
                    if (currentLine!.lineData != nil) {
                        currentLine!.lineData!.CGpoints.append(touchPoint)
                    }
                }
            }
        }
        
        // Switches line color and sets indicator to selected circle button
        @IBAction func switchColor(_ sender: ColorButton) {
            //print("Switch Color button pressed")
            // find new position of indicator
            var x_pos = CGFloat(0);
            if UIDevice.current.orientation.isLandscape {
                x_pos = sender.frame.maxX
            } else {
                x_pos = sender.frame.maxX - 6
            }
            let y_pos = colorPntr.frame.origin.y
            colorPntr.frame.origin = CGPoint(x: x_pos, y: y_pos)
            
            // switch color
            currentColor = sender.backgroundColor
        }
        
        // places selected sticker within canvas wherever user touches
        @IBAction func stickerBtn(_ sender: UIButton) {
            //print("Sticker button pressed")
            isSticker = true
            isLine = false
            sticker = sender.imageView
        }
        
        // Change line width thickness
        @IBAction func changeThickness(_ sender: UISlider) {
            currentThickness = CGFloat(thicknessSlider.value)
        }
        
        // Delete the most recently drawn line
        @IBAction func undoLine(_ sender: UIButton) {
            //print("Undo button pressed")
            if (imageView.subviews.last != nil) {
                imageView.subviews.last!.removeFromSuperview()
                // remove from points array as well
                let _: Line? = lines.popLast()
            }
        }
        
        // Clear all lines from view and empty Line array
        @IBAction func clearBoard(_ sender: UIButton) {
            //print("Clear board button pressed")
            for view in imageView.subviews {
                view.removeFromSuperview()
            }
            lines = [Line]()
        }    
    //save alert
    @IBAction func saveDrawing(_ sender: Any) {
    
        let image = screenshot()!
        saveAlertPopUp(image : image)
    }
    
    func screenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, false, UIScreen.main.scale)
        //let offset = self.imageView.contentOffset
        if let context = UIGraphicsGetCurrentContext() {
            //context.translateBy(x: -offset.x, y: -offset.y)
            self.imageView.layer.render(in: context)
            let visibleScrollViewImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return visibleScrollViewImage
        }else{
            return nil
        }
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
//        if parent == nil {
//            if let delegate = self.delegate {
//                // delegate.setNew(image: self.screenshot(), originalImage: self.originalImage)
//                let data = [self.screenshot(),self.image]
//                delegate.dataReceived(identifier: "UpdateImage", info: data)
//            }
//        }
        if parent == nil {
            if let delegate = self.delegate {
                //delegate.setNew(image: self.screenshot(), originalImage: self.originalImage)
                let data = [self.screenshot(), self.image]
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
