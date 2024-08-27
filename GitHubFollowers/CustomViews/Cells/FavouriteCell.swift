//
//  FavouriteCell.swift
//  GitHubFollowers
//
//  Created by Prashanti Venna on 26/07/2024.
//

import UIKit

class FavouriteCell: UITableViewCell {
    
    static let reuseId = "FavouriteCell"

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = 10
        backgroundColor = .systemBackground
        // Initialization code
    }

    func updateUI(follower: Follower) {
        nameLabel.text = follower.login ?? ""
        ImageHelper.downloadImageView(from: follower.avatarUrl ?? "") { image in
            DispatchQueue.main.async {
                self.avatarImageView.image = image
            }
        }
    }
}
