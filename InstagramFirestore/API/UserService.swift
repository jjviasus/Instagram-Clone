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
    
    static func fetchUsers(completion: @escaping([User]) -> Void) { // a completion block that gives us back an array of User's
        
        COLLECTION_USERS.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            // a mapping function takes one data object and then performs some sort of mapping
            // and converts it into another data object
            
            // looks at the documents array from the snapshot.
            // we want to map the documents into a user object, $0 represents each one of the documents data in the document array
            let users = snapshot.documents.map({ User(dictionary: $0.data()) })
            completion(users)
        }
        
    }
}
