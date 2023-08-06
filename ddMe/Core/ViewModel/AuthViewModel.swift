//
//  AuthViewModel.swift
//  SwiftUIAuthTutorial
//
//  Created by Rakesh Pillai on 7/8/23.
//
/*
   Description:
   View Model used for authentication. Communicates with Firebase. Has viewstates to handle auth presentation logic.
   
   Last Modified:
   7/8/23
   
   Version:
   1.0
   
   Notes:
   - will need to clean up in the future
*/
import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth

import SwiftUI

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

enum ViewState {
    case enterNumber, verifyNumber, enterName, passenger
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    // used for phone auth
    @Published var verificationID: String = ""
    @Published var currentState: ViewState = ViewState.enterNumber
    @AppStorage("userPhoneNumber") public var userPhoneNumber = ""
    @AppStorage("name") public var username = ""
    @AppStorage("userID") public var userID = ""
    // used specifically for otp display
    @AppStorage("displayPhoneNumber") public var displayPhoneNumber = ""
    // used for showing alerts
    static let showAlertMsg = Notification.Name("ALERT_MSG")
    // database access
    private let db = Firestore.firestore()
    
        
    init() {
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
        
        if currentUser != nil || userSession != nil {
            currentState = ViewState.passenger
        }
        
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do  {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
        }
    }
    
    func createUserEmail(withEmail email: String, password: String, name: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, firstName: name, phoneNumber: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signout() {
        do {
            try Auth.auth().signOut() // sign out user on firebase
            self.userSession = nil // reset user session so next time they open app, its loginview
            self.currentUser = nil // keeps data fresh when new user logs in
            self.currentState = ViewState.enterNumber
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() {
        
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // optional: add error handling here
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        
        print("DEBUG: Current user is \(self.currentUser)")
    }
    
    // sends a 6-digit number to user
    func sendVerificationNumber(_ phoneNumber: String) {
        self.displayPhoneNumber = phoneNumber
        let trimmedPhNo = "+1" + phoneNumber.filter{$0.isNumber}
        // DISABLE WITH REAL PHONES
        
        
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(trimmedPhNo, uiDelegate: nil) { (verificationID, error) in
                if let error = error {
                    self.displayError(error)
                    NotificationCenter.default.post(name: AuthViewModel.showAlertMsg, object: nil)
                    return
                }
                guard let verificationID = verificationID else {
                            // Handle error: Unable to retrieve verification ID
                        print("Unable to retrieve verification ID")
                            return
                        }
                self.verificationID = verificationID
                self.userPhoneNumber = trimmedPhNo
                self.currentState = ViewState.verifyNumber
            }
        print(self.verificationID)
    }
    
    func verifyNumber(password: String) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationID, verificationCode: password)
        
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                self.displayError(error)
                NotificationCenter.default.post(name: AuthViewModel.showAlertMsg, object: nil)
                return
            }
            self.userSession = result?.user
            self.userID = result?.user.uid ?? ""
            self.currentState = ViewState.enterName
            print(self.userID)
        }
    }
    
    func createUserWithNumber(username: String) async throws {
        do {
            self.username = username
            let user = User(id: self.userID, firstName: username, phoneNumber: userPhoneNumber)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await db.collection("users").document(user.id).setData(encodedUser)
            self.currentState = ViewState.passenger
            await fetchUser()
        } catch {
            NotificationCenter.default.post(name: AuthViewModel.showAlertMsg, object: nil)
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func changeViewState(newState: String) {
        if (newState == "enterNumber") {
            self.currentState = ViewState.enterNumber
        }
        
    }
    
    public func displayError(_ error: Error?, from function: StaticString = #function) {
        guard let error = error else { return }
        print("🚨 Error in \(function): \(error.localizedDescription)")
        let message = "\(error.localizedDescription)\n\n Ocurred in \(function)"
        let errorAlertController = UIAlertController(
          title: "Error",
          message: message,
          preferredStyle: .alert
        )
        errorAlertController.addAction(UIAlertAction(title: "OK", style: .default))
      }
}
