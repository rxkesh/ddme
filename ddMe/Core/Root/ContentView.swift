//
//  ContentView.swift
//  ddMe
//
//  Created by Rakesh Pillai on 7/1/23.
//
/*
   Description:
   Main view for authentication and first-time users
   
   Last Modified:
   7/20/23
   
   Version:
   1.0
   
   Notes:
   []
*/
import ActionButton
import Combine
import iPhoneNumberField
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            switch viewModel.currentState {
            case .enterNumber:
                NumberEntryView()
                
            case .verifyNumber:
                OTPVerificationView()
                
            case .enterName:
                NameEntryView()
                
            case .passenger:
                PassengerView()
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}

