//
//  SVGImage.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/19.
//

import SwiftUI
import SwiftSVG

struct SVGImage: UIViewRepresentable {
    
    var url: URL?
    var color: UIColor?
    
    init(_ url: URL?, color: UIColor? = nil) {
        self.url = url
        self.color = color
    }
    
    func makeUIView(context: Context) -> SVGViewWrapper {
        SVGViewWrapper()
    }
    
    func updateUIView(_ uiView: SVGViewWrapper, context: Context) {
        uiView.color = color
        uiView.url = url
    }
}

final class SVGViewWrapper: UIView {
    var color: UIColor?
    var url: URL? {
        didSet {
            guard let url else { return }
            subviews.forEach { $0.removeFromSuperview() }
            let view = SVGView(SVGURL: url) {
                $0.resizeToFit(self.bounds)
                $0.fillColor = self.color?.cgColor
            }
            addSubview(view)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


#Preview {
    SVGImage(URL(string: "https://overfast-api.tekrop.fr/static/gamemodes/assault-icon.svg"))
        .foregroundStyle(.brown)
        .frame(width: 32, height: 32)
}
