//
//  FavouriteVC.swift
//  GitHubFollowers
//
//  Created by Prashanti Venna on 18/06/2024.
//

import UIKit

class FavouriteVC: UIViewController {

    @IBOutlet weak var favouriteTableView: UITableView!
    
    var favourites: [Follower] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configureUI()
        getFavourites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavourites()
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        title = "Favourites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func getFavourites() {
        PersistanceManager.retrieveFavourites { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let favourites) :
                self.favourites = favourites
                DispatchQueue.main.async {
                    self.favouriteTableView.reloadData()
                }
            case .failure(let error):
                self.showAlert(title: "Something went wrong", message: error.rawValue, actionText: "Ok")
            }
        }
    }
}

extension FavouriteVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return favourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteCell.reuseId, for: indexPath) as? FavouriteCell
        cell?.updateUI(follower: favourites[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favourite = favourites[indexPath.row]
        if let followerListVC = UIStoryboard(name: "FollowerViewController", bundle: nil).instantiateViewController(withIdentifier: "FollowerViewController") as? FollowerViewController {
            followerListVC.username = favourite.login ?? ""
            followerListVC.title = favourite.login ?? ""
            self.navigationController?.pushViewController(followerListVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let favourite = favourites[indexPath.row]
        PersistanceManager.updateFavourite(favourite: favourite, actionType: .remove) { error in
            if error == nil {
                self.getFavourites()
            } else {
                self.showAlert(title: "Something went wrong", message: "Couldnot remove the favourite", actionText: "OK")
            }
        }
    }
    
}
