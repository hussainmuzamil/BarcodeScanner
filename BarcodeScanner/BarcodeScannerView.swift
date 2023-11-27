//
//  ContentView.swift
//  BarcodeScanner
//
//  Created by Muzamil Hussain on 11/24/23.
//

import SwiftUI

struct BarcodeScannerView: View {
    @State var scannedCode = ""
    var body: some View {
        NavigationView{
            VStack{
                CameraView(scannedCodeProp: $scannedCode)
                    .frame(maxWidth : .infinity, maxHeight : 300)
                
                Spacer()
                    .frame(height: 60)
                
                Label("Scanned Barcode", systemImage: "barcode.viewfinder")
                    .font(.title)
                    
                Text(scannedCode.isEmpty ? "Not Scanned Yet" : scannedCode)
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(scannedCode.isEmpty ? .red : .green)
                    .padding()
                
            }
            .navigationTitle("Barcode Scanner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScannerView()
    }
}
