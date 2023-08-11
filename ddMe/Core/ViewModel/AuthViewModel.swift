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
    // MARK: - Properties
        
        /// data properties used for phone authentication, otp verification, and configuring firebase
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var verificationID: String = ""
    @Published var currentState: ViewState = ViewState.enterNumber
    @AppStorage("userPhoneNumber") public var userPhoneNumber = ""
    @AppStorage("name") public var username = ""
    @AppStorage("userID") public var userID = ""
    @AppStorage("displayPhoneNumber") public var displayPhoneNumber = ""
    static let showAlertMsg = Notification.Name("ALERT_MSG")
    private let db = Firestore.firestore()
    
    // MARK: - Initialization
        
    /// Initializes the ViewModel
    /// Fetches user to fill values for currentUser and userSession and determines viewState accordingly
    init() {
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    // FIXME: presentation logic needs help
        if currentUser != nil || userSession != nil {
            currentState = ViewState.passenger
        }
        
    }
    // MARK: - Public Methods
        
    /// Signs out the user
    ///
    /// Signs out user on firebase, resets user session so the next time app is opened,
    /// they are directed to the initial numberEntryView.
    ///
    /// - Parameters:
    ///
    /// - Returns: Void
    ///
    /// - Throws:
    ///
    /// - Note:
    func signout() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
            self.currentState = ViewState.enterNumber
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    /// Deletes user account from Firebase and clear any cache related to user.
    /// Must direct user to numberEntryView
    /// Needs to be completed!!
    ///
    /// - Parameters:
    ///
    /// - Returns: Void
    ///
    /// - Throws:
    ///
    /// - Note:
    func deleteAccount() {
    // FIXME: needs to be completed
    }
    
    /// Fetches user data from Firebase
    ///
    /// First grabs user id (if it exists), then grabs relevant user data. It should populate all viewModel properties
    /// related to the user
    ///
    /// - Parameters:
    ///
    /// - Returns: Void
    ///
    /// - Throws:
    ///
    /// - Note: async function
    func fetchUser() async {
        // FIXME: all properties (such as displayPhoneNumber, username, userID, etc.) must be populated
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        
        print("DEBUG: Current user is \(self.currentUser)")
    }
    
    /// Sends SMS verification number to user's phone
    ///
    /// Firebase uses a silent apple push notification to send a token to the device. On successful arrival of the notification,
    /// the user is sent a SMS verification code. If unsuccessful, user is directed to ReCaptcha (rarely occurrs). Also
    /// updates the currentState to direct user to OTPVerificationView
    ///
    /// - Parameters:
    ///     - phoneNumber: This number will receive the verfication code
    ///
    /// - Returns: Void
    ///
    /// - Throws:
    ///
    /// - Note: verificationID is stored in the user's app storage to access later
    func sendVerificationNumber(_ phoneNumber: String) {
        self.displayPhoneNumber = phoneNumber
        let trimmedPhNo = "+1" + phoneNumber.filter{$0.isNumber}
        
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
    
    /// Verifies the OTP sent by Firebase to the user's phone
    ///
    /// Uses the verification ID stored on the user's app storage and the password that they enter to sign in.
    /// Also updates the currentState to direct user to enterNameView
    ///
    ///
    /// - Parameters:
    ///     - password: OTP sent to user's phone from Firebase
    ///
    /// - Returns: Void
    ///
    /// - Throws:
    ///
    /// - Note:
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
    
    /// Creates a user in Firebase with a userID, firstName, and phone number.
    ///
    /// Uses the stored information from previous functions to create a user. On successful account creation,
    /// currentState is updated to direct user to the passengerView.
    ///
    /// - Parameters:
    ///     - username: Should be firstName entered by user on the nameEntryView
    ///
    /// - Returns: Void
    ///
    /// - Throws: exception if timeout occurrs
    ///
    /// - Note: Last function in user creation process. sendVerificationNumber -> verifyNumber -> createUserWithNumber. Also async.
    func createUserWithNumber(username: String) async throws {
        do {
            self.username = username
            let user = User(id: self.userID, firstName: username, phoneNumber: userPhoneNumber, emoji: "", isBrother: false)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await db.collection("users").document(user.id).setData(encodedUser)
            self.currentState = ViewState.passenger
            await fetchUser()
        } catch {
            NotificationCenter.default.post(name: AuthViewModel.showAlertMsg, object: nil)
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    /// Manually changes currentState to redirect user to different state
    ///
    /// - Parameters:
    ///     - newState: The state to send the user to (also dictates which view the user will see)
    ///
    /// - Returns: Void
    ///
    /// - Throws:
    ///
    /// - Note: Should be used carefully/sparsely, can easily lead to presentation logic errors
    func changeViewState(newState: String) {
        if (newState == "enterNumber") {
            self.currentState = ViewState.enterNumber
        }
    }
    
    /// Verifies if a user is a brother/sweetheart and updates information on Firebase accordingly
    ///
    /// Compares user-entered information to data on Firebase.
    /// Uses a completion handler since SwiftUI doesn't allow returning booleans in async functions
    /// and the Firebase call is async.
    ///
    /// - Parameters:
    ///     - firstName: First name of the user
    ///     - lastName: Last name of the user
    ///     - id: Role number (for brothers) or passcode (for sweethearts) of the user.
    ///
    /// - Returns: Bool - whether user-entered data matches official Firebase data
    ///
    /// - Throws:
    ///
    /// - Note:
    func verifyBrother(firstName: String, lastName: String, id: String, completion: @escaping (Bool) -> Void) {
        let docRef = db.collection("brothers").document(id)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let storedFirstName = document.data()?["firstName"] as? String,
                   let storedLastName = document.data()?["lastName"] as? String,
                   storedFirstName == firstName, storedLastName == lastName {
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
    
    /// Makes the current user an official brother
    ///
    /// sets the isBrother property to true and allows
    /// users to set their emoji
    ///
    /// - Parameters:
    ///
    /// - Returns: Void
    ///
    /// - Throws:
    ///
    /// - Note:
    func makeBrother() {
        
    }
    /// Displays errors in a readable/standardized format
    ///
    /// It's not really being used that much, but it still can be so that's why it's still here
    ///
    /// - Parameters:
    ///     - error: The error itself
    ///     - function: The function that the error occurred in
    ///
    /// - Returns: Void
    ///
    /// - Throws:
    ///
    /// - Note:
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
