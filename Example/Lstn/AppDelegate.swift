
//  AppDelegate.swift
//  Lstn
//
//  Created by Dan Halliday on 10/13/2016.
//  Copyright (c) 2016 Lstn Ltd. All rights reserved.
//

import UIKit
import UserNotifications
import Lstn

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func applicationDidFinishLaunching(_ application: UIApplication) {

        let options: UNAuthorizationOptions = [.alert, .sound, .badge]

        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            Lstn.shared.notifier.register()
        }

    }

}
