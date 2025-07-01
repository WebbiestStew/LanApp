//
//  AnimatedTabIcon.swift
//  LanApp
//
//  Created by Diego Villarreal on 7/1/25.
//

import AudioToolbox
import SwiftUI
import UIKit
import AudioToolbox

struct AnimatedTabIcon: View {
    let icon: String
    let isSelected: Bool

    var body: some View {
        Image(systemName: icon)
            .scaleEffect(isSelected ? 1.2 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isSelected)
            .onChange(of: isSelected) { newValue in
                if newValue {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }
            }
    }
}
