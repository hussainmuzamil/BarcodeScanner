//
//  CameraVC.swift
//  BarcodeScanner
//
//  Created by Muzamil Hussain on 11/24/23.
//

import AVFoundation
import UIKit

protocol ScannerVcDelegate : AnyObject {
    func didFind(barcode : String)
    func didFindError(cameraError : CameraError)
}

enum CameraError : String{
    case invalidDeviceInput = "Something is wrong with camera. We are unable to capture the input"
    case invalidScannedValue = "The value scanned is not valid. This app scans ean-8 and ean-13"
}

final class CameraVC : UIViewController,AVCaptureMetadataOutputObjectsDelegate{

    var captureSession  = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    weak var scannerDelegate : ScannerVcDelegate?
    
    init(scannerDelegate : ScannerVcDelegate){
        super.init(nibName: nil, bundle: nil)
        self.scannerDelegate = scannerDelegate
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupCaptureSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scannerDelegate?.didFindError(cameraError: .invalidDeviceInput)
        guard let previewLayer = previewLayer else{
            return
        }
        
        previewLayer.frame = view.layer.bounds
    }
    private func setupCaptureSession(){
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else{
            scannerDelegate?.didFindError(cameraError: .invalidDeviceInput)
            return
            
        }
        let videoInput : AVCaptureDeviceInput
            do{
                try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
            }catch{
                scannerDelegate?.didFindError(cameraError: .invalidDeviceInput)
                print("Some error in video input")
                return
            }
        if(captureSession.canAddInput(videoInput)){
            captureSession.addInput(videoInput)
            }else{
                scannerDelegate?.didFindError(cameraError: .invalidDeviceInput)
                return
            }
            let metaDataOutput = AVCaptureMetadataOutput()
            
            if captureSession.canAddOutput(metaDataOutput){
                captureSession.addOutput(metaDataOutput)
                metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metaDataOutput.metadataObjectTypes = [.ean8,.ean13]
            }else{
                scannerDelegate?.didFindError(cameraError: .invalidDeviceInput)
                return
            }
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer!.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer!)
        
        captureSession.startRunning()
        }
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first else{
            scannerDelegate?.didFindError(cameraError: .invalidScannedValue)
            return
        }
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else{
            scannerDelegate?.didFindError(cameraError: .invalidScannedValue)
            return
        }
        guard let barcode = machineReadableObject.stringValue else{
            scannerDelegate?.didFindError(cameraError: .invalidScannedValue)
            return
        }
        captureSession.stopRunning()
        scannerDelegate?.didFind(barcode: barcode)
    }
    
}

//
//extension CameraVC{
//    func didFindError(cameraError: CameraError) {
//
//    }
//
//    func didFind(barcode: String) {
//
//    }
//
//}
