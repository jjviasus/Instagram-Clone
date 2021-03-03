//
//  MainTabController.swift
//  InstagramFirestore
//
//  Created by Justin Viasus on 3/3/21.
//

// our custom root view controller of our application
import UIKit

class MainTabController: UITabBarController {
    
    // MARK: - Lifecycle
    
    // This is what gets called when the view loads in memory by the application.
    // Anything that happens when the view loads gets put into this function.
    override func viewDidLoad() {
        super.viewDidLoad() 
        configureViewControllers()
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
        
        let profile = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: ProfileController())
        
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
