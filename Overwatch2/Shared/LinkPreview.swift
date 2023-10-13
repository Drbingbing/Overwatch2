//
//  LinkPreview.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/15.
//

import SwiftUI
import LinkPresentation

struct LinkPreview: UIViewRepresentable {
    
    var metaData: LPLinkMetadata
    
    func updateUIView(_ uiView: LPLinkView, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> LPLinkView {
        LPLinkView(metadata: metaData)
    }
}
