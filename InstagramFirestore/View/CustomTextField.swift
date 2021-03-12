//
//  CustomTextField.swift
//  InstagramFirestore
//
//  Created by Justin Viasus on 3/10/21.
//

import UIKit

class CustomTextField: UITextField {
    
    init(placeholder: String) {
        super.init(frame: .zero) // initializer for the UITextField we are inheriting from
        
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer // leftView: what is displayed on the leading (left) side of the text field
        leftViewMode = .always // determines when the leftView appears
        
        borderStyle = .none
        textColor = .white
        keyboardAppearance = .dark // dark keyboard appearance
        keyboardType = .emailAddress
        backgroundColor = UIColor(white: 1, alpha: 0.1) // makes it transparent
        setHeight(50)
        attributedPlaceholder = NSAttributedString(string: placeholder,
                                                      attributes: [.foregroundColor:
                                                                    UIColor(white: 1, alpha: 0.7)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not be implemented")
    }
}
