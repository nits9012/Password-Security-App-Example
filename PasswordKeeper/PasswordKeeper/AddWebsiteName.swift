//
//  AddWebsiteName.swift
//  PasswordKeeper
//
//  Created by Nitin Bhatt on 9/12/20.
//  Copyright © 2020 Test. All rights reserved.
//

import SwiftUI

struct AddWebsiteName: View {
    @State var websiteNameTitle = "Enter website name"
    @State var websiteNameUrl = "Enter website url"
    @State var enterUserName = "Enter username"
    @State var enterPassword = "Enter password"
    @State var isModal: Bool = false
    @State var message: String = ""

    
    @State var enterPasswordFieldValue = ""
    @State var enterNameFieldValue = ""
    @State var enterUserNameFieldValue = ""
    @State var enterWebsiteFieldValue = ""
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment (\.presentationMode) var presentationMode

    var body: some View {
        ZStack{
          Color.black.edgesIgnoringSafeArea(.all)
            VStack(spacing:10){
                VStack{
                Image("security").resizable().scaledToFit().frame(width: 80.0, height: 80.0)
                Text("ENTER ACCOUNT DETAILS").font(.system(size: 25, weight: .heavy, design: .default)).foregroundColor(Color.white)
                }.padding(.bottom,20)
                TextFieldView(value: $enterWebsiteFieldValue, placeholder: $websiteNameTitle)
                Divider()
                TextFieldView(value: $enterNameFieldValue, placeholder: $websiteNameUrl)
                Divider()
                TextFieldView(value: $enterUserNameFieldValue, placeholder: $enterUserName)
                Divider()
                SecureTextFieldView(value: $enterPasswordFieldValue, placeholder: $enterPassword)
              
                HStack{
                    Button(action:{
                        if self.enterNameFieldValue.isEmpty == true{
                            self.isModal = true
                            self.message = "Website name field can't be empty."
                        }else if self.enterWebsiteFieldValue.isEmpty == true{
                            self.isModal = true
                            self.message = "Website url can't be empty."
                        }else if self.enterUserNameFieldValue.isEmpty == true{
                            self.isModal = true
                            self.message = "Username field can't be empty."
                        }else if self.enterPasswordFieldValue.isEmpty == true{
                            self.isModal = true
                            self.message = "Password field can't be empty."
                        }else{
                            self.addWebsite(name: self.enterWebsiteFieldValue, url: self.enterNameFieldValue, username: self.enterUserNameFieldValue, password:self.enterPasswordFieldValue)
                            self.presentationMode.wrappedValue.dismiss()
                        }
                                   }) {
                                    Text("SAVE")
                                   }.font(.system(size: 20, weight: .heavy, design: .default)).frame(width: 150).padding()
                                   .foregroundColor(.white)
                                   .background(Color.red)
                                       .cornerRadius(5).alert(isPresented: $isModal) {
                                           Alert(title: Text("Message"), message: Text(self.message), dismissButton: .default(Text("Ok")))
                                       }
                    
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                                   }) {
                                       Text("CANCEL")
                                   }.font(.system(size: 20, weight: .heavy, design: .default)).frame(width: 150).padding()
                                   .foregroundColor(.white)
                                   .background(Color.red)
                                       .cornerRadius(5)
                    
                }.padding(.top,40)
            }.padding()
        }
        .modifier(AdaptsToKeyboard())

    }
    
    func addWebsite(name: String, url: String, username: String, password:String) {
        let details = WebsiteDetails(context:managedObjectContext)
        details.name = name
        details.url = url
        details.username = username
        details.password = password
        
        saveContext()
      }


      func saveContext() {
        do {
          try managedObjectContext.save()
        } catch {
          print("Error saving managed object context: \(error)")
        }
      }
}


struct TextFieldView: View {
   @Binding var value: String
   @Binding var placeholder:String

    var body: some View {
        TextField(placeholder, text: $value)
        .padding(15)
        .font(Font.system(size: 15, weight: .medium, design: .serif))
            .background(Color.white)
        
    }
}

struct AddWebsiteName_Previews: PreviewProvider {
    static var previews: some View {
        AddWebsiteName()
    }
}




