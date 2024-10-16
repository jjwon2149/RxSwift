//
//  NewsModel.swift
//  Pin&FlexLayoutWithRxSwiftExample
//
//  Created by 정종원 on 10/16/24.
//

import Foundation

struct NewsResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [News]
}

struct News: Decodable {
    let title: String
    let description: String?
}
