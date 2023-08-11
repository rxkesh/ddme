//
//  BrotherAuthView.swift
//  ddMe
//
//  Created by Rakesh Pillai on 7/29/23.
//

import SwiftUI
import Introspect

struct BrotherAuthView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    @State private var id = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var showEmojis = false
    
    @Binding var showNavBar: Bool
    
    var body: some View {
        ZStack {
            Color.init("Background")
                .edgesIgnoringSafeArea(.all)
            VStack {
                // image
                Image("Beta-Shield")
                    .resizable()
                    .scaledToFill()
                    .frame(width:150, height: 120)
                    .padding(.vertical, 32)
                
                // form fields
                GroupBox {
                    TextField("role number", text: $id)
                        .font(Font.custom("OpenSans-Regular", size: 15))
                        .foregroundColor(Color("InvBackground"))
                        .accentColor(Color.pink)
                        .padding()
                        .cornerRadius(10)
                        .keyboardType(.numberPad)
                        .introspect(.textField, on: .iOS(.v14, .v15, .v16, .v17)) { (textField) in
                                   let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
                                   let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textField.doneButtonTapped(button:)))
                                   doneButton.tintColor = .systemBlue
                                   toolBar.items = [flexButton, doneButton]
                                   toolBar.setItems([flexButton, doneButton], animated: true)
                                   textField.inputAccessoryView = toolBar
                                }
                    TextField("first name", text: $firstName)
                        .font(Font.custom("OpenSans-Regular", size: 15))
                        .foregroundColor(Color("InvBackground"))
                        .accentColor(Color.pink)
                        .padding()
                        .cornerRadius(10)
                    TextField("last name", text: $lastName)
                        .font(Font.custom("OpenSans-Regular", size: 15))
                        .foregroundColor(Color("InvBackground"))
                        .accentColor(Color.pink)
                        .padding()
                        .cornerRadius(10)
                } label: {
                    Label("enter your info", systemImage: "person.fill.turn.down")
                        .foregroundColor(Color("TextBlue"))
                        .font(Font.custom("OpenSans-Regular", size: 20))
                }
                .padding()
                .padding(.horizontal)
                .padding(.top, 12)
                
                Button {
                    viewModel.verifyBrother(firstName: firstName, lastName: lastName, id: id) { exists in
                            if exists {
                                viewModel.makeBrother()
                            } else {
                                print("Brother does not exist or does not match")
                            }
                        }
                } label: {
                    HStack {
                        Text("Verify")
                            .fontWeight(.semibold)
                        Image(systemName: "checkmark")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color("ButtonBlue"))
                .cornerRadius(10)
            }
        }
        .onAppear {
            showNavBar = false
        }
        .onDisappear {
            showNavBar = true
        }
    }
}

struct BrotherAuthView_Previews: PreviewProvider {
    static var previews: some View {
        let bindingBool = Binding.constant(false)
        BrotherAuthView(showNavBar: bindingBool)
    }
}
