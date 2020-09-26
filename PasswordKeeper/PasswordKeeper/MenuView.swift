//
//  MenuView.swift
//  PasswordKeeper
//
//  Created by Nitin Bhatt on 9/21/20.
//  Copyright © 2020 Test. All rights reserved.
//

import SwiftUI

struct MenuView: View {
    @Environment (\.presentationMode) var presentationMode

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("home")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                Text("Home")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            .padding(.top, 100)
            HStack {
                Image("logout")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                
                Button(action: {
                    print("testing")
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                  Text("Logout")
                }.foregroundColor(.gray).font(.headline)
            }
                .padding(.top, 30)
            Spacer()
        }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 32/255, green: 32/255, blue: 32/255))
            .edgesIgnoringSafeArea(.all)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
