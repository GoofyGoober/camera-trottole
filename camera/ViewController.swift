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
    let video          = AVCaptureVideoDataOutput()
    let stillImage     = AVCaptureStillImageOutput()
    var dataImg:NSData?
    var connection:AVCaptureConnection?
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    // ip mac rete generata da ale 169.254.251.61:8080
    // ip awai 192.168.0.5:8080

    override func viewDidLoad() {
        super.viewDidLoad()
        findDevice()
        beginSession()

    }
    
    func findDevice(){
        captureSession.sessionPreset = AVCaptureSessionPreset640x480
        
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
        //captureSession.addOutput(video)
        stillImage.outputSettings =  [AVVideoCodecKey: AVVideoCodecJPEG]

        captureSession.addOutput(stillImage)
        captureSession.startRunning()
        // 24 frame
        // 0 e 1
        self.connection = self.stillImage.connectionWithMediaType(AVMediaTypeVideo)

        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector:  Selector("scatta"), userInfo: nil, repeats: true)
    }
    

func scatta(){
    
    self.stillImage.captureStillImageAsynchronouslyFromConnection(connection, completionHandler: {(weak imageDataSampleBuffer: CMSampleBuffer?, weak error:  NSError?) in
        if imageDataSampleBuffer != nil{
            self.dataImg = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
            self.sendImage(self.dataImg!)
        }
    })

}
    
    
    func sendImage(data:NSData){
        let url = NSURL(string: "http://192.168.0.5:8080")
        let request = NSMutableURLRequest(URL: url!)
        request.timeoutInterval = 5 
        request.HTTPMethod = "POST"
        request.HTTPBody = data
        
        var response: NSURLResponse? = nil
        var reply:NSData?
        do {
           reply  = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
            let results = NSString(data:reply!, encoding:NSUTF8StringEncoding)
            print("Response: \(results)")
        } catch {
            let alertController = UIAlertController(title: "Errore Connessione", message: "Sto cercando di connetteri a \(url?.absoluteString)", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
 
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

