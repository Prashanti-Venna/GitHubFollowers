//
//  GHActionButton.swift
//  GitHubFollowers
//
//  Created by Prashanti Venna on 08/07/2024.
//

import UIKit

class GHActionButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureUI() {
        layer.cornerRadius = 10
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setBackgroundColor(color: UIColor, title: String) {
        self.backgroundColor = color
        setTitle(title, for: .normal)
    }
}
