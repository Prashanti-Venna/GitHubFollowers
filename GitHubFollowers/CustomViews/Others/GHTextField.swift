//
//  GHTextField.swift
//  GitHubFollowers
//
//  Created by Prashanti Venna on 18/06/2024.
//

import Foundation
import UIKit

extension UITextField {
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title2)
        minimumFontSize = 12
        autocorrectionType = .no
        backgroundColor = .tertiarySystemBackground
        textColor = .label
        tintColor = .label
        placeholder = "Enter a username"
    }
}
