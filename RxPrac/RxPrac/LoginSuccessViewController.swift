//
//  LoginSuccessViewController.swift
//  RxPrac
//
//  Created by 정종원 on 10/9/24.
//

import UIKit

class LoginSuccessViewController: UIViewController {

    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "brain.head.profile")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
    }
    
    
}
