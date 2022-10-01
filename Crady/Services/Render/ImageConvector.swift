//
//  ImageConvector .swift
//  Сardy
//
//  Created by Nikita Lizogubov on 02.10.2022.
//

import UIKit
import AVFoundation

public class ImageConvector {
    
    // MARK: - Private properties
    
    private let assetWriter: AVAssetWriter
    private let assetWriterInput: AVAssetWriterInput
    
    private let fileURL: URL
    private let videoSettings: [String: Any]
    
    // MARK: - Public properties
    
    static func makeVideoSettings(codec: String, width: Int, height: Int) -> [String: Any] {
        let videoSettings: [String: Any] = [
            AVVideoCodecKey: codec,
            AVVideoWidthKey: width,
            AVVideoHeightKey: height
        ]
        
        // default preset
        // let settingsAssistant = AVOutputSettingsAssistant(preset: .preset1920x1080)?.videoSettings
        
        return videoSettings
    }
    
    // MARK: - Init
    
    init?(videoSettings: [String: Any]) {
        //generate a file url to store the video. some_image.jpg becomes some_image.mov
        guard
            let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/exprotvideo.mov")
        else {
            print("Can't create a temp path")
            return nil
        }
        
        let fileURL = URL(fileURLWithPath: filePath)
        
        //delete any old file
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("Could not remove file \(error.localizedDescription)")
        }
        
        //create an assetWriter instance
        guard let assetWriter = try? AVAssetWriter(outputURL: fileURL, fileType: .mov) else {
            return nil
        }
        
        //create a single video input
        let assetWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        
        //add the input to the asset writer
        assetWriter.add(assetWriterInput)
        
        self.videoSettings = videoSettings
        self.assetWriter = assetWriter
        self.assetWriterInput = assetWriterInput
        self.fileURL = fileURL
    }
    
    // MARK: - Public methods
    
    func createMovieFrom(images: [AnyObject], completion: @escaping (URL) -> Void) {
        //create an adaptor for the pixel buffer
        let assetWriterAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: assetWriterInput, sourcePixelBufferAttributes: nil)
        
        //begin the session
        assetWriter.startWriting()
        assetWriter.startSession(atSourceTime: CMTime.zero)

        let mediaInputQueue = DispatchQueue(label: "mediaInputQueue")
        var i = 0
        let frameNumber = images.count
        let frameTime = CMTimeMake(value: 1, timescale: 10)

        self.assetWriterInput.requestMediaDataWhenReady(on: mediaInputQueue) {
            while(true){
                if(i >= frameNumber) {
                    break
                }

                if (self.assetWriterInput.isReadyForMoreMediaData){
                    var sampleBuffer:CVPixelBuffer?
                    autoreleasepool{
                        let img = images[i] as? UIImage
                        if img == nil {
                            i += 1
                            print("Warning: counld not extract one of the frames")
                            //continue
                        }
                        sampleBuffer = self.newPixelBufferFrom(cgImage: img!.cgImage!)
                    }
                    if (sampleBuffer != nil){
                        if(i == 0){
                            assetWriterAdaptor.append(sampleBuffer!, withPresentationTime: CMTime.zero)
                        }else{
                            let value = i - 1
                            let lastTime = CMTimeMake(value: Int64(value), timescale: frameTime.timescale)
                            let presentTime = CMTimeAdd(lastTime, frameTime)

                            assetWriterAdaptor.append(sampleBuffer!, withPresentationTime: presentTime)
                        }
                        i = i + 1
                    }
                }
            }

            //close everything
            self.assetWriterInput.markAsFinished()
            self.assetWriter.finishWriting {
                DispatchQueue.main.sync {
                    completion(self.fileURL)
                }
            }
        }
    }
    
    // MARK: - Private methods
    
    private func newPixelBufferFrom(cgImage: CGImage) -> CVPixelBuffer? {
        let options: [String: Any] = [
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
        
        ]
        var pxbuffer:CVPixelBuffer?
        
        let frameWidth = videoSettings[AVVideoWidthKey] as! Int
        let frameHeight = videoSettings[AVVideoHeightKey] as! Int
        
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            frameWidth,
            frameHeight,
            kCVPixelFormatType_32ARGB,
            options as CFDictionary?,
            &pxbuffer
        )
        
        assert(status == kCVReturnSuccess && pxbuffer != nil, "newPixelBuffer failed")
        
        CVPixelBufferLockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        let pxdata = CVPixelBufferGetBaseAddress(pxbuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        
        let context = CGContext(
            data: pxdata,
            width: frameWidth,
            height: frameHeight,
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(pxbuffer!),
            space: rgbColorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        )
        
        assert(context != nil, "context is nil")
        
        context!.concatenate(CGAffineTransform.identity)
        context!.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
        
        CVPixelBufferUnlockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pxbuffer
    }
    
}
