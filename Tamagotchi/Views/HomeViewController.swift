//
//  ViewController.swift
//  Tamagotchi
//
//  Created by Youngjun Kim on 8/23/25.
//

import UIKit

class HomeViewController: BaseViewController {
    let chatImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let chatLabel = {
        let label = UILabel()
        label.text = "테스트"
        return label
    }()
    
    let stateWrappedView = UIView()
    
    let tamagotchiImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let nameLabel = {
        let label = UILabel()
        label.text = "테스트"
        return label
    }()
    
    let stateLabel = {
        let label = UILabel()
        label.text = "테스트"
        return label
    }()
    
    let riceTextField = {
        let tf = UITextField()
        return tf
    }()
    
    let riceButton = {
        let button = UIButton()
        return button
    }()
    
    let waterTextField = {
        let tf = UITextField()
        return tf
    }()
    
    let waterButton = {
        let button = UIButton()
        return button
    }()
    
    override func configureHierarchy() {
        view.addSubview(chatImageView)
        chatImageView.addSubview(chatLabel)
        
        view.addSubview(stateWrappedView)
        stateWrappedView.addSubview(tamagotchiImageView)
        stateWrappedView.addSubview(nameLabel)
        stateWrappedView.addSubview(stateLabel)
        
        view.addSubview(riceTextField)
        view.addSubview(riceButton)
        view.addSubview(waterTextField)
        view.addSubview(waterButton)
        
    }
    
    override func configureLayout() {
        
    }
}



