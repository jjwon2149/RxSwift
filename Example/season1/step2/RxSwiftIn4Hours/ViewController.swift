//
//  ViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import RxSwift
import UIKit

class ViewController: UITableViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func output(_ s : Any) -> Void {
        print(s)
    }

    @IBAction func exJust1() {
        Observable.from(["RxSwift", "In", "4", "Hours"])
//            .single() // error 반환을 위함
            .subscribe(onNext: output)
            .disposed(by: disposeBag)
//            .subscribe { event in
//                switch event {
//                case .next(let str): // data가 전달되는것
//                    print( "next: \(str)")
//                    break
//                case .error(let err): // error 발생  marble의 X모양
//                    print("Error: \(err.localizedDescription)")
//                    break
//                case .completed: // 데이터 전송 완료 marble의 |모양
//                    print("Complete")
//                    break
//                }
//            }
        // MARK: - Subscribe의 다른 방법
//            .subscribe { <#String#> in
//                <#code#>
//            } onError: { <#any Error#> in
//                <#code#>
//            } onCompleted: {
//                <#code#>
//            } onDisposed: {
//                <#code#>
//            }

         
    }

    @IBAction func exJust2() {
        Observable.just(["Hello", "World"])
            .subscribe(onNext: { arr in
                print(arr)
            })
            .disposed(by: disposeBag)
//        ["Hello", "World"]
    }

    @IBAction func exFrom1() {
        Observable.from(["RxSwift", "In", "4", "Hours"])
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
//        RxSwift
//        In
//        4
//        Hours
    }

    @IBAction func exMap1() {
        Observable.just("Hello")
            .map { str in "\(str) RxSwift" }
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exMap2() {
        Observable.from(["with", "곰튀김"])
            .map { $0.count }
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exFilter() {
        Observable.from([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
            .filter { $0 % 2 == 0 }
            .subscribe(onNext: { n in
                print(n)
            })
            .disposed(by: disposeBag)
//        2
//        4
//        6
//        8
//        10
    }

    @IBAction func exMap3() {
        // observeOn
        // subscribeOn
        Observable.just("800x600")
            // 비동기 작업을 위한 ConcurrentMainScheduler 로 변경
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .map { $0.replacingOccurrences(of: "x", with: "/") }
            .map { "https://picsum.photos/\($0)/?random" }
            .map { URL(string: $0) }
            .filter { $0 != nil }
            .map { $0! } // 위에서 nil체크를 하였으니 강제언래핑 해도 괜찮음.
            .map { try Data(contentsOf: $0) }
            .map { UIImage(data: $0) }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            // UIUpdate를 위한 MainScheduler로 변경
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { image in
                self.imageView.image = image
            })
            .disposed(by: disposeBag)
    }
}
