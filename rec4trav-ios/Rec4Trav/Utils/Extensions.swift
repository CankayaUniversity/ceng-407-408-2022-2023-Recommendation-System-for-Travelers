//
//  Extensions.swift
//  InstagramClone
//
//  Created by Ömür Şenocak on 3.03.2023.
//

import UIKit

extension UIApplication{
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

