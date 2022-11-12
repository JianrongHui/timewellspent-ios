//
//  HoverButton.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/11.
//

import Foundation
import SwiftUI

struct HoverButton: View {
    @State var hovered = false

    var body: some View {
        Button {
            print("pressed")
        } label: {
            Text("hover")
        }.onHover { hover in
            self.hovered = hover
            print("HOVERED")
        }.scaleEffect(hovered ? 1.5 : 1)
            .buttonStyle(.borderedProminent)
    }
}

struct HoverButton_Preview: PreviewProvider {
    static var previews: some View {
        HoverButton()
    }
}
