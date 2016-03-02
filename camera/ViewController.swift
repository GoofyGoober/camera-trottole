//
//  ViewController.swift
//  camera
//
//  Created by Ale on 28/02/16.
//  Copyright © 2016 Goofy. All rights reserved.
//

import UIKit
import AVFoundation
import Starscream



class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, WebSocketDelegate {
    let captureSession = AVCaptureSession()
    let video          = AVCaptureVideoDataOutput()
    let stillImage     = AVCaptureStillImageOutput()
    var dataImg:NSData?
    var connection:AVCaptureConnection?
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    // ip mac rete generata da ale 169.254.251.61:8080
    // ip awai 192.168.0.5:8080
    var socket = WebSocket(url: NSURL(string: "ws://169.254.251.61:8080")!)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebSocket()
        findDevice()
        beginSession()

    }
    
    func setupWebSocket(){
        socket.delegate = self
        socket.connect()
    }
    
    func websocketDidConnect(socket: WebSocket) {
        print("websocket is connected")
        print("---")
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        print("got some data: \(data.length)")
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("arriva testo: \(text)")
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("websocket is casso: \(error?.localizedDescription)")
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
            self.socket.writeData(self.dataImg!)

        }
        //self.socket.writeString("Ciao da iphone")
    })

}
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

