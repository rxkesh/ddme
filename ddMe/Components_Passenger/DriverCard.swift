//
//  DriverCard.swift
//  ddMe
//
//  Created by Rakesh Pillai on 7/26/23.
//
/*
   Description:
   Card view to display drivers information for passengers to choose from
   
   Last Modified:
   7/26/23
   
   Version:
   1.0
   
   Notes:
   []
*/

import SwiftUI

struct DriverCard: View {
    let driver: Driver
    @EnvironmentObject var driverViewModel: DriverViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(driver.firstName)
                    .font(Font.custom("OpenSans-Regular", size: 25))
                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
            }
                Text(driver.nickname)
                    .font(Font.custom("OpenSans-Italic", size: 15))
                    .padding(.leading, 20)
            HStack {
                Label("10", systemImage: "clock")
                    .padding(20)
                Label("\(driver.line.count)", systemImage: "person.3")
                    .padding(20)
                Spacer()
                // Put profile picture here
            }
        }
        .background(Color("TextBlue"))
        .cornerRadius(20)
        .padding(20)
    }
}

struct DriverCard_Previews: PreviewProvider {
    static let MOCK_DRIVER = Driver(id: NSUUID().uuidString, firstName: "Kobe Bryant",nickname: "blackmamba", phoneNumber: "1112223333", line: [])
    static var previews: some View {
        
        DriverCard(driver: MOCK_DRIVER)
    }
}
