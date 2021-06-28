//
//  PostService.swift
//  InstagramFirestore
//
//  Created by Justin Viasus on 5/20/21.
//
import UIKit
import Firebase

struct PostService {
    
    static func uploadPost(caption: String, image: UIImage, user: User,
                           completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadImage(image: image) { imageUrl in
            let data = ["caption": caption,
                        "timestamp": Timestamp(date: Date()),
                        "likes": 0,
                        "imageUrl": imageUrl,
                        "ownderUid": uid,
                        "ownerImageUrl": user.profileImageUrl,
                        "ownerUsername": user.username] as [String : Any]
            
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
        }
    }
    
    // fetches all the posts and gives us back an array of posts
    static func fetchPosts(completion: @escaping([Post]) -> Void) { // gives us back an array of posts: [Post]
        COLLECTION_POSTS.order(by: "timestamp", descending: true).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            
            let posts = documents.map({ Post(postId: $0.documentID, dictionary: $0.data()) }) // inside the ({ this is called a closure })
            completion(posts)
        }
    }
    
    static func fetchPosts(forUser uid: String, completion: @escaping([Post]) -> Void) {
        let query = COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid)
        
        query.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            
            var posts = documents.map({ Post(postId: $0.documentID, dictionary: $0.data()) })
            
            posts.sort { (post1, post2) -> Bool in
                return post1.timestamp.seconds > post2.timestamp.seconds
            }
            
            completion(posts)
        }
    }
    
    // fetches a single post
    static func fetchPost(withPostId postId: String, completion: @escaping(Post) -> Void) {
        COLLECTION_POSTS.document(postId).getDocument { snapshot, _ in
            guard let snapshot = snapshot else { return }
            guard let data = snapshot.data() else { return }
            let post = Post(postId: snapshot.documentID, dictionary: data)
            completion(post)
        }
    }
    
    static func likePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // increments the number of post likes by 1
        COLLECTION_POSTS.document(post.postId).updateData(["likes": post.likes + 1])
        
        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(uid).setData([:]) { _ in
            // we use the completion handler here because once the previous above this one completes, we perform the process below
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).setData([:], completion: completion) // we execute the completion handler at the end to indicate to us that this likePost function has completed
        }
    }
    
    static func unlikePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return } // grab the current user id (this is the person who is unliking the post)
        guard post.likes > 0 else { return } // prevents us from having negative likes on a post
        
        // decrement the number of likes on the post
        COLLECTION_POSTS.document(post.postId).updateData(["likes": post.likes - 1])
        
        // deletes the user from the list of likes on the post
        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(uid).delete { _ in
            // deletes the post from the list of liked posts of the user
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).delete(completion: completion)
            // finally we execute the completion to indicate that we are done with the unlikePost function and can update the UI in our controller
        }
    }
    
    static func checkIfUserLikedPost(post: Post, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return } // grab the current user id

        COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).getDocument { snapshot, _ in
            // if the snapshot exists, that means the user has liked the post (didLike will be true).
            // if the snapshot does not exist, that means the user has not liked the post (didLike will be false).
            guard let didLike = snapshot?.exists else { return }
            completion(didLike)
        }
    }
}
