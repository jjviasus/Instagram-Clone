//
//  NotificationService.swift
//  InstagramFirestore
//
//  Created by Justin Viasus on 6/25/21.
//

import Firebase

struct NotificationService {
    
    static func uploadNotification(toUid uid: String, type: NotificationType, post: Post? = nil) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard uid != currentUid else { return } // safe guards from a user liking their own post and sending a notification to themselves
        
        var data: [String: Any] = ["timestamp": Timestamp(date: Date()), "uid": currentUid, "type": type.rawValue]
        
        if let post = post {
            data["postId"] = post.postId
            data["postImageUrl"] = post.imageUrl
        }
        
        COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").addDocument(data: data)
    }
    
    static func fetchNotification() {
        
    }
}
