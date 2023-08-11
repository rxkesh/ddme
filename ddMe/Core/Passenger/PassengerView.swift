//
//  DriverListView.swift
//  ddMe
//
//  Created by Rakesh Pillai on 7/24/23.
//
/*
   Description:
   Homepage of sorts. Handles the view to choose from based on tab selected. 
   
   Last Modified:
   7/24/23
   
   Version:
   1.0
   
   Notes:
   []
*/
import SwiftUI

struct PassengerView: View {
    @EnvironmentObject var driverViewModel: DriverViewModel
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var tabSelected: Tab = .house
    @State private var showNavBar: Bool = true
    
    var body: some View {
        ZStack {
            VStack {
                TabView(selection: $tabSelected) {
                    switch tabSelected {
                    case .house:
                        EventView()
                    case .cars:
                        DriverListView()
                    case .person:
                        ProfileView(showNavBar: $showNavBar)
                    }
                }
            }
            VStack {
                Spacer()
                NavBarPassenger(selectedTab: $tabSelected)
                    .opacity(showNavBar ? 1 : 0)
            }
        }
    }
}

struct PassengerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PassengerView().environmentObject({ () -> AuthViewModel in
                let envObj = AuthViewModel()
                envObj.currentUser = User(id: "12", firstName: "rick", phoneNumber: "7033121212", emoji: "", isBrother: false)
                return envObj
            }() )
            
            PassengerView().environmentObject({ () -> DriverViewModel in
                let envObj = DriverViewModel()
                envObj.driverList = [Driver(id: "123", firstName: "Kobe", nickname: "mamba", phoneNumber: "123", line: []), Driver(id: "242", firstName: "lebron", nickname: "the king", phoneNumber: "123", line: [])]
                return envObj
            }() )
        }
    } 
}
