//
//  PostViewModel.swift
//  InstagramFirestore
//
//  Created by Justin Viasus on 6/15/21.
//

import Foundation

// this view model needs a post to configure itself with the right data
struct PostViewModel {
    let post: Post
    
    var imageUrl: URL? { return URL(string: post.imageUrl) }
    
    var userProfileImageUrl: URL? { return URL(string: post.ownerImageUrl) }
    
    var username: String { return post.ownerUsername }
    
    var caption: String { return post.caption }
    
    var likes: Int { return post.likes }
    
    var likesLabelText: String {
        if post.likes != 1 {
            return "\(post.likes) likes"
        } else {
            return "\(post.likes) like"
        }
    }
    
    init(post: Post) {
        self.post = post
    }
}

// the point of a view model is to take stress off of the view file, and make it so that
// the view model computes things for the view, so that the view doesn't have to do it.