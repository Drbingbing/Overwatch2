//
//  ScaledButtonStyle.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/14.
//

import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.spring(), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == ScaleButtonStyle {
    
    static var scaled: ScaleButtonStyle {
        return ScaleButtonStyle()
    }
}
