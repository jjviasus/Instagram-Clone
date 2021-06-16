//
//  PostService.swift
//  InstagramFirestore
//
//  Created by Justin Viasus on 5/20/21.
//
import UIKit
import Firebase

struct PostService {
    
    static func uploadPost(caption: String, image: UIImage, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadImage(image: image) { imageUrl in
            let data = ["caption": caption,
                        "timestamp": Timestamp(date: Date()),
                        "likes": 0,
                        "imageUrl": imageUrl,
            "ownderUid": uid] as [String : Any]
            
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
        }
    }
    
    // fetches all the posts and gives us back an array of posts
    static func fetchPosts(completion: @escaping([Post]) -> Void) { // gives us back an array of posts: [Post]
        COLLECTION_POSTS.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            
            let posts = documents.map({ Post(postId: $0.documentID, dictionary: $0.data()) }) // inside the ({ this is called a closure })
            completion(posts)
        }
    }
}
