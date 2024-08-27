//
//  GHRepoItemVC.swift
//  GitHubFollowers
//
//  Created by Prashanti Venna on 25/07/2024.
//

import Foundation

class GHRepoItemVC: GHItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemOne.set(itemInfoType: .repo, with: user?.publicRepos ?? 0)
        itemTwo.set(itemInfoType: .gists, with: user?.publicGists ?? 0)
        actionButton.setBackgroundColor(color: .systemPurple, title: "GitHub Profile")
    }
    
    override func actionButtonTapped() {
        delegate?.didTapGitHubProfile(user: user)
    }
}

