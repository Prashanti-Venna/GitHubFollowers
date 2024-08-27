//
//  UserInfoVC.swift
//  GitHubFollowers
//
//  Created by Prashanti Venna on 05/07/2024.
//

import UIKit

protocol UserInfoVCDelegate: AnyObject {
    func didTapGitHubProfile(user: User?)
    func didTapGetFollowers(user: User?)
}

class UserInfoVC: UIViewController {
    
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    var itemViews: [UIView] = []
    let dateLabel = GHBodyLabel(textAlignment: .center)
    
    var userName: String?
    weak var followerVCDelegate: FollowerVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        getUserInfo()
        layoutUI()
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true)
    }
    
    fileprivate func configureVC() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    fileprivate func getUserInfo() {
        NetworkManager.shared.getUserInfo(username: userName ?? "") { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let user) :
                DispatchQueue.main.async {
                    self.addHeaderView(user: user)
                }
            case .failure(let error): self.showAlert(title: "Something went wrong", message: error.rawValue, actionText: "OK")
            }
        }
    }
    
    func addHeaderView(user: User) {
        let repoItemVC = GHRepoItemVC(user: user)
        repoItemVC.delegate = self
        let followerItemVC = GHFollowerItemVC(user: user)
        followerItemVC.delegate = self
        self.add(childVC: repoItemVC, to: self.itemViewOne)
        self.add(childVC: followerItemVC, to: self.itemViewTwo)
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.dateLabel.text = "Github since " + (user.createdAt?.convertToDisplayFormat() ?? "N/A")
    }
    
    func layoutUI() {
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        let padding: CGFloat = 20
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            ])
        }
        
        itemViewOne.backgroundColor = .systemGray
        itemViewTwo.backgroundColor = .systemGray
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: 140),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: 140),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
            
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
}

extension UserInfoVC: UserInfoVCDelegate {
    func didTapGitHubProfile(user: User?) {
        guard let url = URL(string:  user?.htmlUrl ?? "")  else {
            self.showAlert(title: "Invalid URL", message: "URL tagged to this user is invalid", actionText: "OK")
            return
        }
        presentSafariVC(with: url)
    }
    
    func didTapGetFollowers(user: User?) {
        guard let user = user, user.followers != 0 else {
            self.showAlert(title: "No Followers", message: "This user has no follwers", actionText: "OK")
            return
        }
        followerVCDelegate?.didRequestFollowers(for: user.login ?? "")
        dismissVC()
    }
}

