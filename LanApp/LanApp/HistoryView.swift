//
//  HistoryView.swift
//  LanApp
//
//  Created by Diego Villarreal on 7/1/25.
//

import AudioToolbox
import SwiftUI
import UIKit
import AudioToolbox

struct HistoryView: View {
    let transactions: [String]
    @State private var selectedFilter: String = "All"
    @Binding var accentColor: Color

    var body: some View {
        NavigationStack {
            ScrollView {
                // Inserted History title before VStack
                Text("History")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.top)

                Picker("Filter", selection: $selectedFilter) {
                    Text("All").tag("All")
                    Text("Sent").tag("Sent")
                    Text("Received").tag("Received")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    let filteredTransactions = transactions.filter { txn in
                        if selectedFilter == "Sent" {
                            return txn.contains("You sent")
                        } else if selectedFilter == "Received" {
                            return txn.contains("sent you")
                        }
                        return true
                    }

                    ForEach(Array(filteredTransactions.enumerated()), id: \.element) { index, txn in
                        ZStack {
                            NavigationLink(destination: TransactionDetailView(transaction: txn)) {
                                HStack {
                                    Image(systemName: txn.contains("You sent") ? "arrow.up.right.circle" : "arrow.down.left.circle")
                                        .foregroundColor(txn.contains("You sent") ? .red : .green)
                                        .frame(width: 30)

                                    Text(txn)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding()
                                .background(txn.contains("You sent") ? Color.red.opacity(0.15) : Color.green.opacity(0.15))
                                .cornerRadius(10)
                                .padding(.horizontal)
                            }
                        }
                        .rotationEffect(.degrees(Double(index % 2 == 0 ? -1 : 1)))
                        .offset(x: 0, y: CGFloat(index * 2))
                    }
                }
                .padding(.top)
            }
            .background(Color.black)
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
