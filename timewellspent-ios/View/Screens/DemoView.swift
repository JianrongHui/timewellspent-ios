//
//  DemoView.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/19.
//

import SwiftUI

struct DemoView: View {
    @Binding var showDemo: Bool
    @State private var selectedPage = 0

    var body: some View {
        TabView(selection: $selectedPage) {
            VStack(alignment: .center, spacing: 20) {
                Spacer()
                
                Image("smileberry-xl")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                Text("Welcome to Mindberry.")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Mindberry helps you put your phone down after using it for an extended period of time.")
                    .multilineTextAlignment(.center)
                Spacer()
                Button {
                    withAnimation {
                        selectedPage = 1
                    }
                } label: {
                    Text("Next")
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .fontWeight(.bold)
                }
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.accentColor)
                    .tint(.white)
                    .cornerRadius(40)
                    .padding([.trailing, .leading], 10)
            }.tag(0)
            VStack(alignment: .center, spacing: 20) {
                Spacer()
                Spacer()
                Image("mindberry-demo")
                    .resizable()
                    .scaledToFit()
                    .offset(x: 10)
                Spacer()
                Text("After an interruption,")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Open Mindberry for a guided breathing session or put your phone down for a bit.\n\nApps on your phone will be locked for 5 minutes. During this time, you can only use essential apps like iMessage or Settings.")
                    .multilineTextAlignment(.center)
                Spacer()
                Spacer()
                Spacer()
                Button {
                    showDemo = false
                } label: {
                    Text("Start")
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .fontWeight(.bold)
                }
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.accentColor)
                    .tint(.white)
                    .cornerRadius(40)
                    .padding([.trailing, .leading], 10)
            }
            .tag(1)
        }
        .padding([.leading, .trailing, .bottom], 30)
        .tabViewStyle(.page(indexDisplayMode: .never))
//        .indexViewStyle(.page(backgroundDisplayMode: .never))
        .background(.tint)
    }
}

struct DemoView_Previews: PreviewProvider {
    static var previews: some View {
        DemoView(showDemo: .constant(true))
    }
}
