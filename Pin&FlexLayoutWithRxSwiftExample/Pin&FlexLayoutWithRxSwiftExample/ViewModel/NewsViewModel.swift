//
//  NewsViewModel.swift
//  Pin&FlexLayoutWithRxSwiftExample
//
//  Created by 정종원 on 10/16/24.
//

import Foundation
import RxSwift
import RxCocoa

class NewsViewModel {
    // OutPut: View에 전달할 데이터 스트림
    let news: BehaviorSubject<[News]> = BehaviorSubject(value: [])
    let disposeBag = DisposeBag()
    let apiKey = Bundle.main.object(forInfoDictionaryKey: "NEWS_API_KEY") as! String
    
    init() {
        fetchNews()
    }
    
    func fetchNews() {
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\( apiKey)")!
        
        URLSession.shared.rx.data(request: URLRequest(url: url))
            .map { data -> [News] in
                let response = try JSONDecoder().decode(NewsResponse.self, from: data)
                return response.articles
            }
            .bind(to: news)
            .disposed(by: disposeBag)
    }
}
