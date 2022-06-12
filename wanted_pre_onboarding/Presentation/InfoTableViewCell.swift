//
//  InfoTableViewCell.swift
//  wanted_pre_onboarding
//
//  Created by yc on 2022/06/12.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    static let identifier = "InfoTableViewCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .semibold)
        return label
    }()
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    func setupView(title: String, value: String) {
        setupAttribute()
        setupLayout()
        
        titleLabel.text = title
        valueLabel.text = value
    }
}

// MARK: - UI Methods
private extension InfoTableViewCell {
    func setupAttribute() {
        contentView.backgroundColor = .systemBackground
    }
    func setupLayout() {
        [
            titleLabel,
            valueLabel
        ].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let commonSpacing: CGFloat = 16.0
        
        [
            titleLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: commonSpacing
            ),
            titleLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: commonSpacing
            ),
            titleLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -commonSpacing
            ),
            valueLabel.leadingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor,
                constant: commonSpacing
            ),
            valueLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: commonSpacing
            ),
            valueLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -commonSpacing
            ),
            valueLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -commonSpacing
            )
        ].forEach { $0.isActive = true }
        
        titleLabel.setContentCompressionResistancePriority(
            .init(rawValue: 1000.0),
            for: .horizontal
        )
        valueLabel.setContentCompressionResistancePriority(
            .init(rawValue: 999.0),
            for: .horizontal
        )
        
        titleLabel.setContentHuggingPriority(
            .init(rawValue: 999.0),
            for: .horizontal
        )
        valueLabel.setContentHuggingPriority(
            .init(rawValue: 1000.0),
            for: .horizontal
        )
    }
}
