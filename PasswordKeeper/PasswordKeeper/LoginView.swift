//
//  LoginView.swift
//  PasswordKeeper
//
//  Created by Nitin Bhatt on 8/23/20.
//  Copyright © 2020 Test. All rights reserved.
//

import SwiftUI

final class KeyboardResponder: ObservableObject {
    private var notificationCenter: NotificationCenter
    @Published private(set) var currentHeight: CGFloat = 0

    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height
        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        currentHeight = 0
    }
}




struct LoginView: View {

    @State var password: String = ""
    @State var enterPasswordPlaceHolder = "Enter your password"

    @State var isModal: Bool = false
    @State var isSignUpModal: Bool = false
    @State var showAlert: Bool = false
    @State var message: String = ""
    
    @ObservedObject private var keyboard = KeyboardResponder()
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
      entity: User.entity(),
      sortDescriptors: [
      NSSortDescriptor(keyPath: \User.password, ascending: true)
      ]
    ) var user: FetchedResults<User>


    var body: some View {
        NavigationView {
        ZStack{
             Color.black.edgesIgnoringSafeArea(.all)

            VStack(spacing: 40){
                Image("lock")
                               .resizable()
                                   .scaledToFit()
                                   .frame(width: 150.0, height: 150.0)
                
                Text("WELCOME BACK").font(.system(size: 40, weight: .heavy, design: .default)).foregroundColor(Color.white)

                SecureTextFieldView(value: self.$password, placeholder: self.$enterPasswordPlaceHolder)
                
                HStack{
                    Button(action: {
                        
                        if self.password.isEmpty == true {
                           self.showAlert = true
                           self.message = "Please enter password to login."
                           return
                        }
                        
                        if self.user.count == 0{
                            self.showAlert = true
                            self.message = "User not found"
                            return
                        }
                        
                        for _ in 0..<self.user.count{
                            if let value = self.user[0].password{
                                if self.password == value{
                                    UserDefaults.standard.set(true, forKey: "isLogin")
                                    self.isModal = true
                                }else{
                                    self.showAlert = true
                                    self.message = "Invalid password"
                                }
                            }
                        }
                    }) {
                        Text("LOGIN")
                    }.font(.system(size: 20, weight: .heavy, design: .default)).frame(width: 150).padding().foregroundColor(.white).background(Color.red).cornerRadius(5).sheet(isPresented: self.$isModal, content: {
                        HomeView().environment(\.managedObjectContext, self.managedObjectContext)
                    }).alert(isPresented: self.$showAlert) {
                      Alert(title: Text("Error"), message: Text(self.message), dismissButton: .default(Text("Ok")))
                    }
                    
                    Button(action:{
                        self.isSignUpModal = true
                    }) {
                                       Text("SIGN UP")
                    }.font(.system(size: 20, weight: .heavy, design: .default)).frame(width: 150).padding().foregroundColor(.white).background(Color.red).cornerRadius(5)
                } .navigationBarTitle("").background(
                    NavigationLink(destination:  SignUpView().environment(\.managedObjectContext, self.managedObjectContext), isActive: self.$isSignUpModal) {
                            EmptyView()
                    }.navigationBarTitle("")
                )
            }.padding()
        }
            .modifier(AdaptsToKeyboard())
    }.accentColor( .white)
    }

}

struct SecureTextFieldView: View {
    @Binding var value: String
    @Binding var placeholder:String

    var body: some View {
        
        SecureField(placeholder, text: $value)
        .padding(15)
        .font(Font.system(size: 15, weight: .medium, design: .serif))
            .background(Color.white)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        
        LoginView()
    }
}


