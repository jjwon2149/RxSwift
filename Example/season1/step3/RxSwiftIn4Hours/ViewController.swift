//
//  ViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindInput()
        bindOutput()
    }
    
    // MARK: - IBOutler
    
    @IBOutlet var idField: UITextField!
    @IBOutlet var pwField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var idValidView: UIView!
    @IBOutlet var pwValidView: UIView!
    
    // MARK: - Bind UI
    
    let idInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let idValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    let pwInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let pwValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    private func bindInput(){
        // input: id, pw 입력 BehaviorSubject 사용
        idField.rx.text.orEmpty
            .bind(to: idInputText)
            .disposed(by: disposeBag)
        
        //        idField.rx.text.orEmpty //  idField.rx.text.orEmpty는 idInputText에 저장되어있음 따라서
        idInputText
            .map(checkEmailValid)
            .bind(to: idValid)
            .disposed(by: disposeBag)
        
        pwField.rx.text.orEmpty
            .bind(to: pwInputText)
            .disposed(by: disposeBag)
        
        pwInputText
            .map(checkPasswordValid)
            .bind(to: pwValid)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        // output: 로그인버튼 enable/ id,pw 정규식 검사
        
        idValid.subscribe(onNext: { b in
            self.idValidView.isHidden = b
        })
        .disposed(by: disposeBag)
        
        pwValid.subscribe(onNext: { b in
            self.pwValidView.isHidden = b
        })
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
    
    // MARK: - Logic
    
    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }
    
    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
}
