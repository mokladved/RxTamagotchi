//
//  UIButton + Extension.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/24/25.
//

import UIKit

extension UIButton {
    func dalkomStyle(title: String, image: UIImage? = nil, cornerRadius: CGFloat = 10, strokeWidth: CGFloat = 1) {
        var config = Configuration.plain()
        
        let attributes = AttributeContainer([
            .font: UIFont.systemFont(ofSize: 13, weight: .bold)
        ])
        config.attributedTitle = AttributedString(title, attributes: attributes)

        config.image = image
        config.imagePadding = 4
        config.baseForegroundColor = .tgCyan
        config.baseBackgroundColor = .tgBlue
        config.background.strokeColor = .tgCyan
        config.background.strokeWidth = strokeWidth
        config.background.cornerRadius = cornerRadius
        self.configuration = config
    }
}
