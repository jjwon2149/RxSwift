//
//  Menu.swift
//  RxSwift+MVVM
//
//  Created by 정종원 on 10/16/24.
//  Copyright © 2024 iamchiwon. All rights reserved.
//

import Foundation

struct Menu: Decodable {
    var id: Int
    var name: String
    var price: Int
    var count: Int
}

extension Menu {
    static func fromMenuItems(id: Int, item: MenuItem) -> Menu {
        return Menu(id: id, name: item.name, price: item.price, count: 0)
    }
}
