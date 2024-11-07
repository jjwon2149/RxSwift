//
//  ViewController.swift
//  Pin&FlexLayoutWithRxSwiftExample
//
//  Created by 정종원 on 10/16/24.
//

import UIKit
import RxSwift
import RxCocoa
import PinLayout
import FlexLayout

class NewsViewController: UIViewController {
    
    // MARK: - Perperties
    private let viewModel = NewsViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UIComponents
    private lazy var tableView =  {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        table.estimatedRowHeight = 100
        table.rx.setDelegate(self).disposed(by: disposeBag)
        return table
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.pin.all()
        view.flex.layout()
    }
    
    // MARK: - Methods
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        view.flex.define { flex in
            flex.addItem(tableView).grow(1)
        }
        
        view.flex.layout()
    }
    
    private func bindViewModel() {
        viewModel.news
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .bind(to: tableView.rx.items(cellIdentifier: NewsTableViewCell.identifier,
                                         cellType: NewsTableViewCell.self)) { index, item, cell in
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UIScrollViewDelegate
extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}
