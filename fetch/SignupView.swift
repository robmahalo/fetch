//
//  SignupView.swift
//  fetch
//
//  Created by Robert Manalo on 4/14/20.
//  Copyright © 2020 rmanalo. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct SignupView : View {

        @State var user = ""
        @State var pass = ""
        @State var alert = false
        @State var msg = ""
        @Binding var show : Bool
    
    var body: some View {
        
        VStack {
        Image("splash")
        
        Text("Fetch").fontWeight(.ultraLight).font(.largeTitle).padding([.top,.bottom], 20)
        
        VStack (alignment: .leading) {
            
            VStack (alignment: .leading) {
                
                Text("Username").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                
                HStack {
                    
                    TextField("Enter Your Username", text: $user)
                    
                    if user != "" {
                        
                        Image("check").foregroundColor(Color.init(.label))
                        
                    }
                    
                }
                
                Divider()
                
            }.padding(.bottom, 15)
            
            
            VStack (alignment: .leading) {
                
                Text("Password").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                
                SecureField("Enter Your Password", text: $pass)
                
                Divider()
                
            }
            HStack {
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    Text("Forgot Your Password ?").foregroundColor(Color.gray.opacity(0.5))
                }
            }
        }.padding(.horizontal, 6)
        
        Button(action: {
            
            signUpWithEmail(email: self.user, password: self.pass) {
                (verified, status) in
                
                if !verified {
                    
                    self.msg = status
                    self.alert.toggle()
                }
                else {
                    
                    UserDefaults.standard.set(true, forKey: "status")
                    
                    self.show.toggle()
                    
                    NotificationCenter.default.post(name:
                        NSNotification.Name("statusChange"), object: nil)
                }
            }
            
            
        }) {
            
        
        Text("Sign Up").foregroundColor(.white).frame(width:
            UIScreen.main.bounds.width - 120).padding()
                
        }.background(Color("bg"))
            .clipShape(Capsule())
            .padding(.top, 45)
    
        }.padding()
            .alert(isPresented: $alert) {
                
                Alert(title: Text("Error"), message: Text(self.msg), dismissButton:
                    .default(Text("Ok")))
        }
    
    }
}

func signUpWithEmail(email: String, password: String, completion: @escaping
(Bool, String)->Void) {

Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
    
    
    if err != nil {
        
        completion(false,(err?.localizedDescription)!)
        return
    }
    
    completion(true,(res?.user.email)!)
    
    }
}


struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
//        SignupView(, show: )
    }
}
