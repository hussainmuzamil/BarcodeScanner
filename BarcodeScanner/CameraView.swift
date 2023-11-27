//
//  CameraView.swift
//  BarcodeScanner
//
//  Created by Muzamil Hussain on 11/26/23.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable{
    @Binding var scannedCodeProp : String
    func makeUIViewController(context: Context) -> CameraVC {
        CameraVC(scannerDelegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: CameraVC, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(cameraView : self)
    }
    
    final class Coordinator : NSObject,ScannerVcDelegate{
        private let cameraView : CameraView
        
        init(cameraView: CameraView) {
            self.cameraView = cameraView
        }
        func didFind(barcode: String) {
            cameraView.scannedCodeProp = barcode
            print(barcode)
        }
        
        func didFindError(cameraError: CameraError) {
            print(cameraError.rawValue)
        }
        
        
    }

}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView(scannedCodeProp: Binding.constant(""))
    }
}
