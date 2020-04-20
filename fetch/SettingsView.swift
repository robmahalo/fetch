//
//  SettingsView.swift
//  fetch
//
//  Created by Robert Manalo on 4/14/20.
//  Copyright © 2020 rmanalo. All rights reserved.
//

import SwiftUI
import SwiftUI
import Firebase
import GoogleSignIn

struct SettingsView: View {
    var body: some View {
        Button(action: {

            try! Auth.auth().signOut()
            GIDSignIn.sharedInstance()?.signOut()
            UserDefaults.standard.set(false, forKey: "status")
            NotificationCenter.default.post(name:
                NSNotification.Name("statusChange"), object: nil)
        }) {

            Text("Logout")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
