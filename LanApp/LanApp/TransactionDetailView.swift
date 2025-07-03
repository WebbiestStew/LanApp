//
//  TransactionDetailView.swift
//  LanApp
//
//  Created by Diego Villarreal on 7/1/25.
//

import AudioToolbox
import SwiftUI
import UIKit
import AudioToolbox

struct TransactionDetailView: View {
    let transaction: String

    var body: some View {
        VStack(spacing: 24) {
            Text("Transaction Details")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)

            HStack(spacing: 12) {
                Image(systemName: transaction.contains("sent you") ? "arrow.down.left.circle" : "arrow.up.right.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(transaction.contains("sent you") ? .green : .red)

                Text(transaction.contains("sent you") ? "Received from someone" : "You sent")
                    .font(.headline)
                    .foregroundColor(.white)
            }

            if let amountPart = transaction.components(separatedBy: "$").last?.components(separatedBy: " ").first {
                Text("$\(amountPart)")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            }

            // Static for now; can add actual date tracking later
            Text("June 12, 2025 at 12:00 PM")
                .foregroundColor(.gray)
                .font(.subheadline)

            // Parse note if included as: |note:Your note here
            if let note = transaction.components(separatedBy: "|note:").last, transaction.contains("|note:") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Note:")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    Text(note)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

