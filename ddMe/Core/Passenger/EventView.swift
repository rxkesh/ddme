//
//  EventView.swift
//  ddMe
//
//  Created by Rakesh Pillai on 7/25/23.
//
/*
   Description:
   View to highlight theme/event of the occasion
   
   Last Modified:
   7/25/23
   
   Version:
   1.0
   
   Notes:
   []
*/
import SwiftUI

struct EventView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("Beta-Shield")
                .resizable()
                .scaledToFit()
                .scaledToFit()
                .frame(width: 200, height: 200)
            Text("Hey there, ladies! 🎉")
                .font(.custom("OpenSans-Medium", size: 24))
                .foregroundColor(.pink)
                .padding(.horizontal, 20)
            
            Text("Jungle theme baby 🍻")
                .font(.custom("OpenSans-Medium", size: 18))
                .foregroundColor(Color("TextBlue"))
                .padding(.horizontal, 20)
            
            Button(action: {
                // Action when the button is clicked goes here
            }) {
                Text("Click if you're drinking already")
                    .font(.custom("OpenSans-Medium", size: 20))
                    .foregroundColor(.pink)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 40)
        }
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView()
    }
}
