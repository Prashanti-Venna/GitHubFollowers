//
//  GHButton.swift
//  GitHubFollowers
//
//  Created by Prashanti Venna on 18/06/2024.
//

import Foundation
import UIKit

extension UIButton {
    func configure(backgorundColor: UIColor, title: String) {
        backgroundColor = backgorundColor
        setTitle(title, for: .normal)
        configure()
    }
    
    func configure() {
        layer.cornerRadius = 10
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = true
    }
}
