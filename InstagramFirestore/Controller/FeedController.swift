//
//  FeedController.swift
//  InstagramFirestore
//
//  Created by Justin Viasus on 3/3/21.
//

import UIKit

private let reuseIdentifier = "Cell"

// A UI Collection View Controller!
class FeedController: UICollectionViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        collectionView.backgroundColor = .white
        
        // We need to register a cell to the collection view so that it knows what cells to create
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    
}

// MARK: - UICollectionViewDataSource

// We need to tell the collection:
// - view how many items there are going to be
// - and define the size for each item in the collection view

// UICollectionViewController already conforms to the UICollectionViewDataSource protocol, so we don't need to conform to it a second time
extension FeedController {
    // Tells the collection view how many cells to create
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    // Tells the collection view how to create each cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell // casting this as a FeedCell
        return cell
    }
}

// Mark: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    // Whatever size this returns will be the size of each collection view cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        var height = width + 8 + 40 + 8 // two 8's for the white space between the top of the screen and the profile pic, and then the profile pic and the image below. 40 for the actual size of the profile pic
        height += 50 // height of 50 for the image view
        height += 60 // for the stuff below the image (the like button, like count, username)
        
        return CGSize(width: width, height: height)
    }
}
