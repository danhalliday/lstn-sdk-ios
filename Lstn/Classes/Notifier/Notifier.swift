//
//  Notifier.swift
//  Pods
//
//  Created by Dan Halliday on 01/12/2016.
//
//

import UIKit

@objc public protocol Notifier: class {

    /// Register the current notification settings with the device
    ///
    func register()

}
