# RxSwift 4시간만에 끝내기.

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

