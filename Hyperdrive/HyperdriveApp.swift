//
//  HyperdriveApp.swift
//  Hyperdrive
//
//  Created by Alvin Ta on 2025-07-08.
//
import SDWebImageSVGCoder
import SwiftUI

@main
struct HyperdriveApp: App {
    init() {
        let SVGCoder = SDImageSVGCoder.shared
        SDImageCodersManager.shared.addCoder(SVGCoder)
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
