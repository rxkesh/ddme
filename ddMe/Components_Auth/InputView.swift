//
//  InputView.swift
//  ddMe
//
//  Created by Rakesh Pillai on 7/9/23.
//

import SwiftUI
/*
   Description:
   Textfield that can be used for entering info, also not being used LOL
   
   Last Modified:
   7/9/23
   
   Version:
   1.0
   
   Notes:
   []
*/
struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(Font.custom("OpenSans-Regular", size: 14))
                    .foregroundColor(Color("TextBlue"))

            } else {
                TextField(placeholder, text: $text)
                    .font(Font.custom("OpenSans-Regular", size: 14))
                    .foregroundColor(Color("TextBlue"))

            }
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com")
    }
}
