//
//  AnonLoginView.swift
//  ddMe
//
//  Created by Rakesh Pillai on 7/9/23.
//
/*
   Description:
   First view that new users see. Very important. Handles alerts. UIApplication extension used to handle dismiss keyboard. I also create and use a "done" button on top of the keypad.
   
   Last Modified:
   7/9/23
   
   Version:
   1.0
   
   Notes:
   - Uses Introspect package and iPhoneNumberField
   - Needs work on color scheme/UI as of 7/28
*/
import SwiftUI
import iPhoneNumberField
import SwiftUIIntrospect

struct NumberEntryView: View {
    @State private var name = ""
    @State private var phoneNumber = ""
    @State private var showAlert = false
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.init("Background")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    // title and image
                    VStack (spacing: 25) {
                        HStack {
                            Text("DDme")
                                .font(Font.custom("OpenSans-Italic", size: 50))
                                .foregroundColor(Color("TextBlue"))
                            Image(systemName: "car.2")
                                .font(.system(size: 50))
                                .foregroundColor(Color("TextBlue"))
                        }
                        Image("Beta-Shield")
                            .resizable()
                            .scaledToFit()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        Spacer()
                        // iphone box field
                        GroupBox {
                            iPhoneNumberField("703-iluv-beta", text: $phoneNumber)
                                .font(UIFont(size: 30, weight: .light, design: .monospaced))
                                .maximumDigits(10)
                                .clearButtonMode(.whileEditing)
                                .foregroundColor(Color("InvBackground"))
                                .cornerRadius(10)
                                .introspect(.textField, on: .iOS(.v14, .v15, .v16, .v17)) { (textField) in
                                           let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
                                           let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                                    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textField.doneButtonTapped(button:)))
                                           doneButton.tintColor = .systemBlue
                                           toolBar.items = [flexButton, doneButton]
                                           toolBar.setItems([flexButton, doneButton], animated: true)
                                           textField.inputAccessoryView = toolBar
                                        }
                                .accentColor(Color.white)
                                .padding()
                        } label: {
                            Label("enter your number", systemImage: "phone.fill")
                                .foregroundColor(Color("TextBlue"))
                                .font(Font.custom("OpenSans-Regular", size: 20))
                        }
                        .padding()
                        
                        Button{
                            viewModel.sendVerificationNumber(phoneNumber)
                        } label: {
                            HStack {
                                Text("continue")
                                    .fontWeight(.semibold)
                                Image(systemName: "arrow.right")
                            }
                            .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                        }
                        .background(Color("ButtonBlue"))
                        .cornerRadius(10)
                        .padding(.top, 24)
                        .disableWithOpacity(condition: phoneNumber.count != 14)
                    }
                    .padding()
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Something went wrong"), message: Text("Try again in a sec🐉"), dismissButton: .default(Text("Got it!")))
        }
        .onReceive(NotificationCenter.default.publisher(for: AuthViewModel.showAlertMsg)) { msg in
            self.showAlert = true // simply change the state of the View
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct NumberEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NumberEntryView()
    }
}

