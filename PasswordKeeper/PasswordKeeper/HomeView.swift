//
//  HomeView.swift
//  PasswordKeeper
//
//  Created by Nitin Bhatt on 9/8/20.
//  Copyright © 2020 Test. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @State var showsAlert = false
    @State var showMenu = false
    @State var logout = false
    
    @State var shown = false
    @State var username = String()
    @State var password = String()


    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment (\.presentationMode) var presentationMode:  Binding<PresentationMode>
    
    @FetchRequest(
         entity: WebsiteDetails.entity(),
         sortDescriptors: [
           NSSortDescriptor(keyPath: \WebsiteDetails.name, ascending: true)
         ]
       ) var websites: FetchedResults<WebsiteDetails>

     init() {
         if #available(iOS 14.0, *) {
         } else {
             UITableView.appearance().tableFooterView = UIView()
         }

        UINavigationBar.appearance().backgroundColor = .black
       
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().tintColor = .white
      }
    

    var body: some View {
        ZStack(alignment: .leading){
         NavigationView {
                       List{
                          ForEach(websites, id: \.self) { value in
                            HStack{
                                
                                Image("website").resizable()
                                .scaledToFit()
                                .frame(width: 60.0, height: 60.0)
                                VStack(alignment: .leading){
                                    Text(value.name!.capitalized).foregroundColor(.black).font(.headline)
                                    Text(value.url!.capitalized).foregroundColor(.black).font(.callout)
                                }
                            }.padding().onTapGesture {
                                self.shown.toggle()
                                self.username = value.username!
                                self.password = value.password!
                            }
                        }
                       }
            .navigationBarItems(leading: (
                        Button(action: {
                            self.showsAlert = true
                        }) {
                            Text("Add").foregroundColor(Color.white)
                      }
            ),trailing:
                    Button(action: {
                        self.logout = true
                        UserDefaults.standard.set(false, forKey: "isLogin")
                    }){
                       Text("Logout").foregroundColor(Color.white)
                    }.sheet(isPresented:$logout , content: {
                          LoginView().environment(\.managedObjectContext, self.managedObjectContext)
                    }) ).background(
                        NavigationLink(destination:  AddWebsiteName().environment(\.managedObjectContext, self.managedObjectContext), isActive: $showsAlert) {
                                 EmptyView()
                        }.navigationBarTitle(Text("Home")).navigationBarBackButtonHidden(true)
            )}.blur(radius: shown ? 20 : 0)
        if self.shown{
            CustomAlertView(name: self.$username, password: self.$password, shown: self.$shown)
        }}.animation(.spring())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


