//
//  CircleImageUIView.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/11.
//

import SwiftUI

struct CircleImageUIView: View {
    var body: some View {
        Image(systemName: "magnifyingglass")
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .font(.system(size: 100, weight: .regular, design: .default))
            .shadow(radius: 7)
            .foregroundColor(.yellow)
    }
}

struct CircleImageUIView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircleImageUIView()
            CircleImageUIView()
        }
        .previewLayout(.fixed(width: 100, height: 70))
    }
}
