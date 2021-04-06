//
//  SearchController.swift
//  InstagramFirestore
//
//  Created by Justin Viasus on 3/3/21.
//

import UIKit

private let reuseIdentifier = "UserCell"

class SearchController: UITableViewController {
    
    // MARK: - Properties
    
    private var users = [User]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        fetchUsers()
    }
    
    // MARK: - API
    
    func fetchUsers() {
        UserService.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    func configureTableView() {
        view.backgroundColor = .white
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier) // here we are registering a cell that has a reuse identifier
        tableView.rowHeight = 64
    }
}

// MARK: - UITableViewDataSource

extension SearchController {
    // defines how many rows the table view has
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    // defines what each cell in the table view contains
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        //print("Func called")
        //print("DEBUG: Index path row is \(indexPath.row)")
        cell.user = users[indexPath.row]
        return cell
    }
}
