//
//  FollowerCell.swift
//  GitHubFollowers
//
//  Created by Prashanti Venna on 03/07/2024.
//

import UIKit

class FollowerCell: UICollectionViewCell {
    
    static let reuseId = "FollowerCell"

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = 10
        backgroundColor = .systemBackground
        // Initialization code
    }

    func updateUI(follower: Follower) {
        usernameLabel.text = follower.login ?? ""
        ImageHelper.downloadImageView(from: follower.avatarUrl ?? "") { image in
            DispatchQueue.main.async {
                self.avatarImageView.image = image
            }
        }
    }
}
