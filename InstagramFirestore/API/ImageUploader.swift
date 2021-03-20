//
//  ImageUploader.swift
//  InstagramFirestore
//
//  Created by Justin Viasus on 3/20/21.
//

import FirebaseStorage

// What is the completion block?
// We upload an image to firebase, and when that process completes, we execute
// this handler and it gives us back the download url that we need. So we are not
// going to get this back until the whole upload process is completed. So we can guarentee
// that it will be completed before we move onto the next step.

struct ImageUploader {
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("DEBUG: Failed to upload image \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { (url, error) in
                // the download url for our image
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
}
