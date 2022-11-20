//
//  Environments.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/17.
//

import Foundation
import SwiftUI

struct Meditation: EnvironmentKey {
    static var defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var meditation: Binding<Bool> {
        get { self[Meditation.self] }
        set { self[Meditation.self] = newValue }
    }
}
