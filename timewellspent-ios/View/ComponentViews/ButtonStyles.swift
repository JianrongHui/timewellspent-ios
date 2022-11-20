//
//  ButtonStyles.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/11.
//

import Foundation
import SwiftUI

struct ShrinkButtonStyle: ButtonStyle {

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .padding()
      .foregroundColor(.white)
      .background(configuration.isPressed ? Color.red : Color.blue)
      .cornerRadius(8.0)
      .scaleEffect(configuration.isPressed ? 0.9 : 1)
      .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
  }

}
