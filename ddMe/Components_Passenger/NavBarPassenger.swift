//
//  NavBar.swift
//  ddMe
//
//  Created by Federico on 5/1/2022.
//
/*
   Description:
   Navigation bar specially designed for passengers and their view
   
   Last Modified:
   7/18/23
   
   Version:
   1.0
   
   Notes:
   Not mine at all, taken from a YouTuber's github, shoutout <3
*/

import SwiftUI

enum Tab: String, CaseIterable {
    case house
    case cars
    case person
    var systemImageName: String {
        switch self {
        case .house:
            return "house.fill"
        case .cars:
            return "car.2.fill"
        case .person:
            return "person.crop.circle.dashed"
        }
    }
}

struct NavBarPassenger: View {
    @Binding var selectedTab: Tab
    
    private var tabColor: Color {
        switch selectedTab {
        case .house:
            return .black
        case .cars:
            return .black
        case .person:
            return .black
        }
    }
    
    
    var body: some View {
        VStack {
            HStack {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    Image(systemName: tab.systemImageName)
                        .scaleEffect(tab == selectedTab ? 1.35 : 1.0)
                        .foregroundColor(tab == selectedTab ? tabColor : .gray)
                        .font(.system(size: 25))
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                selectedTab = tab
                            }
                        }
                    Spacer()
                }
            }
            .frame(width: nil, height: 60)
            .cornerRadius(20)
            .padding()
            .background(Color("TextBlue"))
            .clipShape(Capsule())
            .padding(35)
        }
    }
}

struct NavBarPassenger_Previews: PreviewProvider {
    static var previews: some View {
        NavBarPassenger(selectedTab: .constant(.house))
    }
}
