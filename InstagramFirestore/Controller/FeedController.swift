//
//  FeedController.swift
//  InstagramFirestore
//
//  Created by Justin Viasus on 3/3/21.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

// A UI Collection View Controller!
class FeedController: UICollectionViewController {
    
    // MARK: - Lifecycle
    
    private var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPosts()
    }
    
    // MARK: - Actions
    
    @objc func handleRefresh() {
        // remove all the posts from the array
        posts.removeAll()
        
        // refetch the posts
        fetchPosts()
    }
    
    // when the user hits the logout button
    @objc func handleLogout() {
        do {
            // API call
            try Auth.auth().signOut()
            
            // presents them with the login page
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            controller.delegate = self.tabBarController as? MainTabController
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } catch {
            print("DEBUG: Failed to sign out")
        }
    }
    
    // MARK: - API
    
    func fetchPosts() {
        PostService.fetchPosts { posts in
            self.posts = posts
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        collectionView.backgroundColor = .white
        
        // We need to register a cell to the collection view so that it knows what cells to create
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // logout button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        navigationItem.title = "Feed"
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
    
    
}

// MARK: - UICollectionViewDataSource

// We need to tell the collection:
// - view how many items there are going to be
// - and define the size for each item in the collection view

// UICollectionViewController already conforms to the UICollectionViewDataSource protocol, so we don't need to conform to it a second time
extension FeedController {
    // Tells the collection view how many cells to create
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    // Tells the collection view how to create each cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell // casting this as a FeedCell
        cell.viewModel = PostViewModel(post: posts[indexPath.row])
        return cell
    }
}

// Mark: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    // Whatever size this returns will be the size of each collection view cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        var height = width + 8 + 40 + 8 // two 8's for the white space between the top of the screen and the profile pic, and then the profile pic and the image below. 40 for the actual size of the profile pic
        height += 50 // height of 50 for the image view
        height += 60 // for the stuff below the image (the like button, like count, username)
        
        return CGSize(width: width, height: height)
    }
}
