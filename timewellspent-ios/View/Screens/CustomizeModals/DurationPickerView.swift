//
//  DurationPickerView.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/19.
//

import SwiftUI

struct DurationPickerView: View {
    @ObservedObject var myMSS: MyManagedSettingsService
    @Binding var showCustomization: Bool
    
    let columns = [
        MultiComponentPicker.Column(label: "min", options: Array(Constants.minDuration...Constants.maxDuration).map { MultiComponentPicker.Column.Option(text: "\($0)", tag: $0) })
    ]
    @Binding var selectedMinute: Int

    var body: some View {
        
        VStack(alignment: .center, spacing: 10) {
            Rectangle()
                .frame(width: 30, height: 3, alignment: .center)
                .cornerRadius(5)
                .foregroundColor(.black.opacity(0.5))
            Spacer()
            Text("Continuous Screen Time")
                .font(.title)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .font(.body)
            Spacer()
            Text("After roughly this much continuous screen time, Mindberry will remind you to take a break.")
                .multilineTextAlignment(.center)
            Spacer()
            MultiComponentPicker(columns: columns, selections: [$selectedMinute])
            Spacer()
            Button {
                DeviceService.shared.setEstimatedSessionTime(to: selectedMinute)
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
        .fontWeight(.light)
        .font(.body)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(EdgeInsets(top: 8, leading: 15, bottom: 20, trailing: 15))
        .foregroundColor(.white)
        .background(.tint)
    }
}

struct DurationPickerView_Previews: PreviewProvider {
    static var previews: some View {
        DurationPickerView(myMSS: MyManagedSettingsService.shared, showCustomization: .constant(true), selectedMinute: .constant(20))
    }
}
