//
//  LoginView.swift
//  fetch
//
//  Created by Robert Manalo on 4/14/20.
//  Copyright © 2020 rmanalo. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct LoginView: View {
    
    @State var user = ""
    @State var pass = ""
    @State var msg = ""
    @State var alert = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool
    ?? false
    
    var body: some View {
        
        VStack {
            if status {
                
                HomeView()
            }
            else {
                
                Login()
            }
        }.animation(.spring())
            .onAppear() {
                
                NotificationCenter.default.addObserver(forName:
                NSNotification.Name("statusChange"), object: nil, queue: .main) {
                    (_) in
                    
                    let status = UserDefaults.standard.value(forKey: "status") as? Bool
                        ?? false
                    self.status = status
                    
                }
        }
        
        }
}

struct Login: View {
    @State var user = ""
    @State var pass = ""
    @State var msg = ""
    @State var alert = false

    
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
                
                signInWithEmail(email: self.user, password: self.pass) { (verified,
                    status) in
                    
                    if !verified {
                        
                        self.msg = status
                        self.alert.toggle()
                    }
                    else {
                        UserDefaults.standard.set(true, forKey: "status")
                        NotificationCenter.default.post(name:
                            NSNotification.Name("statusChange"), object: nil)
                    }
                }
                
            }) {
                
            
            Text("Sign In").foregroundColor(.white).frame(width:
                UIScreen.main.bounds.width - 120).padding()
                    
            }.background(Color("bg"))
                .clipShape(Capsule())
                .padding(.top, 45)
            
            bottomView()

        }.padding()
        .alert(isPresented: $alert) {
            Alert(title: Text("Error"), message: Text(self.msg), dismissButton:
                .default(Text("OK")))
    }
    }
}

struct bottomView: View {
    
    @State var show = false
    
    var body: some View {
        
        VStack {
            
            GoogleSignView().frame(width: 150, height: 55)
            
            HStack (spacing: 8) {
                
                Text("Don't Have an Account ? ")
                    .foregroundColor(Color.gray.opacity(0.5))
                
                
                Button(action: {
                    
                    self.show.toggle()
                        
                    }) {
                        
                        Text("Sign Up")
                    
                }.foregroundColor(.green)
                
            }.padding(.top, 25)
            
        }.sheet(isPresented: $show) {
            
//            SignupView()
        }
        
    }
}

struct GoogleSignView: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<GoogleSignView>) -> GIDSignInButton {
        
        let button = GIDSignInButton()
        button.colorScheme = .dark
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        return button
    }
    
    func updateUIView(_ uiView: GIDSignInButton, context: UIViewRepresentableContext<GoogleSignView>) {
    
    }
}

func signInWithEmail(email: String, password: String, completion: @escaping
    (Bool, String)->Void) {
    
    Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
        
        if err != nil {
            
            completion(false,(err?.localizedDescription)!)
            return
        }
        
        completion(true,(res?.user.email)!)
        
        }
    }

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

