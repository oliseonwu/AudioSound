//
//  SettingsViewController.swift
//  AudioSound
//
//  Created by Olisemedua Onwuatogwu on 5/15/23.
//

import UIKit

class SettingsViewController: UIViewController{

    @IBOutlet weak var optionTableView: UITableView!
    
    let optionList = ["LogOut"]
    override func viewDidLoad() {
        super.viewDidLoad()
        optionTableView.dataSource = self
        optionTableView.delegate = self

        // Do any additional setup after loading the view.
    }

}

extension SettingsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionList.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath) as? OptionViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(optionName: optionList[indexPath.item])
        
        return cell
    }

}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath) as? OptionViewCell else {
            return 
        }
        if let optionName = cell.optionName.text {
            print(optionName)
            switch(optionName){
            case "Logout":
                onLoggedOutTapped()
                break
            default:
                return
            }
        }
    }
    
    private func showConfirmLogoutAlert() {
        let alertController = UIAlertController(title: "Log out of \(User.current?.username ?? "current account")?", message: nil, preferredStyle: .alert)
        let logOutAction = UIAlertAction(title: "Log out", style: .destructive) { _ in
            NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(logOutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func onLoggedOutTapped() {
        showConfirmLogoutAlert()
    }
}
