//
//  FiltersViewController.swift
//  Foto Lite
//
//  Created by Anh Vo on 11/1/18.
//  Copyright © 2018 Anh Vo. All rights reserved.
//

import UIKit
import MetalKit

class FiltersViewController: UIViewController {
    @IBOutlet var mtkView: MetalKitView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    private var listOfFilters = [CIFilterName]()
    private var context : CIContext!
    private var filter = ImageFilters()
    private var thumbnailsFilter = ImageFilters()
    private var mtlDevice: MTLDevice!
    private var ciImage = CIImage()
    private var thumbnailCIImage = CIImage()
    private var hasViewAppeared = false
    var imageToApplyFilter: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let device = MTLCreateSystemDefaultDevice(), let uiImage = imageToApplyFilter{

            if let ciImage = CIImage(image: uiImage) {
                self.ciImage = ciImage
                self.mtlDevice = device
                self.context = CIContext(mtlDevice: device)
                filter = ImageFilters(image: ciImage, context: self.context)
                setup()
            }
            
            if let thumbnail = uiImage.resize(maxHeight: 100, maxWidth: 100, compressionQuality: 0.8) {
                if let _thumbnailCIImage = CIImage(image: thumbnail) {
                    self.thumbnailCIImage = _thumbnailCIImage
                    self.thumbnailsFilter = ImageFilters(image: _thumbnailCIImage, context: self.context)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard self.context != nil && self.context != nil else {return}
  
        if !hasViewAppeared {
            mtkView.render(image: self.ciImage, context: self.context, device: self.mtlDevice)
            mtkView.setNeedsDisplay()
            hasViewAppeared = true
        }
    }
    
    func setup(){
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        filterCollectionView.register(UINib(nibName: "FilterCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        listOfFilters = CIFilterName.allCases.map {$0}
        filterCollectionView.reloadData()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Send Back Filtered Image" {
            if let viewController = segue.destination as? BackgroundSelectViewController {
                if let texture = mtkView.mtlTexture {
                  
                    viewController.backgroundImage = mtkView.getUIImage(texture: texture, context: self.context)
                }
           }

        }
    }

    @IBAction func saveIImage(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "Send Back Filtered Image", sender: self)
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "Canel Filtering", sender: self)
    }
    
}


extension FiltersViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfFilters.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? FilterCell {
            if listOfFilters[indexPath.row] == .None {
                cell.setup(with: listOfFilters[indexPath.row], context: self.context, ciImage: self.thumbnailCIImage, device: self.mtlDevice)
            }else{
                if let filteredImage = thumbnailsFilter.apply(filterName: listOfFilters[indexPath.row]) {
                    cell.setup(with: listOfFilters[indexPath.row], context: self.context, ciImage: filteredImage, device: self.mtlDevice)
                }
            }
            return cell
        }else{

            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if listOfFilters[indexPath.row] == .None {
            mtkView.render(image: self.ciImage, context: self.context, device: self.mtlDevice)
            mtkView.setNeedsDisplay()
        }else{
            if let filteredImage = filter.apply(filterName: listOfFilters[indexPath.row]) {
                mtkView.render(image: filteredImage, context: self.context, device: self.mtlDevice)
                mtkView.setNeedsDisplay()
            }
        }
        
    }
}

