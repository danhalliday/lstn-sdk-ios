//
//  LocalNotifier.swift
//  Pods
//
//  Created by Dan Halliday on 01/12/2016.
//
//

import UserNotifications

class LocalNotifier: Notifier {

    func register() {

        self.registerMorningNotification()
        self.registerLunchtimeNotification()
        self.registerEveningNotification()

    }

    private func registerMorningNotification() {

        let content = UNMutableNotificationContent()
        content.body = "Good morning! Your latest articles are ready for listening."

        var components = DateComponents()
        components.hour = 8
        components.minute = 30

        let id = "ltd.Lstn.notification.morning"

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in }

    }

    private func registerLunchtimeNotification() {

        let content = UNMutableNotificationContent()
        content.body = "Good afternoon! Your latest articles are ready for listening."

        var components = DateComponents()
        components.hour = 13
        components.minute = 00

        let id = "ltd.Lstn.notification.lunchtime"

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in }
        
    }

    private func registerEveningNotification() {

        let content = UNMutableNotificationContent()
        content.body = "Good evening! Your latest articles are ready for listening."

        var components = DateComponents()
        components.hour = 17
        components.minute = 30

        let id = "ltd.Lstn.notification.evening"

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in }

    }

}
