//
//  UserService.swift
//  InstagramFirestore
//
//  Created by Justin Viasus on 4/2/21.
//

import Firebase

// fetches user information
struct UserService {
    // when called, retrieves information from Firebase
    static func fetchUser(completion: @escaping(User) -> Void) { // the completion handler gives us back our user
        // gets the current user's user id
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            // this gives us all the data in a dictionary format
            //print("DEBUG: Snapshot is \(snapshot?.data())")
            
            guard let dictionary = snapshot?.data() else { return }
            
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
}
