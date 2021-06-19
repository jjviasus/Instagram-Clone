//
//  CommentController.swift
//  InstagramFirestore
//
//  Created by Justin Viasus on 6/18/21.
//

import UIKit

private let reuseIdentifier = "CommentCell"

class CommentController: UICollectionViewController {
    
    // MARK: - Properties
    
    // we have to make this a lazy variable because we are trying to access the view.frame.width stuff outside of a viewDidLoad or a function.
    private lazy var commentInputView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CommentInputAccessoryView(frame: frame)
        cv.delegate = self
        return cv
    }()
    
    // MARK: - Lifecycle
    
    // only called once the view is loaded in memory (once, which is when the controller is instantiated)
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    // This is declaring the commentInputView as the view's inputAccessoryView
    override var inputAccessoryView: UIView? {
        get { return commentInputView }
    }
    
    // Gives it the funcitonality of hiding and showing the keyboard, and moving it along with the keyboard
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // called every time the view is about to appear on screen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Helpers
    
    func configureCollectionView() {
        navigationItem.title = "Comments"
        
        collectionView.backgroundColor = .white
        // register our collection view cell
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // allows the user to always have the keyboard pop up and easily dismiss it
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }
}

// MARK: - UICollectionViewDataSource

extension CommentController {
    // tells our collection view how many cells to return
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    // tells our collection view what exactly it is returning (in terms of cells)
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CommentController: UICollectionViewDelegateFlowLayout {
    // set up custom size for the cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 80)
    }
}

// MARK: - CommentInputAccessoryViewDelegate

extension CommentController: CommentInputAccessoryViewDelegate {
    func inputView(_ inputView: CommentInputAccessoryView, wantsToUploadComment comment: String) {
        inputView.clearCommentTextView()
    }
}
