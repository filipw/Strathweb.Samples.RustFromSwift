//
//  ContentView.swift
//  rust-swift.interop.sample
//
//  Created by Filip W on 21.07.23.
//

import SwiftUI

struct ContentView: View {
    @State var qrCode: QrCode?
    @State var text: String = "https://strathweb.com"
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter the URL", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: .infinity)
                Button("Generate QR") {
                    do {
                        print(text)
                        qrCode = try encodeText(text: text, ecl: .medium)
                    } catch {
                        print(error)
                    }
                }
            }.padding()
            
            Spacer()
            
            if let qrCode = qrCode {
                QrCodeView(qrCode: qrCode)
                    .aspectRatio(1, contentMode: .fit)
                    .padding()
                
                Spacer()
            }
        }
    }
}

struct QrCodeView: View {
    let qrCode: QrCodeProtocol
    let moduleCoordinates: [Int]
    
    init(qrCode: QrCodeProtocol) {
        self.qrCode = qrCode
        self.moduleCoordinates = Array(0..<Int(qrCode.size()))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(moduleCoordinates, id: \.self) { x in
                ForEach(moduleCoordinates, id: \.self) { y in
                    if qrCode.getModule(x: Int32(x), y: Int32(y)) {
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: geometry.size.width / CGFloat(qrCode.size()),
                                   height: geometry.size.height / CGFloat(qrCode.size()))
                            .offset(x: CGFloat(x) * geometry.size.width / CGFloat(qrCode.size()),
                                    y: CGFloat(y) * geometry.size.height / CGFloat(qrCode.size()))
                    }
                }
            }
        }
    }
}
