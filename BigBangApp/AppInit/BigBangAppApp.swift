//
//  BigBangAppApp.swift
//  BigBangApp
//
//  Created by Jose Luis Escolá García on 14/4/24.
//

import SwiftUI

@main
struct BigBangAppApp: App {
    @StateObject var vm = BigBangVM()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(vm)
        }
    }
}
