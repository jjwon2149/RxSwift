# RxSwift

## step1

rxswift install
```
pod 'RxSwift'
```

RxSwift Code
```
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

```
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

## step2

### Just
```
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
```
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
```
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
```
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

### map과 filter를 사용한 imnageUrl 불러오기.
```
@IBAction func exMap3() {
    O~bservable.just("800x600")
        .map { $0.replacingOccurrences(of: "x", with: "/") }
        .map { "https://picsum.photos/\($0)/?random" }
        .map { URL(string: $0) }
        .filter { $0 != nil }
        .map { $0! } // 위에서 nil체크를 하였으니 강제언래핑 해도 괜찮음.
        .map { try Data(contentsOf: $0) }
        .map { UIImage(data: $0) }
        .subscribe(onNext: { image in
            self.imageView.image = image
        })
        .disposed(by: disposeBag)
}
```

### Map과 FlatMap의 차이점
Map은 Data를 Data로 변겯하고, 
FlatMap은 Data를 Stream으로 변경한다.
