//
//  UpdateAvailableView.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/20.
//

import SwiftUI

struct UpdateAvailableView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 60) {
            Rectangle()
                .frame(width: 35, height: 4, alignment: .center)
                .cornerRadius(5)
                .foregroundColor(.white.opacity(0.5))
            Spacer()
            Text("A new update is available!")
                .font(.title)
                .fontWeight(.bold)
//                .frame(maxHeight: .infinity)
            ForEach(Constants.updateAvailableFeatures.newFeatures, id: \.self) { update in
                HStack(alignment: .center, spacing: 30) {
                    Image(systemName: update.sysemImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                    VStack(alignment: .leading, spacing: 5) {
                        Text(update.title)
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(update.description)
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                            .minimumScaleFactor(0.6)
                    }
                }
//                .frame(maxHeight: .infinity)
            }
            Spacer()
            HStack(alignment: .center, spacing: 15) {
                Button {
                    isPresented = false
                } label: {
                    Text("Later")
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .fontWeight(.bold)
                }
                    .buttonStyle(.borderedProminent)
                    .tint(.gray.opacity(0.25))
                    .cornerRadius(40)
                Button {
                    UIApplication.shared.open(Constants.appStoreLink as URL)
                } label: {
                    Text("Update")
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .fontWeight(.bold)
                }
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .tint(.accentColor)
                    .cornerRadius(40)
            }
        }
        .font(.body)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(EdgeInsets(top: 8, leading: 20, bottom: 20, trailing: 20))
        .foregroundColor(.white)
        .background(Color.AppPickerBg)
        .onAppear {
            DeviceService.shared.didReceiveNewUpdateAlert(forVersion: Constants.updateAvailableVersion)
        }
    }
}

struct UpdateAvailableView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateAvailableView(isPresented: .constant(true))
    }
}
