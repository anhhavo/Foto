//
//  ImageFilters.swift
//  Foto Lite
//
//  Created by Anh Vo on 10/31/18.
//  Copyright © 2018 Anh Vo. All rights reserved.
//

import Foundation
import CoreImage
import UIKit

enum CIFilterName: String, CaseIterable, Equatable {
    case None = "No Filter"
    case CIPhotoEffectChrome = "CIPhotoEffectChrome"
    case CIPhotoEffectFade = "CIPhotoEffectFade"
    case CIPhotoEffectInstant = "CIPhotoEffectInstant"
    case CIPhotoEffectNoir = "CIPhotoEffectNoir"
    case CIPhotoEffectProcess = "CIPhotoEffectProcess"
    case CIPhotoEffectTonal = "CIPhotoEffectTonal"
    case CIPhotoEffectTransfer = "CIPhotoEffectTransfer"
    case CISepiaTone = "CISepiaTone"
}

class ImageFilters {
    private var context: CIContext
    private let image: CIImage
    
    init() {
        self.context = CIContext()
        self.image = CIImage()
    }
    
    init(image: CIImage, context: CIContext){
        self.context = context
        self.image = image
    }
    
    func apply(filterName: CIFilterName) -> CIImage?{
 
        let filter = CIFilter(name: filterName.rawValue)
        filter?.setDefaults()

        filter?.setValue(self.image, forKey: kCIInputImageKey)
 //       filter?.setValue(Double(0.5), forKey: kCIInputIntensityKey)
        return filter?.outputImage
    }
}
