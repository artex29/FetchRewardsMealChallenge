//
//  FetchRewardsMealChallengeApp.swift
//  FetchRewardsMealChallenge
//
//  Created by ANGEL RAMIREZ on 1/16/23.
//

import SwiftUI

@main
struct FetchRewardsMealChallengeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ContentModel())
        }
    }
}
