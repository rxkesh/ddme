//
//  OTPVerificationView.swift
//  ddMe
//
//  Created by Rakesh Pillai on 7/13/23.
//
/*
   Description:
   Second view new users are greeted with. Used to verify SMS code sent from Firebase
 
   Last Modified:
   7/13/23
   
   Version:
   1.0
   
   Notes:
   []
*/
import SwiftUI

struct OTPVerificationView: View {
    @State var otpText: String = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State var countDownTimer = 60
    @State var timerRunning = true
    @State private var showAlert = false
    let timer = Timer.publish(every:1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.init("Background")
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Text("Verify")
                        .font(Font.custom("OpenSans-Regular", size: 30))
                        .frame(alignment: .leading)
                        .foregroundColor(Color("TextGray"))
                    Text(" \(viewModel.displayPhoneNumber)")
                        .font(Font.custom("OpenSans-Regular", size: 30))
                        .foregroundColor(Color("TextBlue"))
                }
                Text("Wrong number?")
                    .font(Font.custom("OpenSans-Bold", size: 12))
                    .frame(alignment: .leading)
                    .foregroundColor(Color("TextBlue"))
                    .onTapGesture {
                        viewModel.changeViewState(newState: "enterNumber")
                    }
                ZStack {
                    HStack(spacing:20) {
                        ForEach(0..<6, id: \.self) {index in
                            OTPTextBox(index)
                        }
                    }
                    .padding(.bottom, 2)
                    .padding(.top, 10)
                    
                    NumberVerificationTextField(text: $otpText.limit(6), isFirstResponder: true)
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .frame(width: 1, height: 1)
                        .opacity(0.001)
                }
                Button {
                    viewModel.verifyNumber(password: otpText)
                } label: {
                    HStack {
                        Text("")
                            .fontWeight(.semibold)
                        Image(systemName: "checkmark.circle")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color("ButtonBlue"))
                .cornerRadius(10)
                .padding(.top, 24)
                .disableWithOpacity(condition: otpText.count < 6)
                Spacer()
                HStack {
                    Text("\(countDownTimer)")
                        .onReceive(timer) { _ in
                            if countDownTimer > 0 && timerRunning {
                                countDownTimer -= 1
                            } else {
                                timerRunning = false
                            }
                        }
                        .font(Font.custom("OpenSans-Regular", size: 18))
                        .foregroundColor(Color("TextBlue"))
                    Text("resend SMS code?")
                        .font(Font.custom("OpenSans-Bold", size: 18))
                        .foregroundColor(Color("TextBlue"))
                        .onTapGesture {
                            viewModel.sendVerificationNumber(viewModel.userPhoneNumber)
                            countDownTimer = 60
                            timerRunning = true
                        }
                }
            }
            .padding(.all)
            .frame(maxHeight: .infinity, alignment: .top)
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Wrong ID"), message: Text("Try again🐉"), dismissButton: .default(Text("Got it!")))
        }
        .onReceive(NotificationCenter.default.publisher(for: AuthViewModel.showAlertMsg)) { msg in
            self.showAlert = true // simply change the state of the View
        }
    }
    
    @ViewBuilder
    func OTPTextBox(_ index: Int) -> some View {
        ZStack {
            if otpText.count > index {
                let startIndex = otpText.startIndex
                let charIndex = otpText.index(startIndex, offsetBy: index)
                let charToString = String(otpText[charIndex])
                Text(charToString)
            } else {
                Text(" ")
            }
        }
        .padding()
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color("TextBlue"), lineWidth: 5)
        )
    }
}

struct OTPVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        OTPVerificationView()
            .environmentObject(AuthViewModel())
    }
}


extension View {
    func disableWithOpacity( condition: Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.6: 1)
    }
}

//extension that limits length of string, in this case, the code is 6 digits
extension Binding where Value == String {
    func limit(_ length: Int) -> Self {
        if self.wrappedValue.count > length {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(length))
            }
        }
        return self
    }
}
