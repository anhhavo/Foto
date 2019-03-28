//
//  BackgroundSelectViewController.swift
//  Foto Lite
//
//  Created by Anh Vo on 11/10/18.
//  Copyright © 2018 Anh Vo. All rights reserved.
//

import UIKit

class BackgroundSelectViewController: UIViewController {
    var delegate: SendBackDataDelegate?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var chooseImageButton: UIBarButtonItem!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var selectImageMessageStack: UIStackView!
    
    var originalImage: UIImage?

    var backgroundImage: UIImage! {
        didSet{
            self.selectImageMessageStack?.isHidden = true
            self.filterButton?.isEnabled = true
            self.imageView?.image = backgroundImage
            self.scrollView?.contentSize = backgroundImage.size
            self.scrollView?.maximumZoomScale = 2
            self.imageView?.sizeToFit()
            updateConstraintsForSize(view.bounds.size)
            self.view?.setNeedsLayout()
            
        }
    }
    
    fileprivate let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // When Main Veiw sends the current image
        if self.backgroundImage != nil {
            self.selectImageMessageStack?.isHidden = true
            self.filterButton?.isEnabled = true
            self.imageView?.image = backgroundImage
            self.scrollView?.contentSize = backgroundImage.size
            self.scrollView?.maximumZoomScale = 2
            self.imageView?.sizeToFit()
            updateConstraintsForSize(view.bounds.size)
            self.view?.setNeedsLayout()
        }
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        if parent == nil {
            if let delegate = self.delegate {
                //delegate.setNew(image: self.screenshot(), originalImage: self.originalImage)
                let data = [self.screenshot(), self.originalImage]
                delegate.dataReceived(identifier: "UpdateImage", info: data)
            }
        }
    }
    
    func configureView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.decelerationRate = UIScrollView.DecelerationRate.normal
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        scrollView.delegate = self
        scrollView.maximumZoomScale = 2
        scrollView.contentInsetAdjustmentBehavior = .never
        chooseImageButton.tintColor = UIColor.FlatColor.Green.PersianGreen
        filterButton.tintColor = UIColor.FlatColor.Green.PersianGreen
        imageView.contentMode = .scaleAspectFill
        filterButton.isEnabled = false
    }
    
    func screenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.scrollView.bounds.size, false, UIScreen.main.scale)
        let offset = self.scrollView.contentOffset
        if let context = UIGraphicsGetCurrentContext() {
            context.translateBy(x: -offset.x, y: -offset.y)
            self.scrollView.layer.render(in: context)
            let visibleScrollViewImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return visibleScrollViewImage
        }else{
            return nil
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinZoomScaleForSize(view.bounds.size)
    }
    
    // MARK: - Interactions
    @IBAction func chooseImage(_ sender: UIBarButtonItem) {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func showFilters(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "Show Image Filters", sender: self)
    }

    @IBAction func sendBackFilteredImage(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func cancelFilteringImage(segue: UIStoryboardSegue) {
        
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Image Filters" {
            if let viewController = segue.destination as? FiltersViewController {
                viewController.imageToApplyFilter = self.originalImage
            }
        }
    }
 

}

//MARK: - UIImagePickerControllerDelegate
extension BackgroundSelectViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true) {
//            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
//            {
//                self.backgroundImage = image
//            }
//
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            {
                self.backgroundImage = image.fixedOrientation()
                self.originalImage = self.backgroundImage
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}

//MARK: - UIScrollViewDelegate
extension BackgroundSelectViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
    }
    
    fileprivate func updateConstraintsForSize(_ size: CGSize) {
        var yOffset = max(0, (size.height - imageView.frame.height) / 2)
        yOffset = yOffset < (size.height / 4) ? yOffset : (size.height / 4)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        var xOffset = max(0, (size.width - imageView.frame.width) / 2)
        xOffset = xOffset < (size.width / 4) ? xOffset : (size.width / 4)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }
    
    
    fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }

}


