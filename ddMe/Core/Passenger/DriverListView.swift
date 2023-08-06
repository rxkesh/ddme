//
//  DriverListView.swift
//  ddMe
//
//  Created by Rakesh Pillai on 7/25/23.
//
/*
   Description:
   Displays drivers information for passengers to choose from. Displays list of driver cards.
   
   Last Modified:
   7/25/23
   
   Version:
   1.0
   
   Notes:
   []
*/
import SwiftUI

struct DriverListView: View {
    @EnvironmentObject var driverViewModel: DriverViewModel
    var body: some View {
        ZStack {
            Color.init("Background")
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                ForEach(driverViewModel.driverList, id: \.self) { driver in
                    DriverCard(driver: driver)
                }
            }
        }
    }
}

struct DriverListView_Previews: PreviewProvider {
    static var previews: some View {
        DriverListView().environmentObject({ () -> DriverViewModel in
            let envObj = DriverViewModel()
            envObj.driverList = [Driver(id: "123", firstName: "Kobe", nickname: "mamba", phoneNumber: "123", line: []), Driver(id: "242", firstName: "lebron", nickname: "the king", phoneNumber: "123", line: [])]
            return envObj
        }() )
            
    }
}
