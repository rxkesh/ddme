//
//  RowView.swift
//  ddMe
//
//  Created by Rakesh Pillai on 7/9/23.
//
/*
   Description:
   Basic, reusable rectangular view to hold info VIEWONLY info
   
   Last Modified:
   7/9/23
   
   Version:
   1.0
   
   Notes:
   []
*/
import SwiftUI

struct RowView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    
    var body: some View {
        HStack(spacing: 12){
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
    }
}
