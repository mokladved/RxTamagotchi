//
//  UnderlineTextField.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/23/25.
//

import UIKit
import SnapKit

class UnderlineTextField: UITextField, UIConfigurable {
    let underlineView: UIView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        addSubview(underlineView)
    }
    
    func configureLayout() {
        underlineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(8)
        }
    }
    
    func configureView() {
        underlineView.backgroundColor = .tgCyan
        borderStyle = .none
        textColor = .tgCyan
    }
}
