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
    
    // if this has a value (not nil), then we only want to show one post in the feed, otherwise (nil) we want to show all the posts.
    var post: Post?
    
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
            controller.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } catch {
            print("DEBUG: Failed to sign out")
        }
    }
    
    // MARK: - API
    
    // This function only executes the api call if post is not equal to nil
    func fetchPosts() {
        // In a guard statement, you check a condition and if it is met, you go on and complete the rest of the code after it. Otherwise it returns out of the function. (prevents us from making an unecessary api call)
        guard post == nil else { return }
        
        // api call
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
        
        if post == nil {
            // logout button
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(handleLogout))
        }
        
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
        return post == nil ? posts.count : 1
    }
    
    // Tells the collection view how to create each cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell // casting this as a FeedCell
        
        cell.delegate = self
        
        // configure feed with the correct posts
        if let post = post { // if the post is not equal to nil, then we store it in this value (post (stored in this value) = post (not nil)).
            cell.viewModel = PostViewModel(post: post)
        } else {
            cell.viewModel = PostViewModel(post: posts[indexPath.row])
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

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

// MARK: - FeedCellDelegate

extension FeedController: FeedCellDelegate {
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post) {
        let controller = CommentController(post: post)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func cell(_ cell: FeedCell, didLike post: Post) {
        cell.viewModel?.post.didLike.toggle()
        
        if post.didLike { // the post has already been liked
            // we want to unlike it
            print("DEBUG: Unlike post here")
        } else {
            // the post has not been liked, we want to like it
            PostService.likePost(post: post) { error in
                if let error = error {
                    print("DEBUG: Failed to like post with \(error)")
                }
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_selected"), for: .normal)
                cell.likeButton.tintColor = .red
            }
        }
    }
}
