//
//  CameraViewController.swift
//  LedControl
//
//  Created by lim on 4/25/19.
//  Copyright © 2019 lim. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, FrameExtractorDelegate {

    var frameExtractor: FrameExtractor!

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
//    var session: AVCaptureSession?
//    var input: AVCaptureDeviceInput?
//    var output: AVCaptureStillImageOutput?
//    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if frameExtractor == nil {
            frameExtractor = FrameExtractor()
            frameExtractor.delegate = self
        }
//        //Initialize session an output variables this is necessary
//        session = AVCaptureSession()
//        output = AVCaptureStillImageOutput()
//        let camera = getDevice(position: .back)!
//        do {
//            input = try AVCaptureDeviceInput(device: camera)
//        } catch let error as NSError {
//            print(error)
//            input = nil
//        }
//
//        if(session?.canAddInput(input!) == true){
//            session?.addInput(input!)
//            output?.outputSettings = [AVVideoCodecKey : AVVideoCodecType.jpeg]
//            if(session?.canAddOutput(output!) == true){
//                session?.addOutput(output!)
//                previewLayer = AVCaptureVideoPreviewLayer(session: session!)
//                previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
//                previewLayer?.connection!.videoOrientation = AVCaptureVideoOrientation.portrait
//                previewLayer?.frame = cameraView.bounds
//                cameraView.layer.addSublayer(previewLayer!)
//                session?.startRunning()
//            }
//        }
        
    }
    
    func captured(image: UIImage) {
        imageView.image = image
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    @IBAction func flipButtonPressed(_ sender: Any) {
        frameExtractor.flipCamera()
    }
    
    @IBAction func testLedsButtonPressed(_ sender: Any) {
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
    }
    
    //    // MARK: - AV
//
//    //Get the device (Front or Back)
//    func getDevice(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
//        let devices: [AVCaptureDevice] = AVCaptureDevice.devices();
//        for de in devices {
//            let deviceConverted = de as! AVCaptureDevice
//            if (deviceConverted.position == position) {
//                return deviceConverted
//            }
//        }
//        return nil
//    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
