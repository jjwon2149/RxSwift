//
//  NewsTableViewCell.swift
//  Pin&FlexLayoutWithRxSwiftExample
//
//  Created by 정종원 on 10/16/24.
//

import UIKit
import PinLayout
import FlexLayout


class NewsTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "NewsTableViewCell"
    
    // MARK: - UIComponents
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let containerView = UIView()
    
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.flex.direction(.column).padding(10).define { flex in
            flex.addItem(titleLabel).margin(10, 0, 10, 0)
            flex.addItem(descriptionLabel).marginBottom(10)
        }
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 10)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 8)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .gray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.pin.all()
        containerView.flex.layout(mode: .adjustHeight)
    }
    
    func configure(with news: News) {
        titleLabel.text = news.title
        descriptionLabel.text = news.description
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
