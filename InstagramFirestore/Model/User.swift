//
//  User.swift
//  InstagramFirestore
//
//  Created by Justin Viasus on 4/2/21.
//

import Foundation
import Firebase

struct User {
    let email: String
    let fullname: String
    let profileImageUrl: String
    let username: String
    let uid: String
    
    var isFollowed = false
    
    var stats: UserStats!
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid }
    
    // we get back a dictionary from Firebase, so this init method is how we are
    // going to construct our user without having to manually pass in all the data
    init(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? "" // just in case it doesn't have a value, we will set it the default value to an empty string ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        
        // Default stats (0,0,0) that get set properly after the API Call
        self.stats = UserStats(followers: 0, following: 0, posts: 0)
    }
}

struct UserStats {
    let followers: Int
    let following: Int
    let posts: Int
}
