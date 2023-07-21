//
//  ViewController.swift
//  testingapi
//
//  Created by AnkurPipaliya on 21/07/23.
//

import UIKit
import Moya

class ViewController: UITableViewController
{
    var users = [User]()
    let userProvider = MoyaProvider<UserService>()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        userProvider.request(.readUser) { result in
            switch result {
            case .success(let response):
                let users = try! JSONDecoder().decode([User].self, from: response.data)
                self.users = users
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        print("btn clicked.")
        let obj = User(id: 55, name: "killo loko")
        userProvider.request(.createUser(name: obj.name)) { result in
            switch result {
            case .success(let res):
                let newUser = try! JSONDecoder().decode(User.self, from: res.data)
                self.users.insert(newUser, at: 0)
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count

    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        print(user)
        userProvider.request(.updateUser(id: user.id, name: "[Modified]" + user.name)) { result in
            switch result {
            case .success(let res):
                let editUser = try! JSONDecoder().decode(User.self, from: res.data)
                self.users[indexPath.row] = editUser
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return }
        
        let user = users[indexPath.row]
        print(user)
        
        userProvider.request(.deleteUser(id: user.id)) { result in
            switch result {
            case .success(let res):
                self.users.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            case .failure(let err):
                print(err)
            }
        }
    }
}

