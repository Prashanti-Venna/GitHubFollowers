//
//  SearchVC.swift
//  GitHubFollowers
//
//  Created by Prashanti Venna on 18/06/2024.
//

import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var getFollowersButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    var isUsernameEmpty: Bool { return usernameTextField.text?.isEmpty ?? true}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirgureUI()
        // Do any additional setup after loading the view.
    }
    
    func confirgureUI() {
        usernameTextField.configure()
        getFollowersButton.configure(backgorundColor: .systemGreen, title: "Get Followers")
        logoImageView.image = UIImage(named: "gh-logo")
        view.backgroundColor = .systemBackground
    }
    
    func moveToFollowerListVC() {
        guard !isUsernameEmpty else {
            showAlert()
            return
        }
        if let followerListVC = UIStoryboard(name: "FollowerViewController", bundle: nil).instantiateViewController(withIdentifier: "FollowerViewController") as? FollowerViewController {
            followerListVC.username = usernameTextField.text ?? ""
            followerListVC.title = usernameTextField.text ?? ""
            self.navigationController?.pushViewController(followerListVC, animated: true)
        }
    }
    
    func showAlert() {
        self.showAlert(title: "Empty Username", message: "Please enter a username. We need to know whom to look for.", actionText: "Ok")
    }
    
    @IBAction func getFollowers(_ sender: Any) {
        moveToFollowerListVC()
    }
}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        moveToFollowerListVC()
       return true
    }
}
