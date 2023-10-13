//
//  Extension+Button.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/14.
//

import SwiftUI

extension View {
    
    func onTap<S: ButtonStyle>(style: S = .scaled, _ action: @escaping () -> Void) -> some View {
        Button(action: action) { self }
            .buttonStyle(style)
    }
}
