//
//  ShimmerPlaceholderList.swift
//  LanApp
//
//  Created by Diego Villarreal on 7/1/25.
//

import AudioToolbox
import SwiftUI
import UIKit
import AudioToolbox

struct ShimmerPlaceholderList: View {
    var body: some View {
        VStack(spacing: 16) {
            ForEach(0..<5) { _ in
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.1), Color.gray.opacity(0.3)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(height: 60)
                    .shimmering()
            }
        }.padding()
    }
}
