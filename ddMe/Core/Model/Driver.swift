//
//  Driver.swift
//  ddMe
//
//  Created by Rakesh Pillai on 7/26/23.
//
/*
   Description:
   Standard model for a driver.
   
   Last Modified:
   7/26/23
   
   Version:
   1.0
   
   Notes:
   - not a codable, but a hashable!!!
*/
import Foundation
import Firebase

struct Driver: Identifiable, Hashable {
    let id: String
    let firstName: String
    let nickname: String
    let phoneNumber: String
    var line: [DocumentReference]
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: firstName) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
    
    mutating func updatePassengerLine(updatedLine: [DocumentReference]) {
        line = updatedLine
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (left: Driver, right: Driver) -> Bool {
        return left.id == right.id && left.phoneNumber == right.phoneNumber
    }
    
    
}

//extension Driver {
//    static var MOCK_DRIVER = Driver(id: NSUUID().uuidString, firstname: "Kobe Bryant", phoneNumber: "1112223333", line: [])
//}
