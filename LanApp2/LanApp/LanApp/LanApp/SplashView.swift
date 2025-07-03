//
//  SplashView.swift
//  LanApp
//
//  Created by Diego Villarreal on 7/1/25.
//

import AudioToolbox
import SwiftUI
import UIKit
import AudioToolbox

struct SplashView: View {
    @Binding var showSplash: Bool
    @State private var scale: CGFloat = 0.3
    @State private var opacity: Double = 0.0

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            Text("$")
                .font(.system(size: 100))
                .fontWeight(.bold)
                .foregroundColor(.accentColor)
                .scaleEffect(scale)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeOut(duration: 0.3)) {
                        opacity = 1.0
                        scale = 1.2
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            scale = 1.0
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                        withAnimation {
                            showSplash = false
                        }
                    }
                }
        }
    }
}
