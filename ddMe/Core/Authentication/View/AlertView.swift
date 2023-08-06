//
//  AlertView.swift
//  ddMe
//
//  Created by Rakesh Pillai on 7/15/23.
//
/*
   Description:
   Alertview that is UNUSED 7/28
   
   Last Modified:
   7/15/23
   
   Version:
   1.0
   
   Notes:
   []
*/
import SwiftUI

struct AlertView: View {
    var msg: String
    @Binding var show: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content:{
            Text("Message")
                .fontWeight(.bold)
                .foregroundColor(.gray)
            Text(msg)
                .foregroundColor(.gray)
            
            Button(action: {
                withAnimation{show.toggle()}
            }, label: {
                Text("Close")
                    .foregroundColor(.black)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 100)
                    .background(Color("BetaBlue"))
                    .cornerRadius(15)
            })
            .frame(alignment: .center)
        })
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.3).ignoresSafeArea())
    }
}

