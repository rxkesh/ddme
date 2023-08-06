//
//  AuthButton.swift
//  ddMe
//
//  Created by Rakesh Pillai on 7/11/23.
//
/*
   Description:
   Basic button that looks clean and can be reused. Currently not being used LOL
   
   Last Modified:
   7/11/23
   
   Version:
   1.0
   
   Notes:
   []
*/
import SwiftUI

struct AuthButton: View {
    var text: String
    var icon: String
    var clicked: (() async throws -> Void)
    
    var body: some View {
        Button {
            Task {
                do {
                    try await clicked()
                }
                catch {
                    print(error)
                }
            }
        } label: {
            HStack {
                Text(text)
                    .fontWeight(.semibold)
                Image(systemName: icon)
            }
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width - 32, height: 48)
        }
        .background(Color("DarkBlue"))
        .cornerRadius(10)
        .padding(.top, 24)
    }
}

struct AuthButton_Previews: PreviewProvider {
    static var previews: some View {
        AuthButton(text: "sign in", icon: "arrow.right", clicked: {print("hi")})
    }
}
