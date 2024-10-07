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
        bindUI()
    }
    
    // MARK: - IBOutler
    
    @IBOutlet var idField: UITextField!
    @IBOutlet var pwField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var idValidView: UIView!
    @IBOutlet var pwValidView: UIView!
    
    // MARK: - Bind UI
    
    private func bindUI(){
        // id input +--> check valid --> bullet
        //          |
        //          +--> button enable
        //          |
        // pw input +--> check valid --> bullet
        
        idField.rx.text.orEmpty
        //            .filter { $0 != nil }
        //            .map { $0! } -> .orEmpty로 변경 가능
            .map(checkEmailValid)
            .subscribe(onNext: { s in
                self.idValidView.isHidden = s
            })
            .disposed(by: disposeBag)
        
        pwField.rx.text.orEmpty
            .map(checkPasswordValid)
            .subscribe(onNext: { s in
                self.pwValidView.isHidden = s
            })
            .disposed(by: disposeBag)
        
        
        //MARK: - combineLatest: 다른 Observable을 결합시켜 새로운 Observable을 생성해야 한다
        Observable.combineLatest(idField.rx.text.orEmpty.map(checkEmailValid), pwField.rx.text.orEmpty.map(checkPasswordValid),
            resultSelector: {s1, s2 in s1 && s2}
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
