# RxSwift

## Step1

rxswift install
```
pod 'RxSwift'
```

RxSwift Code
```swift
@IBAction func onLoadImage(_ sender: Any) {
    imageView.image = nil

    _ = rxswiftLoadImage(from: LARGER_IMAGE_URL)
        .observeOn(MainScheduler.instance)
        .subscribe({ result in
            switch result {
            case let .next(image):
                self.imageView.image = image

            case let .error(err):
                print(err.localizedDescription)

            case .completed:
                break
            }
        })
}

func rxswiftLoadImage(from imageUrl: String) -> Observable<UIImage?> {
    return Observable.create { seal in
        asyncLoadImage(from: imageUrl) { image in
            seal.onNext(image)
            seal.onCompleted()
        }
        return Disposables.create()
    }
}
```
RX를 쓰는 이유: Async한 작업을 간결하게 작성하기 위함.

### DisposeBag

```swift
var disposeBag: DisposeBag = DisposeBag()

@IBAction func onLoadImage(_ sender: Any) {
    imageView.image = nil

    let disposable = rxswiftLoadImage(from: LARGER_IMAGE_URL)
        .observeOn(MainScheduler.instance)
        .subscribe({ result in
            switch result {
            case let .next(image):
                self.imageView.image = image

            case let .error(err):
                print(err.localizedDescription)

            case .completed:
                break
            }
        })
        .disposed(by: disposeBag)
//        disposeBag.insert(disposable)
}

@IBAction func onCancel(_ sender: Any) {
    // TODO: cancel image loading
    disposeBag = DisposeBag()
}
```

disposeBag에 저장된 disposable 들을 한번에 dispose but DisposeBsg 은 .dispose() 메소드가 존재하지 않아 새로은 disposeBag 인스턴스 주입.

## Step2

### Just
```swift
@IBAction func exJust() {
    Observable.just(["Hello", "World"])
        .subscribe(onNext: { arr in
            print(arr)
        })
        .disposed(by: disposeBag)
//        ["Hello", "World"]
}
```

### From
```swift
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
```

### Map
```swift
@IBAction func exMap1() {
    Observable.just("Hello")
        .map { str in "\(str) RxSwift" }
        .subscribe(onNext: { str in
            print(str)
        })
        .disposed(by: disposeBag)
}
```

### Filter
```swift
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
```

### map과 filter를 사용한 imnageUrl 불러오기. observeOn와 subscribeOn를 곁들인.

```swift
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
            self.imageView.image = image // 사이드 이펙트 발생
        })
        .disposed(by: disposeBag)
}
```
subscribeOn():
Subscription code가 실행될 스케줄러를 바꾸는 메소드입니다. 
기본적으로 observable의 생성은 subscribe()를 호출한 스레드에서 불립니다. 
subscribeOn() 메서드는 observable을 생성할 스레드를 바꿀 수 있게 해줍니다.
-> .subscribe가 호츨될때의 스케줄러를 정함

observeOn():
Observation code가 실행될 스케줄러를 바꾸는 메소드 입니다.
값을 방출할때 스케줄러를 변경할 필요가 있다면 보통 observeOn() 메서드를 사용하여 실행 흐름을 바꿔줍니다.
-> 바로 다음 오퍼레이터부터 스케줄러를 정해줌.

 사이드 이펙트를 허용하는 곳 subscribe, do 를 허용해줌


### Map과 FlatMap의 차이점
Map은 Data를 Data로 변겯하고, 
FlatMap은 Data를 Stream으로 변경한다.

### Subscribe 의 여러 방법
```swift
@IBAction func exJust1() {
    Observable.from(["RxSwift", "In", "4", "Hours"])
//            .single() // error 반환을 위함
        .subscribe { event in
            switch event {
            case .next(let str): // data가 전달되는것
                print( "next: \(str)")
                break
            case .error(let err): // error 발생  marble의 X모양
                print("Error: \(err.localizedDescription)")
                break
            case .completed: // 데이터 전송 완료 marble의 |모양
                print("Complete")
                break
            }
        }
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
```

### RxCocoa


## Step3
### textField의 string이 값이 변경의 스트림
```swift
private func bindUI(){
    // id input +--> check valid --> bullet
    //          |
    //          +--> button enable
    //          |
    // pw input +--> check valid --> bullet
    
idField.rx.text
    .subscribe(onNext: { s in
        print(s)
    })
    .disposed(by: disposeBag)
}
```

### BehaviorSubject
BehaviorSubject 는 초기값을 가진 Subject이다.
```swift
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
```