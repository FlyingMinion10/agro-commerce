//
//  agroAppApp.swift
//  agroApp
//
//  Created by Juan Felipe Zepeda on 31/08/24.
//

import SwiftUI

@main
struct agroAppApp: App {    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
