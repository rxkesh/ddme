//
//  UITextFieldExtension.swift
//  ddMe
//
//  Created by Rakesh Pillai on 7/20/23.
//

import Foundation
import SwiftUI
/*
   Description:
   Used specifically for the done button on the number verification view
   
   Last Modified:
   7/20/23
   
   Version:
   1.0
   
   Notes:
   []
*/
extension  UITextField {
   @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
      self.resignFirstResponder()
   }
}
