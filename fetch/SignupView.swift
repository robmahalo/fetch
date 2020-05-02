//
//  SignupView.swift
//  fetch
//
//  Created by Robert Manalo on 4/20/20.
//  Copyright © 2020 rmanalo. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct Login : View {
    
    @State var user = ""
    @State var pass = ""
    @State var msg = ""
    @State var alert = false
    
    var body : some View{
        ZStack {
            Color("bg")
        
        VStack{
            
            Text("fetch").fontWeight(.regular).font(.largeTitle).padding([.top,.bottom], 20).foregroundColor(Color("bg"))
            
            VStack(alignment: .leading){
                
                VStack(alignment: .leading){
                    
                    Text("Username").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                    
                    HStack{
                        
                        TextField("Enter Your Username", text: $user).textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        if user != ""{
                            
                            Image("check").foregroundColor(Color.init(.label))
                        }
                        
                    }
                    
                    Divider()
                    
                }.padding(.bottom, 15)
                
                VStack(alignment: .leading){
                    
                    Text("Password").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                        
                    SecureField("Enter Your Password", text: $pass).textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Divider()
                }

            }.padding(.horizontal, 6)
            
            Button(action: {
                
                signInWithEmail(email: self.user, password: self.pass) { (verified, status) in
                    
                    if !verified{
                        
                        self.msg = status
                        self.alert.toggle()
                    }
                    else{
                        
                        UserDefaults.standard.set(true, forKey: "status")
                        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                    }
                }
                
            }) {
                
                Text("Sign In").foregroundColor(.white).frame(width: UIScreen.main.bounds.width - 120).padding()
                
                
            }.background(Color("bg"))
            .clipShape(Capsule())
            .padding(.top, 45)
            
            bottomView()
            
            }.padding().background(Color.white).cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)).frame(width: UIScreen.main.bounds.width)
                .padding([.top, .horizontal])
            
        .alert(isPresented: $alert) {
                
            Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
        }
        }
    }
}

struct bottomView : View{
    
    @State var show = false
    
    var body : some View{
        
        VStack{
            
            GoogleSignView().frame(width: 150, height: 55)
            
            HStack(spacing: 8){
                
                Text("New User?").foregroundColor(Color.gray.opacity(0.5))
                
                Button(action: {
                    
                    self.show.toggle()
                    
                }) {
                    
                   Text("Sign up")
                    
                }.foregroundColor(.blue)
                
            }.padding(.top, 25)
            
        }.sheet(isPresented: $show) {
            
            Signup(show: self.$show)
        }
    }
}

struct Signup : View {
    
    @State var user = ""
    @State var pass = ""
    @State var alert = false
    @State var msg = ""
    @Binding var show : Bool
    
    var body : some View{
        
        VStack{
            
            Image("img")
                
                Text("Sign Up").fontWeight(.heavy).font(.largeTitle).padding([.top,.bottom], 20)
                
                VStack(alignment: .leading){
                    
                    VStack(alignment: .leading){
                        
                        Text("Username").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                        
                        HStack{
                            
                            TextField("Enter Your Username", text: $user).textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            if user != ""{
                                
                                Image("check").foregroundColor(Color.init(.label))
                            }
                            
                        }
                        
                        Divider()
                        
                    }.padding(.bottom, 15)
                    
                    VStack(alignment: .leading){
                        
                        Text("Password").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                            
                        SecureField("Enter Your Password", text: $pass).textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Divider()
                    }

                }.padding(.horizontal, 6)
                
                Button(action: {
                    
                    signupWithEmail(email: self.user, password: self.pass) { (verified, status) in
                        
                        if !verified{
                            
                            self.msg = status
                            self.alert.toggle()
                            
                        }
                        else{
                            
                            UserDefaults.standard.set(true, forKey: "status")
                            
                            self.show.toggle()
                            
                            NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                        }
                    }
                    
                }) {
                    
                    Text("Sign Up").foregroundColor(.white).frame(width: UIScreen.main.bounds.width - 120).padding()
                    
                    
                }.background(Color("bg"))
                .clipShape(Capsule())
                .padding(.top, 45)
            
        }.padding()
        .alert(isPresented: $alert) {
                
            Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
        }
    }
}

struct Home : View {
    
    var body : some View{
        
        VStack{
            
            Text("Home")
            Button(action: {
                
                
                try! Auth.auth().signOut()
                GIDSignIn.sharedInstance()?.signOut()
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                
            }) {
                
                Text("Logout")
            }
        }
    }
}

struct GoogleSignView : UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<GoogleSignView>) -> GIDSignInButton {
        
        let button = GIDSignInButton()
        button.colorScheme = .dark
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        return button
        
    }
    
    func updateUIView(_ uiView: GIDSignInButton, context: UIViewRepresentableContext<GoogleSignView>) {
        
        
    }
}

func signInWithEmail(email: String,password : String,completion: @escaping (Bool,String)->Void){
    
    Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
        
        if err != nil{
            
            completion(false,(err?.localizedDescription)!)
            return
        }
        
        completion(true,(res?.user.email)!)
    }
}

func signupWithEmail(email: String,password : String,completion: @escaping (Bool,String)->Void){
    
    Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
    
        if err != nil{
            
            completion(false,(err?.localizedDescription)!)
            return
        }
        
        completion(true,(res?.user.email)!)
    }
}
