//
//  MindfulnessDurationPickerView.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/20.
//

import Foundation
import SwiftUI

struct MindfulnessDurationPickerView: View {
    @ObservedObject var myMSS: MyManagedSettingsService
    @Binding var showCustomization: Bool
    
    let columns = [
        MultiComponentPicker.Column(label: "min", options: Array(1...5).map { MultiComponentPicker.Column.Option(text: "\($0)", tag: $0) })
    ]
    @Binding var selectedMinute: Int

    var body: some View {
        
        VStack(alignment: .center, spacing: 10) {
            Rectangle()
                .frame(width: 30, height: 3, alignment: .center)
                .cornerRadius(5)
                .foregroundColor(.black.opacity(0.5))
            Spacer()
            Text("Mindfulness Break")
                .font(.title)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .font(.body)
            Spacer()
            Text("After an interruption, open Mindberry for a guided breathing session of this length.\n\nRegardless of this length, your phone will be locked for 5 minutes after an interruption.")
                    .lineLimit(5)
                    .minimumScaleFactor(0.8)
                .multilineTextAlignment(.center)
            Spacer()
            MultiComponentPicker(columns: columns, selections: [$selectedMinute])
            Spacer()
            Button {
                DeviceService.shared.setMindfulnessDuration(to: selectedMinute)
                showCustomization = false
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .fontWeight(.bold)
            }
                .buttonStyle(.borderedProminent)
                .foregroundColor(.accentColor)
                .tint(.white)
                .cornerRadius(40)
        }
        .font(.body)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(EdgeInsets(top: 8, leading: 15, bottom: 20, trailing: 15))
        .foregroundColor(.white)
        .background(.tint)
    }
}

struct MindfulnessDurationPickerView_Previews: PreviewProvider {
    static var previews: some View {
        MindfulnessDurationPickerView(myMSS: MyManagedSettingsService.shared, showCustomization: .constant(true), selectedMinute: .constant(20))
    }
}
