//
//  ProfileView.swift
//  SwiftUIAuthTutorial
//
//  Created by Rakesh Pillai on 7/8/23.
//
/*
   Description:
   Profile view for users to view and edit their profile and signout.
   
   Last Modified:
   7/8/23
   
   Version:
   1.0
   
   Notes:
   []
*/
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        NavigationView {
            if let user = viewModel.currentUser {
                List {
                    Section {
                        HStack {
                            Text(user.initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 72, height: 72)
                                .background(Color(.systemBlue))
                                .clipShape(Circle())
                            
                            VStack (alignment: .leading, spacing: 4) {
                                Text(user.firstName)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)
                                
                                Text(viewModel.displayPhoneNumber)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    Section {
                        HStack {
                            RowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
                            Spacer()
                            Text("1.0.0")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Section {
                        NavigationLink(destination: BrotherAuthView()) {
                            RowView(imageName: "person.fill.questionmark", title: "Are you a brother or a sweetheart?", tintColor: .green)
                        }
                        Button {
                            viewModel.signout()
                        } label: {
                            RowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                        }
                    }
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject({ () -> AuthViewModel in
            let envObj = AuthViewModel()
            envObj.currentUser = User(id: "12", firstName: "rick", phoneNumber: "7033121212")
            
            return envObj
        }() )
    }
}
