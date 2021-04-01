//
//  MainTabController.swift
//  InstagramFirestore
//
//  Created by Justin Viasus on 3/3/21.
//

import UIKit
import Firebase

// our custom root view controller of our application
class MainTabController: UITabBarController {
    
    // MARK: - Lifecycle
    
    // This is what gets called when the view loads in memory by the application.
    // Anything that happens when the view loads gets put into this function.
    override func viewDidLoad() {
        super.viewDidLoad() 
        configureViewControllers()
        checkIfUserIsLoggedIn()
    }
    
    // MARK: - API
    
    func checkIfUserIsLoggedIn() {
        // Auth.auth().currentUser involves an API call to check and see if the current user is logged in or if it exists (this happens asynchronously / on some background thread)
        if Auth.auth().currentUser == nil {
            // We need to be on the main queue to present the login controller while the above is happening (allows us to hope back on the main thread) (any UI updating has to be on the main thread)
            DispatchQueue.main.async {
                let controller = LoginController()
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Helpers
    
    // Where we set up all the view controllers for the tab bar controller
    func configureViewControllers() {
        view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout() // use this to initialize the feed controller
        let feed = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: FeedController(collectionViewLayout: layout)) // collectionViewLayout is a parameter of UICollectionViewController
        
        let search = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchController())
        
        let imageSelector = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"), rootViewController: ImageSelectorController())
        
        let notifications = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: NotificationsController())
        
        let profileLayout = UICollectionViewFlowLayout()
        let profile = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: ProfileController(collectionViewLayout: profileLayout))
        
        // This is where we set the view controllers.
        // We have this property because we are inheriting from the UITabBarController
        viewControllers = [feed, search, imageSelector, notifications, profile]
        
        // Gives all our tab bar icons a black color
        tabBar.tintColor = .black
    }
    
    // A navigation controller allows us to move back and forth between screens easily and inherits this functionality from Swift
    
    // Embeds each one of our view controllers in a navigation controller, and also sets the images for that controller.
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        
        // Create the navigation controller
        let nav = UINavigationController(rootViewController: rootViewController)
        
        // Unselected image
        nav.tabBarItem.image = unselectedImage
        
        // Selected image
        nav.tabBarItem.selectedImage = selectedImage
        
        // Gives everything a black tint
        nav.navigationBar.tintColor = .black
        
        // Return our navigation controller
        return nav
    }
}
