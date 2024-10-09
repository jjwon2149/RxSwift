//
//  ViewController.swift
//  RxPrac
//
//  Created by 정종원 on 10/8/24.
//

import UIKit
import RxSwift
import RxCocoa

/// id와 pw의 Valid를 통과하지 못한다면 TextFiled의 빨간색 테두리로 변경, Login Button Enable False

extension UIView {
    func addSubviews(_ views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
}

class ViewController: UIViewController {
    
    //MARK: - Properties
    private let idInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    private let idValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    
    private let pwInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    private let pwValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    /// ID Field
    private lazy var idTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "id를 입력해 주세요."
        textField.layer.borderColor = UIColor.red.cgColor
        textField.backgroundColor = .systemGray5
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    /// PW Field
    private lazy var pwTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "pw를 입력해 주세요."
        textField.isSecureTextEntry = true
        textField.layer.borderColor = UIColor.red.cgColor
        textField.backgroundColor = .systemGray5
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    /// Login Button
    private lazy var loginButton: UIButton = {
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.title = "Login"
        let button = UIButton(configuration: buttonConfig)
        button.isEnabled = false
        button.addAction(UIAction(handler: { _ in
            self.present(LoginSuccessViewController(), animated: true)
        }), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupUI()
        inputBind()
        outputBind()
    }
    
    //MARK: - Methods
    private func setupUI() {
        view.addSubviews([
            idTextField,
            pwTextField,
            loginButton
        ])
        
        NSLayoutConstraint.activate([
            idTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            idTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            idTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            idTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            pwTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            pwTextField.topAnchor.constraint(equalTo: idTextField.bottomAnchor, constant: 20),
            pwTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            pwTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            loginButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: pwTextField.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
    
    private func inputBind() {
        idTextField.rx.text.orEmpty
            .bind(to: idInputText) // idTextField는 BehaviorSubject임으로 데이터를 저장해둠. 따라서 Bind idInputText를 하면 idInputText에 저장이 됨.
            .disposed(by: disposeBag)
        
        idInputText
            .map(checkIDValid)
            .bind(to: idValid)
            .disposed(by: disposeBag)
        
        
        pwTextField.rx.text.orEmpty
            .bind(to: pwInputText)
            .disposed(by: disposeBag)
        
        pwInputText
            .map(checkPWValid)
            .bind(to: pwValid)
            .disposed(by: disposeBag)
        
    }
    
    private func outputBind() {
        idValid
            .skip(1)
            .subscribe { isValid in
                self.idTextField.layer.borderWidth = isValid ? 0 : 1
            }
            .disposed(by: disposeBag)
        
        pwValid
            .skip(1)
            .subscribe { isValid in
                self.pwTextField.layer.borderWidth = isValid ? 0 : 1
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(idValid,
                                 pwValid,
                                 resultSelector: { $0 && $1 }
        )
        .subscribe(onNext: { b in
            self.loginButton.isEnabled = b
        })
        .disposed(by: disposeBag)
    }
    
    private func checkIDValid(_ id: String) -> Bool {
        return id.contains("@") && id.contains(".")
    }
    
    private func checkPWValid(_ pw: String) -> Bool {
        return pw.count >= 6
    }
}

