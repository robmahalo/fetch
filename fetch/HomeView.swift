//
//  HomeView.swift
//  fetch
//
//  Created by Robert Manalo on 4/20/20.
//  Copyright © 2020 rmanalo. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import GoogleSignIn

struct Expense: Identifiable {
    var id = UUID()
    var name: String
    var expense: String
}

struct Balance: Identifiable {
    var id = UUID()
    var balance: String
}

struct MainView: View {
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View {
        
        VStack{
            
            if status{
                
                HomeView(pastExpenses: [], oldBalance: [])
            }
            else{
                
                Login()
            }
            
        }.animation(.spring())
        .onAppear {
                
            NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) { (_) in
                
                let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                self.status = status
            }
        }
    
    }
}

struct HomeView: View {
    
    @State var expenseName = ""
    @State var expenseAmount = ""
    @State var currentBalance = ""
    @State var expense_id = ""
    @State var balance_id = ""
    
    @State var pastExpenses :[Expense]
    @State var oldBalance: [Balance]
    @State var showSheet = false
    @State var showActionSheet = false
    
    @State var show = false
    
    var body: some View {
        // Background Card View
        VStack {
            Spacer()
            // Logo and Menu Button
            HStack(spacing: 250){
                Button(action: {
                    try! Auth.auth().signOut()
                    GIDSignIn.sharedInstance()?.signOut()
                    UserDefaults.standard.set(false, forKey: "status")
                    NotificationCenter.default.post(name:
                        NSNotification.Name("statusChange"), object: nil)
                }) {
                Image(systemName: "person.crop.circle")
                    .imageScale(.large)
                    .foregroundColor(.white)
                    
                }
                Text("fetch").font(.system(size:30,design:.default)).foregroundColor(Color.white)
            }
            
        
            // Card View Background
        VStack {
            
            // Current Balance Card View
//            VStack {
//                HStack {
//                    VStack {
//
//                        ForEach(oldBalance, id: \.id){ thisBalance in
//
//                            Button(action: {
//                                self.balance_id = thisBalance.id.uuidString
//                                self.currentBalance = thisBalance.balance
//                                self.showSheet = true
//                            }){
//                                HStack {
//                                Text("$"+"\(thisBalance.balance)")
//                                }
//                            }
//                        }
//
////                        ForEach(oldBalance, id: \.id){ thisBalance in
////
////                            Button(action: {
////                                self.balance_id = thisBalance.id.uuidString
////                                self.currentBalance = thisBalance.balance
////                                self.showSheet = true
////                            }){
////                                HStack {
////                                Text("$"+"\(thisBalance.balance)")
////                                }
////                            }
////                        }
//                        HStack {
//                            TextField("Balance ", text: $currentBalance).textFieldStyle(RoundedBorderTextFieldStyle())
//
//                            Button(action: {
//                                let amountBalance = ["balance":self.currentBalance]
//                                let docRef = Firestore.firestore().document("balance/\(UUID().uuidString)")
//                                print("Writing Data")
//                                docRef.setData(amountBalance) { (error) in
//                                    if let error = error {
//                                        print("Error = \(error)")
//                                    } else {
//                                        print("Success")
//                                        self.showSheet = false
//                                        self.currentBalance = ""
//                                    }
//                                }
//                            }) {
//                                Text("Add").padding().background(Color.init(red:0.50,green:0.90,blue:0.50))
//                                .foregroundColor(.white).cornerRadius(10)
//                            }
//                        }
//                    }
//                }
//            }
//            .layoutPriority(100)
//            .padding().background(Color.white).cornerRadius(20)
//            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.5), lineWidth: 1))
//            .padding([.top, .horizontal])
            
            
            // Add New Expense Card View
            VStack {
                HStack {
                    VStack {
                        TextField("Name", text: $expenseName).textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Price ", text: $expenseAmount).textFieldStyle(RoundedBorderTextFieldStyle())
                        
                    }
                    Button(action: {
                        let amountDict = [
                            "name":self.expenseName,
                            "expense":self.expenseAmount
                        ]
                        let docRef = Firestore.firestore().document("expenses/\(UUID().uuidString)")
                        print("Writing Data")
                        docRef.setData(amountDict) { (error) in
                            if let error = error {
                                print("Error = \(error)")
                            } else {
                                print("Success")
                                self.showSheet = false
                                self.expenseName = ""
                                self.expenseAmount = ""
                            }
                        }
                    }) {
                        Text("Add").padding().background(Color.init(red:0.50,green:0.90,blue:0.50))
                        .foregroundColor(.white).cornerRadius(10)
                    }
                    
                }
                    
            }
                .layoutPriority(100)
                .padding().background(Color.white).cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1))
                .padding([.top, .horizontal])
            
            // List of Expenses Card View
            VStack {
                List {
                if pastExpenses.count > 0 {
                    ForEach(pastExpenses, id: \.id){ thisExpense in
                        
                        Button(action: {
                            self.expense_id = thisExpense.id.uuidString
                            self.expenseName = thisExpense.name
                            self.expenseAmount = thisExpense.expense
                            self.showSheet = true
                        }){
                            HStack {
                                Text("\(thisExpense.name) -").foregroundColor(Color.gray)
                            Text("$"+"\(thisExpense.expense)").foregroundColor(Color.gray)
                            }
                        }
                            // Modify Expense View
                            .sheet(isPresented: self.$showSheet){
                            VStack {
                                Text("Edit Expense")
                                TextField("Name", text: self.$expenseName).textFieldStyle(RoundedBorderTextFieldStyle())
                                TextField("Amount ", text: self.$expenseAmount).textFieldStyle(RoundedBorderTextFieldStyle())
                                HStack {
                                Button(action: {
                                    let amountDict = ["name":self.expenseName,"expense":self.expenseAmount]
                                    let docRef = Firestore.firestore().document("expenses/\(self.expense_id)")
                                    print("Writing Data")
                                    docRef.setData(amountDict, merge: true) { (error) in
                                        if let error = error {
                                            print("Error = \(error)")
                                        } else {
                                            print("Success")
                                            self.expenseName = ""
                                            self.expenseAmount = ""
                                        }
                                    }
                                }) {
                                    Text("Update").padding().background(Color.init(red:0.90,green:0.90,blue:0.90))
                                    .foregroundColor(.gray).cornerRadius(10)
                                    
                                    }
                                
                                Button(action: {
                                    self.showActionSheet = true
                                }) {
                                    Text("Delete").padding().background(Color.init(red:1,green:0.9,blue:0.9))
                                        .foregroundColor(.red).cornerRadius(10)
                                    
                                    }.padding()
                                    .actionSheet(isPresented: self.$showActionSheet) {
                                                 ActionSheet(title: Text("Delete"),
                                                 message: Text("Are you sure you want to remove this expense?"), buttons: [
                                                    .default(Text("Ok"), action: {
                                                        Firestore.firestore().collection("expenses")
                                                        .document("\(self.expense_id)").delete() {
                                                            error in
                                                            if let error = error {
                                                                print("Removing expense: \(error)")
                                                        } else {
                                                            print("Expense Removed")
                                                                self.showSheet = false
                                                            }
                                                        }
                                                    })
                                                    ,
                                                    .cancel()
                                        ])
                                    }
                                }
                            }
                        }
                    }
                    
                } else {
                    Text("No Data Found")
                }
                }
            }.layoutPriority(100)
                .padding().background(Color.white).cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1))
                .padding([.top, .horizontal])
            
        }
        .layoutPriority(100)
        .padding().background(Color.white).cornerRadius(30)
        .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)).frame(width: UIScreen.main.bounds.width)
            .padding([.top, .horizontal]).background(Color("bg"))
        }
        .background(Color("bg"))
            
        .onAppear() {
            Firestore.firestore().collection("expenses")
                .addSnapshotListener { QuerySnapshot, error in
                    guard let documents = QuerySnapshot?.documents else {
                        print("Error \(error!)")
                        return
                    }
                    let names = documents.map { $0["name"] }
                    let expenses = documents.map { $0["expense"] }
                    self.pastExpenses.removeAll()
                    for i in 0..<names.count {
                        self.pastExpenses.append(Expense(id:UUID(uuidString:
                            documents[i].documentID) ?? UUID(),
                            name: names[i] as? String ?? "Failed",
                            expense: expenses[i] as? String ?? "Failed"))
                    }
            }
        }
        
        .onAppear() {
            Firestore.firestore().collection("balance")
                .addSnapshotListener { QuerySnapshot, error in
                    guard let documents = QuerySnapshot?.documents else {
                        print("Error \(error!)")
                        return
                    }
                    let balance = documents.map { $0["balance"] }
                    self.oldBalance.removeAll()
                    for i in 0..<balance.count {
                        self.oldBalance.append(Balance(id:UUID(uuidString:
                            documents[i].documentID) ?? UUID(),
                            balance: balance[i] as? String ?? "Failed"))
                    }
            }
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(pastExpenses:[], oldBalance: [])
//
//    }
//}

// Side Menu
