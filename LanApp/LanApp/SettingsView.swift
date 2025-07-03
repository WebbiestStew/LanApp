//
//  SettingsView.swift
//  LanApp
//
//  Created by Diego Villarreal on 7/1/25.
//

import AudioToolbox
import SwiftUI
import UIKit
import AudioToolbox

struct SettingsView: View {
    @Binding var accentColor: Color
    var body: some View {
        VStack(spacing: 20) {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("Select Accent Color")
                .foregroundColor(.gray)

            HStack(spacing: 16) {
                Button(action: {
                    NotificationCenter.default.post(name: Notification.Name("ChangeAccentColor"), object: Color.green)
                }) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 40, height: 40)
                }
                Button(action: {
                    NotificationCenter.default.post(name: Notification.Name("ChangeAccentColor"), object: Color.purple)
                }) {
                    Circle()
                        .fill(Color.purple)
                        .frame(width: 40, height: 40)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}
