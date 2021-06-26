//
//  NotificationsController.swift
//  InstagramFirestore
//
//  Created by Justin Viasus on 3/3/21.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationsController: UITableViewController {
    
    // MARK: - Properties
    
    private var notifications = [Notification]() {
        didSet { tableView.reloadData() } // whenever a change is made to the Notification array, the table view is reloaded
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchNotifications()
    }
    
    // MARK: - API
    
    func fetchNotifications() {
        NotificationService.fetchNotifications { notifications in
            self.notifications = notifications
            print("DEBUG: Notifications \(notifications)")
        }
    }
    
    // MARK: - Helpers
    
    func configureTableView() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
    }
}

extension NotificationsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.viewModel = NotificationViewModel(notification: notifications[indexPath.row])
        return cell
    }
}
