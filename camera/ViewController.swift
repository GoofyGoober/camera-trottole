//
//  ViewController.swift
//  camera
//
//  Created by Ale on 28/02/16.
//  Copyright © 2016 Goofy. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    let captureSession = AVCaptureSession()
    
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
       findDevice()
        
            beginSession()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func findDevice(){
        captureSession.sessionPreset = AVCaptureSessionPresetMedium
        
        let devices = AVCaptureDevice.devices()
        
        // Loop through all the capture devices on this phone
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the back camera
                if(device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                }
            }
        }
    }
    
    func beginSession() {
        
        let input : AVCaptureDeviceInput?
        
        input = try! AVCaptureDeviceInput(device: captureDevice)
        captureSession.addInput(input);

        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(previewLayer)
        previewLayer.frame = self.view.layer.frame
        let video = AVCaptureVideoDataOutput()
        captureSession.addOutput(video)
        let queue:dispatch_queue_t = dispatch_queue_create("mauro puzza",nil)
        video.setSampleBufferDelegate(self, queue: queue)
        captureSession.startRunning()
    
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!){
        let imageBuffer: CVImageBufferRef? = CMSampleBufferGetImageBuffer(sampleBuffer)
        //CVPixelBufferLockBaseAddress(imageBuffer!, 0)
        //let bytesPerRow: size_t = CVPixelBufferGetBytesPerRow(imageBuffer!)
        //let width: size_t = CVPixelBufferGetWidth(imageBuffer!)
      //  let height: size_t = CVPixelBufferGetHeight(imageBuffer!)
    //    let src_buff = CVPixelBufferGetBaseAddress(imageBuffer!)
  //      let data: NSData = NSData(bytesNoCopy: src_buff, length: bytesPerRow * height)
//        CVPixelBufferUnlockBaseAddress(imageBuffer!, 0)
       // print(data.bytes)


    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

