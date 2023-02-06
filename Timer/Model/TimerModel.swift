//
//  TimerModel.swift
//  Timer
//
//  Created by 陈世彦 on 2/5/23.
//

import SwiftUI

class TimerModel: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    // MARK: Timer Properties
    @Published var progress: CGFloat = 1
    @Published var timerStringValue: String = "00:00"
    @Published var isStarted: Bool = false
    @Published var addNewTimer: Bool = false
    
    @Published var hour: Int = 0
    @Published var minutes: Int = 0
    @Published var seconds : Int = 0
    
    @Published var totalSeconds: Int = 0
    @Published var staticTotalSeconds: Int = 0
    
    // MARK: Post Timer Properties
    @Published var isFinished: Bool = false
    
    // Since it's NSObject
    override init() {
        super.init()
        self.authorizeNotification()
    }
    
    // MARK: Requesting Notification Access
    func authorizeNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { _, _ in
        }
        
        // MARK: To show in app notification
        UNUserNotificationCenter.current().delegate = self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }
    
    // MARK: Starting Timer
    func startTimer() {
        withAnimation(.easeInOut(duration: 0.25)) {
            isStarted = true
        }
        let hourString = "\(hour == 0 ? "" : "\(hour):")"
        let minutesString = "\(minutes >= 10 ? "\(minutes)" : "0\(minutes)"):"
        let secondsString = "\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        timerStringValue = "\(hourString)\(minutesString)\(secondsString)"
        totalSeconds = (hour * 3600) + (minutes * 60) + seconds
        staticTotalSeconds = totalSeconds
        addNewTimer = false
        addNotification()
    }
    
    // MARK: Stopping Timer
    func stopTimer() {
        withAnimation {
            isStarted = false
            hour = 0
            minutes = 0
            seconds = 0
            progress = 1
        }
        totalSeconds = 0
        staticTotalSeconds = 0
        timerStringValue = "00:00"
    }
    
    // MARK: Updating Timer
    func updateTimer() {
        totalSeconds -= 1
        progress = CGFloat(totalSeconds) / CGFloat(staticTotalSeconds)
        progress = (progress < 0 ? 0: progress)
        hour = totalSeconds / 3600
        minutes = (totalSeconds / 60) % 60
        seconds = (totalSeconds) % 60
        let hourString = "\(hour == 0 ? "" : "\(hour):")"
        let minutesString = "\(minutes >= 10 ? "\(minutes)" : "0\(minutes)"):"
        let secondsString = "\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        timerStringValue = "\(hourString)\(minutesString)\(secondsString)"
        if hour <= 0 && seconds <= 0 && minutes <= 0 {
            isStarted = false
//            print("finished")
            isFinished = true
        }
    }
    
    func addNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Timer"
        content.subtitle = "Congratulations you did it hooray 🥳🥳🥳"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(staticTotalSeconds), repeats: false))
        UNUserNotificationCenter.current().add(request)
    }
}

