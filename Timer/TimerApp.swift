//
//  TimerApp.swift
//  Timer
//
//  Created by 陈世彦 on 2/5/23.
//

import SwiftUI

@main
struct TimerApp: App {
    // MARK: Since we are doing background fetching initializing here
    @StateObject var timerModel: TimerModel = .init()
    // MARK: Scene phase
    @Environment(\.scenePhase) var phase
    // MARK: Storing last time stamp
    @State var lastActiveTimeStamp: Date = Date()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timerModel)
        }
        .onChange(of: phase) { newValue in
            if timerModel.isStarted {
                if newValue == .background {
                    lastActiveTimeStamp = Date()
                }
                if newValue == .active {
                    // MARK: Find the difference
                    let currentTimeStampDiff = Date().timeIntervalSince(lastActiveTimeStamp)
                    if timerModel.totalSeconds - Int(currentTimeStampDiff) <= 0 {
                        timerModel.isStarted = false
                        timerModel.totalSeconds = 0
                        timerModel.isFinished = true
                    } else {
                        timerModel.totalSeconds -= Int(currentTimeStampDiff)
                    }
                }
            }
            
        }
    }
}
