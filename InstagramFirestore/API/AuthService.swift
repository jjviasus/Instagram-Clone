//
//  AuthService.swift
//  InstagramFirestore
//
//  Created by Justin Viasus on 3/20/21.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredential credentials: AuthCredentials, completion: @escaping(Error?) -> Void) {

        ImageUploader.uploadImage(image: credentials.profileImage) { (imageUrl) in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                
                if let error = error {
                    print("DEBUG: Failed to register user \(error.localizedDescription)")
                    return
                }
                
                // unique id that uniquely identifies a user
                guard let uid = result?.user.uid else { return }
                
                let data: [String: Any] =
                    ["email": credentials.email,
                    "fullname": credentials.fullname,
                    "profileImageUrl": imageUrl,
                    "uid": uid,
                    "username": credentials.username]
                
                // a collection contains a bunch of documents and documents contains a bunch of fields
                COLLECTION_USERS.document(uid).setData(data, completion: completion)
                
                // we created a users collection, a document with the uid as the document identifier, and then updating the fields in the document
            }
        }
    }
}
