//
//  MetalKitView.swift
//  Tahrir Lite
//
//  Created by Anh Vo on 11/1/18.
//  Copyright © 2018 Anh Vo. All rights reserved.
//

import UIKit
import MetalKit
import AVFoundation

class MetalKitView: MTKView {
    
    private var commanQueue: MTLCommandQueue?
    
    private var ciContext: CIContext?
    var mtlTexture: MTLTexture?
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.isOpaque = false
        self.enableSetNeedsDisplay = true
    }
    
    func render(image: CIImage, context: CIContext, device: MTLDevice) {
        #if !targetEnvironment(simulator)
        self.ciContext = context
        self.device = device
        
        var size = self.bounds
        size.size = self.drawableSize
        size = AVMakeRect(aspectRatio: image.extent.size, insideRect: size)
        let filteredImage = image.transformed(by: CGAffineTransform(
            scaleX: size.size.width/image.extent.size.width,
            y: size.size.height/image.extent.size.height))
        let x = -size.origin.x
        let y = -size.origin.y
        
        self.commanQueue = device.makeCommandQueue()
        
        let buffer = self.commanQueue!.makeCommandBuffer()!
        self.mtlTexture = self.currentDrawable!.texture
        self.ciContext!.render(filteredImage,
                               to: self.currentDrawable!.texture,
                               commandBuffer: buffer,
                               bounds: CGRect(origin:CGPoint(x:x, y:y), size:self.drawableSize),
                               colorSpace: CGColorSpaceCreateDeviceRGB())
        buffer.present(self.currentDrawable!)
        buffer.commit()
        #endif
    }
    
    func getUIImage(texture: MTLTexture, context: CIContext) -> UIImage?{
        let kciOptions = [CIImageOption.colorSpace: CGColorSpaceCreateDeviceRGB(),
                          CIContextOption.outputPremultiplied: true,
                          CIContextOption.useSoftwareRenderer: false] as! [CIImageOption : Any]
        
        if let ciImageFromTexture = CIImage(mtlTexture: texture, options: kciOptions) {
            if let cgImage = context.createCGImage(ciImageFromTexture, from: ciImageFromTexture.extent) {
                let uiImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: .downMirrored)
                return uiImage
            }else{
                return nil
            }
        }else{
            return nil
        }
    }
    
}
