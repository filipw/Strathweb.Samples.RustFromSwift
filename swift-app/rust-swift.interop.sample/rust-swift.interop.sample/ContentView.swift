//
//  ContentView.swift
//  rust-swift.interop.sample
//
//  Created by Filip W on 21.07.23.
//

import SwiftUI

struct ContentView: View {
    let qrCode: QrCode
    init() {
        qrCode = try! encodeText(text: "https://strathweb.com", ecl: .medium)
    }
    
    var body: some View {
        QrCodeView(qrCode: qrCode)
            .aspectRatio(1, contentMode: .fit)
            .padding()
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
