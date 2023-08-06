//
//  DriverViewModel.swift
//  ddMe
//
//  Created by Rakesh Pillai on 7/26/23.
//
/*
   Description:
   View Model for the driver information. Handles communication between Firebase and passenger views.
   
   Last Modified:
   7/26/23
   
   Version:
   1.0
   
   Notes:
   []
*/
import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

@MainActor
class DriverViewModel: ObservableObject {
    @Published var driverList: [Driver]
    
    private let db = Firestore.firestore()
    
    init() {
        driverList = [Driver]()
        self.startDriverListener()
    }
    
    func fetchDrivers() {
        db.collection("drivers").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let documentData = document.data()
                    let driver = Driver(id: documentData["id"] as! String, firstName: documentData["firstName"] as! String, nickname: documentData["nickname"] as! String, phoneNumber: documentData["phoneNumber"] as! String, line: documentData["line"] as! Array)
                    self.driverList.append(driver)
                }
            }
        }
    }
    
    /**
     startDriverListener
     
     Description:
     Starts a snapshot listener on the driver collection in firestore. Any changes made to the collection will update driverList and show in the related views
     
     Parameters:
     
     Returns:
     Void
     
     Throws:
     None
     
     Example:
     [An example of how to call and use the function. This can help other developers understand how the function works in practice.]
     
     - Important:
     [Any critical or noteworthy information that developers must be aware of before using this function.]
     
     - Warning:
     [Any potential issues, pitfalls, or limitations related to this function.]
    
     */
    func startDriverListener() {
        db.collection("drivers")
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        let documentData = diff.document.data()
                        let passengerLine = documentData["line"] ?? [DocumentReference]()
                        let driver = Driver(id: documentData["id"] as! String, firstName: documentData["firstName"] as! String, nickname: documentData["nickname"] as! String, phoneNumber: documentData["phoneNumber"] as! String, line: passengerLine as! [DocumentReference])
                        self.driverList.append(driver)
                    }
                    if (diff.type == .modified) {
                        let documentData = diff.document.data()
                        let passengerLine = documentData["line"] ?? [DocumentReference]()
                        print(passengerLine)
                        if let index = self.driverList.firstIndex(where: {$0.id == documentData["id"] as! String}) {
                            self.driverList[index].updatePassengerLine(updatedLine: passengerLine as! [DocumentReference])
                            print(self.driverList)
                        }
                    }
                    if (diff.type == .removed) {
                        let idToRemove = diff.document.documentID
                        if let index = self.driverList.firstIndex(where: { $0.id == idToRemove }) {
                            self.driverList.remove(at: index)
                        }
                    }
                }
                
            }
    }
    
    private func detachDriverListener() {
        // [START detach_listener]
        let listener = db.collection("drivers").addSnapshotListener { querySnapshot, error in
            // [START_EXCLUDE]
            // [END_EXCLUDE]
        }
        
        // ...
        
        // Stop listening to changes
        listener.remove()
        // [END detach_listener]
    }
}

