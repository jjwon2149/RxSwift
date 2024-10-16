//
//  MenuListViewModel.swift
//  RxSwift+MVVM
//
//  Created by 정종원 on 10/16/24.
//  Copyright © 2024 iamchiwon. All rights reserved.
//

import Foundation
import RxSwift

class MenuListViewModel {
    
    lazy var menuObservable = BehaviorSubject<[Menu]>(value: [])
    
    lazy var itemsCount = menuObservable.map {
        $0
            .map{ $0.count }
            .reduce(0, +)
    }
    lazy var totalPrice = menuObservable.map {
        $0
            .map{ $0.price * $0.count }
            .reduce(0, +)
    }
    
    init() {
        let menus: [Menu] = [
            Menu(id: 0, name: "튀김 1", price: 100, count: 0),
            Menu(id: 1, name: "튀김 2", price: 100, count: 0),
            Menu(id: 2, name: "튀김 3", price: 100, count: 0),
            Menu(id: 3, name: "튀김 4", price: 100, count: 0),
        ]
        
        menuObservable.onNext(menus)
    }
    
    func clearAllItemSelections() {
        _ = menuObservable
            .map { menus in
                menus.map { menu in
                    Menu(id: menu.id,
                         name: menu.name,
                         price: menu.price,
                         count: 0)
                }
            }
            .take(1) // 1번만 사용 disposable사용 X 할수있음.
            .subscribe(onNext: {
                self.menuObservable.onNext( $0 )
            })
    }
    
    func changeCount(item: Menu, increse: Int) {
        _ = menuObservable
            .map { menus in
                menus.map { menu in
                    if menu.id == item.id {
                        Menu(id: menu.id,
                             name: menu.name,
                             price: menu.price,
                             count: max(menu.count + increse, 0)) // -를 계속할시 음수가 되지 않기 위해.
                    } else {
                        Menu(id: menu.id,
                             name: menu.name,
                             price: menu.price,
                             count: menu.count)
                    }
                }
            }
            .take(1) // 1번만 사용 disposable사용 X 할수있음.
            .subscribe(onNext: {
                self.menuObservable.onNext( $0 )
            })
    }
}
