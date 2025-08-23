//
//  BaseViewController.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/23/25.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureView() {
        view.backgroundColor = .tgBlue
    }
}

