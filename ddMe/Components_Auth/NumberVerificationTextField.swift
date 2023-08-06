//
//  CustomTextField.swift
//  ddMe
//
//  Created by Rakesh Pillai on 7/13/23.
//
/*
   Description:
   Used for entering the OTP text code that users will receive when signing up. Only being used on verification view as of 7/28
   
   Last Modified:
   7/13/23
   
   Version:
   1.0
   
   Notes:
   First responder is what makes sure the numpad shows up immediately and is the only item for users to interact with on the view
*/

import Foundation
import SwiftUI

struct NumberVerificationTextField: UIViewRepresentable {
    @Binding var text: String
    let isFirstResponder: Bool

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.delegate = context.coordinator
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        if isFirstResponder {
            uiView.becomeFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let allowedCharacterSet = CharacterSet(charactersIn: "0123456789")
            let replacementStringCharacterSet = CharacterSet(charactersIn: string)
            return allowedCharacterSet.isSuperset(of: replacementStringCharacterSet)
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.text = textField.text ?? ""
            }
        }
    }
}
