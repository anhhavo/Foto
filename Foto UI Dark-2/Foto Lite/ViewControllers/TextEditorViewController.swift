//
//  TextEditorViewController.swift
//  Foto Lite
//
//  Created by Anh Vo on 11/16/18.
//  Copyright © 2018 Anh Vo. All rights reserved.
//

import UIKit

class TextEditorViewController: UIViewController {
    var delegate: SendBackDataDelegate?
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var updateButton: UIButton!
    
    var text: String?
    var font: UIFont?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configueView()
        self.hideKeyboardWhenTappedAround() 
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        modalPresentationStyle = .custom
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if !(String.modelIdentifier().lowercased().contains("ipad")) {
            let threshoulds = (horizontal: (UIScreen.main.bounds.width - 495), vertical: (UIScreen.main.bounds.height - 495))
            switch threshoulds {
            case (let horizontal, let vertical) where horizontal > 0 && vertical > 0:
                return .all
            default:
                return .portrait
            }
        }else{
            return .all
        }
    }
    
    override var shouldAutorotate: Bool {
        if !(String.modelIdentifier().lowercased().contains("ipad")) {
            return true
        }else{
            return false
        }
    }
    
    //MARK: - Funcitons
    
    func configueView(){
        if let font = self.font {
            textView.font = font
        }
        
        if let text = self.text {
            textView.text = text
        }
    }
    
    override func viewWillLayoutSubviews() {
        container.round(corners: [.topLeft, .topRight], radius: 15)
    }
    
    @IBAction func updateText(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.dataReceived(identifier: "UpdateText", info: [self.textView.text])
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
