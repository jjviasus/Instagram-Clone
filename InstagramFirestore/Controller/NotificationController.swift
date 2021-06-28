//
//  NotificationsController.swift
//  InstagramFirestore
//
//  Created by Justin Viasus on 3/3/21.
//

// It's a good process for any time you have a process that involves contacting your api, you should show the loader.

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationsController: UITableViewController {
    
    // MARK: - Properties
    
    private var notifications = [Notification]() {
        didSet { tableView.reloadData() } // whenever a change is made to the Notification array, the table view is reloaded
    }
    
    private let refresher = UIRefreshControl()
    
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
            self.checkIfUserIsFollowed()
        }
    }
    
    func checkIfUserIsFollowed() {
        
        notifications.forEach { notification in
            guard notification.type == .follow else { return }
            
            UserService.checkIfUserIsFollowed(uid: notification.uid) { isFollowed in
                if let index = self.notifications.firstIndex(where: { $0.id == notification.id }) {
                    self.notifications[index].userIsFollowed = isFollowed
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @objc func handleRefresh() {
        notifications.removeAll()
        fetchNotifications()
        refresher.endRefreshing()
    }
    
    // MARK: - Helpers
    
    func configureTableView() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher
        
    }
}

// MARK: - UITableViewDataSource

extension NotificationsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.viewModel = NotificationViewModel(notification: notifications[indexPath.row])
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NotificationsController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLoader(true) // show the loading indicator (prevents the user from interacting with the UI)
        
        UserService.fetchUser(withUid: notifications[indexPath.row].uid) { user in
            self.showLoader(false) // hide the loading indicator (allows the user to interact with the UI)
            
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: - NotificationCellDelegate

extension NotificationsController: NotificationCellDelegate {
    func cell(_ cell: NotificationCell, wantsToFollow uid: String) {
        //print("DEBUG: Follow user here..")
        
        showLoader(true)
        
        UserService.follow(uid: uid) { _ in
            self.showLoader(false)
            cell.viewModel?.notification.userIsFollowed.toggle()
        }
    }
    
    func cell(_ cell: NotificationCell, wantsToUnfollow uid: String) {
        //print("DEBUG: Unfollow user here..")
        
        showLoader(true)
        
        UserService.unfollow(uid: uid) { _ in
            self.showLoader(false)
            cell.viewModel?.notification.userIsFollowed.toggle()
        }
    }
    
    func cell(_ cell: NotificationCell, wantsToViewPost postId: String) {
        //print("DEBUG: Show post here..")
        
        showLoader(true)
        
        PostService.fetchPost(withPostId: postId) { post in
            self.showLoader(false)
            let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
            controller.post = post
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
}

