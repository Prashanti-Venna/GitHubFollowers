//
//  GHFollowerItemVC.swift
//  GitHubFollowers
//
//  Created by Prashanti Venna on 25/07/2024.
//

import Foundation

class GHFollowerItemVC: GHItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemOne.set(itemInfoType: .followers, with: user?.followers ?? 0)
        itemTwo.set(itemInfoType: .following, with: user?.following ?? 0)
        actionButton.setBackgroundColor(color: .systemGreen, title: "Get Followers")
    }
    
    override func actionButtonTapped() {
        delegate?.didTapGetFollowers(user: user)
    }
}
