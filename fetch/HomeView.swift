//
//  HomeView.swift
//  fetch
//
//  Created by Robert Manalo on 4/14/20.
//  Copyright © 2020 rmanalo. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct HomeView: View {
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            HStack(spacing: 15) {
                
                Button(action: {
                    
                }) {
//                    Image("menu").renderingMode(.original)
                    Text("Menu")
                }
                
                Spacer()
                
                Text("fetch").foregroundColor(Color("bg"))
            }.padding(.top, 18)
            
            
            
            HStack (spacing: 15) {
                
                Text("Overview").foregroundColor(Color.black.opacity(0.5))
                
                Spacer()
                
            }
            
            HStack {
                VStack (alignment: .leading, spacing: 15) {
                    
                    Text("$100").font(.title)
                    
                    Text("Current Balance")
                    
                }
                
                    
                    Spacer()
                    
                    Button(action: {
                                        
                    }) {
                    //Image("menu").renderingMode(.original)
                        Text("Add")
                    }

                    
                    Button(action: {
                                        
                    }) {
                    //Image("menu").renderingMode(.original)
                        Text("Minus")
                    }
                
            }
            .padding(20)
            .background(Color("bg"))
            .cornerRadius(20)
            
            HStack (spacing: 15) {
                
                Text("My Budgets").foregroundColor(Color.black.opacity(0.5))
                               
                Spacer()
                
            }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack (spacing: 15) {
                    
                    Button(action: {
                        
                    }) {
                        
                        Image("add").renderingMode(.original)
                        
                }
                
//                    ForEach(names, id: \.self) {i in
//                        VStack(spacing: 10) {
//
//                            Image("pencil")
//
//                            Text(i).foregroundColor(Color.black.opacity(0.5))
//
//                        }.padding()
//                            .background(Color.black.opacity(0.05))
//                        .cornerRadius(10)
//                    }
                    
                }
                
            }.padding(.top, 18)
            
            
            Spacer()
            
            
        }.padding([.horizontal,.top])
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
