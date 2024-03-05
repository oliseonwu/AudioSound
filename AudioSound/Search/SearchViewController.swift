//
//  SearchViewController.swift
//  AudioSound
//
//  Created by ANISHA
//

import UIKit
import ParseSwift

class SearchViewController: UIViewController {

    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tableViewSearch: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    var usernameSearch = ""
    
    private var users = [User]() {
        didSet {
            // Reload table view data any time the posts variable gets updated.
            tableViewSearch.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewSearch.delegate = self
        tableViewSearch.dataSource = self
        tableViewSearch.allowsSelection = true
        
        tfSearch.delegate = self

        tableViewSearch.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
        refreshControl.tintColor = UIColor.white
    }
    
    func loadUsers(username: String) {
        refreshControl.beginRefreshing()
        
        let constraint: QueryConstraint = "username" == username
        let query = User.query(constraint)
        
        query.find { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
                self?.refreshControl.endRefreshing()
                
                if users.count == 0 {
                    print("No users found")
                }
            case .failure(let error):
                print("Error \(error.localizedDescription)")
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc private func onPullToRefresh() {
        refreshControl.beginRefreshing()
        loadUsers(username: usernameSearch)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchCell
        
        cell.configure(with: users[indexPath.row])
        cell.delegate = self
        
        return cell
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let text = textField.text {
            if text.count > 0 {
                usernameSearch = text
                loadUsers(username: text)
            }
        }
        
        return true
    }
}

extension SearchViewController: MyTableViewCellDelegate {
    func didTapButton(user: User, button: UIButton) {
        print(user)
        button.setTitle("Following", for: .normal)
        
        var follower = Followers()

        follower.user = User.current!
        follower.followinguser = user

        follower.save { [weak self] result in

            // Switch to the main thread for any UI updates
            DispatchQueue.main.async {
                switch result {
                case .success(let follower):
                    print("✅ Followed! \(follower)")
                        
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
