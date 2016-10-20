//
//  PlayerView.swift
//  Lstn
//
//  Created by Dan Halliday on 19/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Lstn

class PlayerView: UIView {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var positionProgressView: UIProgressView!
    @IBOutlet weak var errorLabel: UILabel!

    override func awakeFromNib() {

        super.awakeFromNib()

        Lstn.shared.player.delegate = self

        self.playButton.isEnabled = false
        self.playButton.isHidden = false

        self.pauseButton.isEnabled = false
        self.pauseButton.isHidden = true

        self.loadingIndicatorView.isHidden = true
        self.loadingIndicatorView.hidesWhenStopped = true

        self.positionProgressView.progress = 0
        self.errorLabel.isHidden = true

    }

}

// MARK: - Actions

extension PlayerView {

    @IBAction func playButtonWasTapped() {
        Lstn.shared.player.play()
    }

    @IBAction func pauseButtonWasTapped() {
        Lstn.shared.player.stop()
    }
    
}

// MARK: - Player Delegate

extension PlayerView: PlayerDelegate {

    func loadingDidStart() {

        self.loadingIndicatorView.startAnimating()
        self.errorLabel.isHidden = true

    }

    func loadingDidFinish() {

        self.playButton.isEnabled = true
        self.pauseButton.isEnabled = true
        self.loadingIndicatorView.stopAnimating()

    }

    func loadingDidFail() {

        self.playButton.isEnabled = false
        self.pauseButton.isEnabled = false
        self.loadingIndicatorView.stopAnimating()
        self.errorLabel.isHidden = false

    }

    func playbackDidStart() {

        self.playButton.isHidden = true
        self.pauseButton.isHidden = false
        self.errorLabel.isHidden = true

    }

    func playbackDidProgress(amount: Double) {

        self.positionProgressView.setProgress(Float(amount), animated: true)

    }

    func playbackDidStop() {

        self.playButton.isHidden = false
        self.pauseButton.isHidden = true

    }

    func playbackDidFinish() {

        self.playButton.isHidden = false
        self.pauseButton.isHidden = true

    }

    func playbackDidFail() {

        self.playButton.isHidden = false
        self.pauseButton.isHidden = true
        self.errorLabel.isHidden = false

    }
    
}
