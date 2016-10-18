//
//  ViewController.swift
//  Lstn
//
//  Created by Dan Halliday on 10/13/2016.
//  Copyright (c) 2016 Dan Halliday. All rights reserved.
//

import UIKit
import Lstn

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://social.techcrunch.com/2016/10/18/finally-legislation-to-support-startups/")!

        Lstn.shared.player.load(source: url) { success in
            print("Loaded: \(success)")
            Lstn.shared.player.play { success in
                print("Playing: \(success)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
