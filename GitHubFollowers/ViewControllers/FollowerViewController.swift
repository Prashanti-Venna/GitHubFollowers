//
//  FollowerViewController.swift
//  GitHubFollowers
//
//  Created by Prashanti Venna on 02/07/2024.
//

import UIKit

enum Section {
    case main
}

protocol FollowerVCDelegate: AnyObject {
    func didRequestFollowers(for userName: String)
}

class FollowerViewController: UIViewController {
    
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var username: String = ""
    var diffableDataSource: UICollectionViewDiffableDataSource<Section, Follower>?
    var pageCount = 1
    var hasMoreFollowers = true
    var isSearching = false
    
    @IBOutlet weak var followerCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureDataSource()
        configureSearchController()
        configureAddFavouritesButton()
        getFollowers(username: username, page: pageCount)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configureViewController() {
        self.navigationController?.title = username
        self.title = username
        self.view.backgroundColor = .systemBackground
    }
    
    func configureAddFavouritesButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtontapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtontapped() {
        showActivityIndicator()
        NetworkManager.shared.getUserInfo(username: username) { [weak self] result in
            guard let self = self else { return }
            hideActivityIndicator()
            switch result {
            case .success(let user):
                addFavourite(for: user)
            case .failure(let error):
                self.showAlert(title: "Something went wrong", message: error.rawValue, actionText: "OK")
            }
        }
    }
    
    private func addFavourite(for user: User) {
        let favourite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        PersistanceManager.updateFavourite(favourite: favourite, actionType: .add) { error in
            guard let error = error else {
                self.showAlert(title: "Success!", message: "You successfully favourited the user", actionText: "Hooray!")
                return
            }
            self.showAlert(title: "Something went wrong", message: error.rawValue, actionText: "Ok")
        }
    }
    
    func configureCollectionView() {
        followerCollectionView.register(UINib(nibName: FollowerCell.reuseId, bundle: nil), forCellWithReuseIdentifier: FollowerCell.reuseId)
    }
    
    func getFollowers(username: String, page: Int) {
        self.showActivityIndicator()
        NetworkManager.shared.getFollowers(username: username, page: page) { [weak self] (result) in
            self?.hideActivityIndicator()
            guard let self = self else { return }
            switch result {
            case .success(let followers):
                if followers.count < 100 {
                    self.hasMoreFollowers = false
                }
                self.updateData(followers: followers)
            case .failure(let error):
                self.showAlert(title: "Something went wrong", message: error.rawValue, actionText: "Ok")
                break
            }
        }
    }
    
    func updateData(followers: [Follower]) {
        self.followers.append(contentsOf: followers)
        DispatchQueue.main.async {
           //self.followerCollectionView.reloadData()
            self.updateSnapshot(followers: followers)
        }
    }
    
    func configureDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: followerCollectionView, cellProvider: { (collectionView, index, follower) in
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseId, for: index) as? FollowerCell
            cell?.updateUI(follower: follower)
            return cell
        })
    }
    
    func updateSnapshot(followers: [Follower]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapShot.appendSections([.main])
        snapShot.appendItems(followers )
        DispatchQueue.main.async {
            self.diffableDataSource?.apply(snapShot, animatingDifferences: true)
        }
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController
    }
}

extension FollowerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = (collectionView.frame.width-20)/3
        return CGSize(width: width, height: width+40)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}

extension FollowerViewController: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers else { return }
            pageCount += 1
            getFollowers(username: username, page: pageCount)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        moveToUserInfoVC(with: follower)
    }
    
    func moveToUserInfoVC(with follower: Follower) {
        let userInfoVC = UserInfoVC()
        userInfoVC.userName = follower.login
        userInfoVC.followerVCDelegate = self
        let navVC = UINavigationController(rootViewController: userInfoVC)
        self.present(navVC, animated: true)
    }
}

extension FollowerViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        filteredFollowers = followers.filter {
            ($0.login ?? "").lowercased().contains(filter.lowercased())
        }
        updateSnapshot(followers: filteredFollowers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateSnapshot(followers: followers)
    }
}

extension FollowerViewController: FollowerVCDelegate {
    
    func didRequestFollowers(for userName: String) {
        self.username = userName
        title = userName
        pageCount = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        followerCollectionView.setContentOffset(.zero, animated: true)
        self.getFollowers(username: userName, page: pageCount)
    }
}

//extension FollowerViewController: UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FollowerCell", for: indexPath) as? FollowerCell else {
//            return UICollectionViewCell()
//        }
//        cell.backgroundColor = .blue
//        if let followers = followers {
//            let follower = followers[indexPath.row]
//            cell.updateUI(follower: follower)
//        }
//        return cell
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if let followers = followers, !followers.isEmpty {
//            return followers.count
//        }
//        return 0
//    }
//}


