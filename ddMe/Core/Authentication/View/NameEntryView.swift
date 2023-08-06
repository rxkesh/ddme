//
//  NameEntryView.swift
//  ddMe
//
//  Created by Rakesh Pillai on 7/14/23.
//
/*
   Description:
   3rd view new users see. Enters their name and creates a new user in firebase with all their info
   
   Last Modified:
   7/14/23
   
   Version:
   1.0
   
   Notes:
   []
*/
import SwiftUI

struct NameEntryView: View {
    @State private var name = ""
    @State var isEditing: Bool = false
    @State var showAlert: Bool = false
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        
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
                    
                    GroupBox {
                        TextField("iluvbeta", text: $name)
                            .font(Font.custom("OpenSans-Regular", size: 30))
                            .foregroundColor(Color("InvBackground"))
                            .accentColor(Color.pink)
                            .padding()
                            .cornerRadius(10)
                            .padding()
                    } label: {
                        Label("enter your name", systemImage: "person.crop.circle")
                            .foregroundColor(Color("TextBlue"))
                            .font(Font.custom("OpenSans-Regular", size: 20))
                    }
                    .padding()
                    
                    Button {
                        Task {
                            do {
                                try await viewModel.createUserWithNumber(username: name)
                            }
                            catch {
                                print(error)
                            }
                        }
                    } label: {
                        HStack {
                            Text("Continue")
                                .fontWeight(.semibold)
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    }
                    .background(Color("ButtonBlue"))
                    .cornerRadius(10)
                }
                .padding()
                Spacer()
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

struct NameEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NameEntryView()
    }
}
