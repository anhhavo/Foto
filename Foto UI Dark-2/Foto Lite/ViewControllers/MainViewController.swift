//
//  MainViewController.swift
//  Foto Lite
//
//  Created by Anh Vo on 10/31/18.
//  Copyright © 2018 Anh Vo. All rights reserved.
// icons: https://www.iconfinder.com/iconsets/feather-2

import UIKit
import MetalKit
import AVFoundation
import Photos

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var backgroundButton: UIBarButtonItem!
    @IBOutlet weak var fontButton: UIBarButtonItem!
    @IBOutlet weak var colorButoon: UIBarButtonItem!
    @IBOutlet weak var optionButton: UIBarButtonItem!

    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var drawButton: UIBarButtonItem!
    @IBOutlet weak var addAText: UIBarButtonItem!
    @IBOutlet weak var templateButton: UIBarButtonItem!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewTopContstraint: NSLayoutConstraint!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    
    
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    
    var originalImage: UIImage?
    
    var backgroundImage: UIImage! {
        didSet{
            self.imageView.image = backgroundImage
        }
    }
    
    fileprivate var visibleCollectionView = CollectionViewType.None {
        didSet{
            if visibleCollectionView == .None {
                optionButton.tintColor = UIColor.FlatColor.Green.PersianGreen
                backgroundButton.tintColor = UIColor.FlatColor.Green.PersianGreen
                colorButoon.tintColor = UIColor.FlatColor.Green.PersianGreen
                fontButton.tintColor = UIColor.FlatColor.Green.PersianGreen
                templateButton.tintColor = UIColor.FlatColor.Green.PersianGreen
                shareButton.tintColor = UIColor.FlatColor.Green.PersianGreen
            }
        }
    }
    
    fileprivate let options:[OptionsItem] = [
        .LeftAlign,
        .RightAlign,
        .Centered,
        .RotateLeft,
        .RotateRight,
        .ResetRotation
    ]
    
    fileprivate var collectionViewIsBeingShown = false
    fileprivate var currentLabel = TahrirLabel()
    fileprivate var cells = [TextAttributeCellModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setting initial background to white.
        backgroundImage = UIImage(named: "white")
        configureView()
        self.hideKeyboardWhenTappedAround() 
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    // MARK: - Functions
    
    func configureView(){
        collectionView.register(UINib(nibName: "TextAttributeCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionViewTopContstraint.constant = -(collectionViewHeightConstraint.constant)
        navigationController?.navigationBar.isTranslucent = false
        view.layoutIfNeeded()
        backgroundButton.tintColor = UIColor.FlatColor.Green.PersianGreen
        optionButton.tintColor = UIColor.FlatColor.Green.PersianGreen
        colorButoon.tintColor = UIColor.FlatColor.Green.PersianGreen
        fontButton.tintColor = UIColor.FlatColor.Green.PersianGreen
        drawButton.tintColor = UIColor.FlatColor.Green.PersianGreen
        addAText.tintColor = UIColor.FlatColor.Green.PersianGreen
        
        disableTextActionButtons()
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePintch(recognizer:)))
        container.addGestureRecognizer(pinch)
        
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        guard currentLabel.text != nil else {return}
        let translation = recognizer.translation(in: self.container)
        if let view = recognizer.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.container)
        
    }
    
    @objc func handlePintch(recognizer: UIPinchGestureRecognizer){
        guard recognizer.view != nil else { return }
        
        let point = currentLabel.pointSize
        var center = CGPoint.zero
        
        center = currentLabel.center
        if recognizer.state == .began || recognizer.state == .changed {
            let scale = recognizer.scale
            currentLabel.setFont(name: currentLabel.familyName, size: point*scale)
            recognizer.scale = 1.0
            
        }
        
        if recognizer.state == .changed || recognizer.state == .ended {
            if center != CGPoint.zero {
                currentLabel.center = center
                //print(center)
            }
        }
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer){
        if let label = recognizer.view as? TahrirLabel {
            currentLabel = label
        }
    }
    
    @objc func handleDoubleTap(recognizer: UITapGestureRecognizer){
        if let label = recognizer.view as? TahrirLabel {
            currentLabel = label
        }
        
        showEditText(with: currentLabel)
    }
    
    @objc func handleLongPress(recognizer: UITapGestureRecognizer) {
        guard recognizer.state == .began else {return}
        if let recognizerView = recognizer.view as? TahrirLabel,
            let recognizerSuperView = recognizerView.superview
        {
            currentLabel = recognizerView
            let delete = UIMenuItem(title: "Delete", action: #selector(removeLabel))
            recognizerView.becomeFirstResponder()
            let menuController = UIMenuController.shared
            menuController.menuItems = [delete]
            menuController.setTargetRect(recognizerView.frame, in: recognizerSuperView)
            menuController.setMenuVisible(true, animated:true)
        }
    }
    
    @objc func removeLabel(){
        self.currentLabel.removeFromSuperview()
        disableTextActionButtons()
        for item in container.subviews {
            if item is TahrirLabel {
                enableTextActionButtons()
                return
            }
        }
    }
    
    @objc func showEditText(with label: TahrirLabel){
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Text Editor") as? TextEditorViewController {
            viewController.delegate = self
            slideInTransitioningDelegate.direction = .bottom
            slideInTransitioningDelegate.useFixedHeight = true
            slideInTransitioningDelegate.fixedHeight = UIScreen.main.bounds.height*(4/5)
            viewController.text = label.text
            viewController.font = label.font
            slideInTransitioningDelegate.disableCompactHeight = false
            viewController.transitioningDelegate = slideInTransitioningDelegate
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    func applyOptions(with option: OptionsItem) {
        guard currentLabel.text != nil else {return}
        switch option {
        case .LeftAlign:
          currentLabel.textAlignment = .left
        case .RightAlign:
            currentLabel.textAlignment = .right
        case .Centered:
            currentLabel.textAlignment = .center
        case .RotateLeft:
            animateRotaion(label: currentLabel, clokeWise: false)
        case .RotateRight:
            animateRotaion(label: currentLabel, clokeWise: true)
        case .ResetRotation:
            currentLabel.transform = CGAffineTransform.identity
        }
    }
    
    func animateRotaion(label: TahrirLabel, clokeWise: Bool) {
        UIView.animate(withDuration: 0.15) {
            label.transform = label.transform.rotated(by: clokeWise == false ? -(.pi/4) : (.pi/4))

        }
    }
    
    func configureCollectionView(with cells: [TextAttributeCellModel], sender: CollectionViewType){
        guard collectionViewIsBeingShown == false else {return}
        
        optionButton.tintColor = UIColor.FlatColor.Gray.IronGray
        backgroundButton.tintColor = UIColor.FlatColor.Gray.IronGray
        colorButoon.tintColor = UIColor.FlatColor.Gray.IronGray
        fontButton.tintColor = UIColor.FlatColor.Gray.IronGray
        
        if visibleCollectionView == .None {
            collectionViewIsBeingShown = true
            if collectionViewTopContstraint.constant == 0{
                collectionViewTopContstraint.constant = -(collectionViewHeightConstraint.constant)
                self.visibleCollectionView = .None
            }else{
                self.cells = cells
                collectionView.reloadData()
                collectionViewTopContstraint.constant = 0
            }
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.collectionViewIsBeingShown = false
                self.visibleCollectionView = sender
            })
        }else{
            collectionViewIsBeingShown = true
            if visibleCollectionView == sender {
                collectionViewTopContstraint.constant = -(collectionViewHeightConstraint.constant)
                self.visibleCollectionView = .None
                
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { _ in
                    self.collectionViewIsBeingShown = false
                })
            }else{
                self.collectionViewIsBeingShown = false
                self.cells = cells
                collectionView.reloadData()
                self.visibleCollectionView = sender
            }
        }
        
        switch sender {
        case .Colors:
            colorButoon.tintColor = UIColor.FlatColor.Green.PersianGreen
        case .Fonts:
            fontButton.tintColor = UIColor.FlatColor.Green.PersianGreen
        case .Options:
            optionButton.tintColor = UIColor.FlatColor.Green.PersianGreen
        default:
            break
        }
    }
    
    // MARK: - Interactions
    @IBAction func setBackgroung(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "Show Background Options", sender: self)
        /*
         let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
         
         actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
         
         if UIImagePickerController.isSourceTypeAvailable(.camera) {
         self.imagePickerController.sourceType = .camera
         self.present(self.imagePickerController, animated: true, completion: nil)
         }else{
         print("Camera not available")
         }
         
         
         }))
         
         actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
         self.imagePickerController.sourceType = .photoLibrary
         self.present(self.imagePickerController, animated: true, completion: nil)
         }))
         
         
         actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
         
         self.present(actionSheet, animated: true, completion: nil)
         */
    }
    
    @IBAction func addText(_ sender: UIBarButtonItem) {
        let label = TahrirLabel()
        label.customText = "Double click to\nedit"
        label.setFont(name: "Calendas-Plus", size: 22)
        label.isUserInteractionEnabled = true
        container.addSubview(label)
        label.center = container.center
        label.textColor = .black
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        label.addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        label.addGestureRecognizer(tap)
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(recognizer:)))
        doubleTap.numberOfTapsRequired = 2
        label.addGestureRecognizer(doubleTap)
        tap.require(toFail: doubleTap)
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
        label.addGestureRecognizer(longGesture)
        
        currentLabel = label
        
        enableTextActionButtons()
    }
    
    @IBAction func shareImage(_ sender: UIBarButtonItem) {
        collectionView.isHidden = true
        let renderer = UIGraphicsImageRenderer(size: container.bounds.size)
        let image = renderer.image { context in
            view.drawHierarchy(in: container.bounds, afterScreenUpdates: true)
        }
        collectionView.isHidden = false
        let items = [image]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
        
    }
    
    func disableTextActionButtons(){
        optionButton.isEnabled = false
        colorButoon.isEnabled = false
        fontButton.isEnabled = false
    }
    
    func enableTextActionButtons(){
        optionButton.isEnabled = true
        colorButoon.isEnabled = true
        fontButton.isEnabled = true
    }
    
    @IBAction func showFonts(_ sender: UIBarButtonItem) {
        cells = Settings.fonts.map { TextAttributeCellModel(font: UIFont.custom(withName: $0, size: 12), icon: nil, color: nil) }
        configureCollectionView(with: cells, sender: .Fonts)
        
    }
    
    @IBAction func showColors(_ sender: UIBarButtonItem) {
        let colors:[UIColor] = [.black, .white,
                                UIColor.FlatColor.Blue.BlueWhale, UIColor.FlatColor.Blue.Chambray,
                                UIColor.FlatColor.Gray.AlmondFrost, UIColor.FlatColor.Gray.Iron,
                                UIColor.FlatColor.Green.ChateauGreen, UIColor.FlatColor.Green.Fern,
                                UIColor.FlatColor.Orange.NeonCarrot, UIColor.FlatColor.Orange.Sun,
                                UIColor.FlatColor.Red.Cinnabar, UIColor.FlatColor.Red.TerraCotta,
                                UIColor.FlatColor.Violet.BlueGem, UIColor.FlatColor.Violet.Wisteria,
                                UIColor.FlatColor.Yellow.Energy, UIColor.FlatColor.Yellow.Turbo
        ]
        cells = colors.map { TextAttributeCellModel(font: nil, icon: nil, color: $0) }
        configureCollectionView(with: cells, sender: .Colors)
    }

    @IBAction func showOptions(_ sender: UIBarButtonItem) {
        cells = options.map {TextAttributeCellModel(font: nil, icon: UIImage(named: $0.rawValue), color: nil)}
        configureCollectionView(with: cells, sender: .Options)
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Background Options" {
            if let viewController = segue.destination as? BackgroundSelectViewController {
                viewController.delegate = self
                viewController.backgroundImage = self.backgroundImage
                viewController.originalImage = self.backgroundImage
            }
        }
        if segue.identifier == "Show Canvas" {
            if let viewController = segue.destination as? DrawViewController {
                viewController.delegate = self
                viewController.image = self.backgroundImage
            }
        }
     }
    
}

//MARK: - UICollectionView Delegates
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? TextAttributeCell {
            cell.configureView(with: cells[indexPath.row])
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard currentLabel.customText != nil else {return}
        
        if let font = cells[indexPath.row].font {
            currentLabel.setFont(name: font.familyName, size: currentLabel.pointSize)
        }
        
        if let color = cells[indexPath.row].color {
            currentLabel.setColor(color: color)
        }
        
        if let _ = cells[indexPath.row].icon {
            applyOptions(with: options[indexPath.row])
        }
    }
    
}

extension MainViewController: SendBackDataDelegate {

    func dataReceived<T>(identifier: String, info: [T]) {
        if identifier == "UpdateImage" {
            DispatchQueue.main.async {
                if let _background  = info[0] as? UIImage, let _original = info[1] as? UIImage {
                    self.backgroundImage = _background
                    self.originalImage = _original
                }
                
            }
        }
        
        if identifier == "UpdateText" {
            DispatchQueue.main.async {
                if let text = info[0] as? String {
                    self.currentLabel.customText = text
                }
            }
        }
    }
    
}

// https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


