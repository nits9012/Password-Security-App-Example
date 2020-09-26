//
//  CustomAlertView.swift
//  PasswordKeeper
//
//  Created by Nitin Bhatt on 9/25/20.
//  Copyright © 2020 Test. All rights reserved.
//

import SwiftUI


struct CustomAlertView: View {
    @State private var text: String = ""
    
    @Binding var name:String
    @Binding var password:String
     @Binding var shown:Bool


    var body: some View {
        GeometryReader { proxy in

        ZStack{
            VStack{
                Text("SAVED DETAILS").foregroundColor(.white).font(.headline).padding([.top,.bottom], 20)

          VStack(alignment: .leading){
            HStack{
                Text("Username").foregroundColor(.white).font(.headline).padding().frame(width: 150)
                Text(self.name).foregroundColor(.white).font(.callout).padding().frame(width: 150)
            }
            
            HStack{
             Text("Password").foregroundColor(.white).font(.headline).padding().frame(width: 150)
                Text(self.password).foregroundColor(.white).font(.callout).padding().frame(width: 150)
             }
            }.frame(alignment: .leading)
                
                Button(action: {
                    self.shown.toggle()
                }) {
                    Text("CLOSE")
                }.font(.system(size: 18, weight: .heavy, design: .default)).frame(width: 150,height: 50).foregroundColor(.white).background(Color.red).cornerRadius(5).padding([.top,.bottom], 30)
            }
            
        }.frame(width: proxy.size.width - 80, height: (proxy.size.height / 2) - 150, alignment: .center).background(Color.black)
        }
    }
}
