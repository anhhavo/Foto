//
//  MTLDevice+Ext.swift
//  Foto Lite
//
//  Created by Anh Vo on 11/3/18.
//  Copyright © 2018 Anh Vo. All rights reserved.
//

import CoreImage
import MetalKit

extension MTLTexture {
    
    func bytes() -> UnsafeMutableRawPointer? {
        let width = self.width
        let height   = self.height
        let rowBytes = self.width * 4
        if let pointer = malloc(width * height * 4) {
            self.getBytes(pointer, bytesPerRow: rowBytes, from: MTLRegionMake2D(0, 0, width, height), mipmapLevel: 0)
            return pointer
        }else{
            return nil
        }
    }
    
    func toImage() -> CGImage? {
        if let p = bytes() {
            let pColorSpace = CGColorSpaceCreateDeviceRGB()
            
            let rawBitmapInfo = CGImageAlphaInfo.noneSkipFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
            let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: rawBitmapInfo)
            
            let selftureSize = self.width * self.height * 4
            let rowBytes = self.width * 4
            let releaseMaskImagePixelData: CGDataProviderReleaseDataCallback = { (info: UnsafeMutableRawPointer?, data: UnsafeRawPointer, size: Int) -> () in
                return
            }
            let provider = CGDataProvider(dataInfo: nil, data: p, size: selftureSize, releaseData: releaseMaskImagePixelData)
            let cgImageRef = CGImage(width: self.width, height: self.height, bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: rowBytes, space: pColorSpace, bitmapInfo: bitmapInfo, provider: provider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)!
            
            return cgImageRef
        }else{
            return nil
        }
    }
}
