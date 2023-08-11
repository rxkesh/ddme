//
//  User.swift
//  ddMe
//
//  Created by Rakesh Pillai on 7/8/23.
//
/*
   Description:
   Standard model for a user. Also known as a passenger.
   
   Last Modified:
   7/8/23
   
   Version:
   1.0
   
   Notes:
   - it is a codable!!
*/
import Foundation

struct User: Identifiable, Codable {
    let id: String
    let firstName: String
    let phoneNumber: String
    let emoji: String
    let isBrother: Bool
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: firstName) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, firstName: "Kobe Bryant", phoneNumber: "1112223333", emoji: "", isBrother: false)
}
