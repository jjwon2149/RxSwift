//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MenuViewController: UIViewController {
    // MARK: - Life Cycle
    
    let cellId = "MenuItemTableViewCell"
    
    let viewModel = MenuListViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = nil
                
        viewModel.menuObservable
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: cellId, cellType: MenuItemTableViewCell.self)) { index, item, cell in
                cell.title.text = item.name
                cell.price.text = "\(item.price)"
                cell.count.text = "\(item.count)"
                
                cell.onChange = { [weak self] increse in
                    self?.viewModel.changeCount(item: item, increse: increse)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.itemsCount
            .map { "\($0)" }
//            .catchErrorJustReturn("") // Error 발생시 빈문자열 반환.
//            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: "")
            .drive(itemCountLabel.rx.text) // catchErrorJustReturn 와 메인쓰레드를 같이사용
            .disposed(by: disposeBag)
        
        viewModel.totalPrice
            .map {
                $0.currencyKR()
            }
            .observeOn(MainScheduler.instance)
            .bind(to: totalPrice.rx.text)
            .disposed(by: disposeBag)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier ?? ""
        if identifier == "OrderViewController",
            let orderVC = segue.destination as? OrderViewController {
            // TODO: pass selected menus
        }
    }

    func showAlert(_ title: String, _ message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertVC, animated: true, completion: nil)
    }

    // MARK: - InterfaceBuilder Links

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var itemCountLabel: UILabel!
    @IBOutlet var totalPrice: UILabel!

    @IBAction func onClear() {
        viewModel.clearAllItemSelections()
    }

    @IBAction func onOrder(_ sender: UIButton) {
        // TODO: no selection
        // showAlert("Order Fail", "No Orders")
//        performSegue(withIdentifier: "OrderViewController", sender: nil)

        viewModel.menuObservable
            .onNext([
                Menu(id: 0, name: "바뀜", price: 10_000, count: 2),
                Menu(id: 1, name: "바뀜", price: 10_000, count: 2),
                Menu(id: 2, name: "바뀜", price: 10_000, count: 2),
                Menu(id: 3, name: "바뀜", price: 10_000, count: 2)
            ])
    }
}
