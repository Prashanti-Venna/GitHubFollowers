//
//  GHItemInfoVC.swift
//  GitHubFollowers
//
//  Created by Prashanti Venna on 08/07/2024.
//

import UIKit

class GHItemInfoVC: UIViewController {
    
    let stackView = UIStackView()
    let itemOne = GHItemInfoView()
    let itemTwo = GHItemInfoView()
    let actionButton = GHActionButton()
    var user: User?
    weak var delegate: UserInfoVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        configureStackView()
        configureActionButton()
    }
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureBackgroundView() {
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 18
    }
    
    private func layoutUI() {
        view.addSubview(stackView)
        view.addSubview(actionButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        stackView.addArrangedSubview(itemOne)
        stackView.addArrangedSubview(itemTwo)
    }
    
    private func configureActionButton() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }

    @objc func actionButtonTapped() {
        
    }
}
