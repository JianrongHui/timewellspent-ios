//
//  AppPickerView.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/19.
//

import Foundation
import SwiftUI
import FamilyControls

struct AppPickerView: View {
    @ObservedObject var myMSS: MyManagedSettingsService
    @Binding var showDiscouraged: Bool

    var body: some View {
        
        VStack(alignment: .center, spacing: 10) {
            Rectangle()
                .frame(width: 30, height: 3, alignment: .center)
                .cornerRadius(5)
                .foregroundColor(.black.opacity(0.5))
            Spacer()
            Text("App Selection")
                .font(.title)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .font(.body)
            Spacer()
            Text("After using these apps for a while, Mindberry will remind you to take a mindfulness break.")
                .multilineTextAlignment(.center)
            Spacer()
            ZStack(alignment: .center) {
                Rectangle()
                    .foregroundColor(Color.AppPickerBg)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                FamilyActivityPicker(selection: $myMSS.managedSettings.selectionToDiscourage)
                    .padding(.all, 10)
            }
            Spacer()
            Button {
                showDiscouraged = false
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

struct AppPickerView_Previews: PreviewProvider {
    static var previews: some View {
        AppPickerView(myMSS: MyManagedSettingsService.shared, showDiscouraged: .constant(true))
    }
}
