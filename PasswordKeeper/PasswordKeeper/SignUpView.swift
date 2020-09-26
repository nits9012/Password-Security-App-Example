//
//  SignUpView.swift
//  PasswordKeeper
//
//  Created by Nitin Bhatt on 9/19/20.
//  Copyright © 2020 Test. All rights reserved.
//

import SwiftUI

import Combine

struct AdaptsToKeyboard: ViewModifier {
    @State var currentHeight: CGFloat = 0

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.bottom, self.currentHeight)
                .animation(.easeOut(duration: 0.16))
                .onAppear(perform: {
                    NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
                        .merge(with: NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillChangeFrameNotification))
                        .compactMap { notification in
                            notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect
                    }
                    .map { rect in
                        rect.height - geometry.safeAreaInsets.bottom
                    }
                    .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))

                    NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)
                        .compactMap { notification in
                            CGFloat.zero
                    }
                    .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
                })
        }
    }
}

struct SignUpView: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @State var password: String = ""
    @State var enterPasswordPlaceHolder = "Enter your password"
    @State var confirmPassword: String = ""
    @State var enterConfirmPasswordPlaceHolder = "Confirm password"
    @State var isModal: Bool = false

    @State var message: String = ""
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @FetchRequest(
        entity: User.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \User.id, ascending: true),
        ]
    ) var user: FetchedResults<User>
    
    @FetchRequest(
          entity: WebsiteDetails.entity(),
          sortDescriptors: [
            NSSortDescriptor(keyPath: \WebsiteDetails.name, ascending: true)
          ]
        ) var websites: FetchedResults<WebsiteDetails>

    var body: some View {
      ZStack{
        Color.black.edgesIgnoringSafeArea(.all)
         VStack(spacing: 40){
            Image("Password")
                           .resizable()
                               .scaledToFit()
                               .frame(width: 100.0, height: 100.0)
            Text("SAVE LOGIN PASSWORD").font(.system(size: 30, weight: .heavy, design: .default)).foregroundColor(Color.white).multilineTextAlignment(.center)

           SecureTextFieldView(value: $password, placeholder: $enterPasswordPlaceHolder)
           SecureTextFieldView(value: $confirmPassword, placeholder: $enterConfirmPasswordPlaceHolder)
            Button(action: {
                if self.password.isEmpty == true{
                     self.isModal = true
                    self.message = "Please enter password"
                }else if self.confirmPassword.isEmpty == true{
                     self.isModal = true
                     self.message = "Please enter confirm password"
                }else if self.password != self.confirmPassword{
                     self.isModal = true
                    self.message = "Confirm password doesn't match."
                }else{
                    self.deleteAllUsersAndWebsiteDetails()
                    self.addUser(password:self.password)
                    self.isModal = true
                    self.message = "User sign up successfully."
                }
            }){
                Text("SAVE")
            }.font(.system(size: 20, weight: .heavy, design: .default)).frame(width: 150).padding().foregroundColor(.white).background(Color.red).cornerRadius(5).alert(isPresented: $isModal) {
                Alert(title: Text("Message"), message: Text(self.message), dismissButton: .default(Text("Ok")))
              }
         }.padding()
    }
        
        .modifier(AdaptsToKeyboard())
    }
    
    func deleteAllUsersAndWebsiteDetails(){
        for index in 0..<user.count {
            managedObjectContext.delete(user[index])
        }
        
        for index in 0..<websites.count{
            managedObjectContext.delete(websites[index])
        }
        
        self.saveContext()
    }
    
    func addUser(password:String) {
        let user = User(context:managedObjectContext)
        user.id = 1
        user.password = password
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

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
