//
//  ViewController.swift
//  RemoteConfigFirebase
//
//  Created by Arpit iOS Dev. on 21/06/24.
//

import UIKit
import FirebaseRemoteConfig

class ViewController: UIViewController {

    let welcomeMessageConfigKey = "welcome_message"
    let goodMorningMessageConfigKey = "goodmorning_message"
    let welcomeMessageCapsConfigKey = "welcome_message_caps"
    let loadingPhraseConfigKey = "loading_phrase"

    var remoteConfig: RemoteConfig!
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var goodMorningLabel: UILabel!

    override func viewDidLoad() {
      super.viewDidLoad()
      remoteConfig = RemoteConfig.remoteConfig()
      let settings = RemoteConfigSettings()
      settings.minimumFetchInterval = 0
      remoteConfig.configSettings = settings

      remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")

      fetchConfig()
    }

    func fetchConfig() {
      welcomeLabel.text = remoteConfig[loadingPhraseConfigKey].stringValue
      goodMorningLabel.text = remoteConfig[loadingPhraseConfigKey].stringValue

      remoteConfig.fetch { (status, error) -> Void in
        if status == .success {
          print("Config fetched!")
          self.remoteConfig.activate { changed, error in
          }
        } else {
          print("Config not fetched")
          print("Error: \(error?.localizedDescription ?? "No error available.")")
        }
        self.displayWelcome()
      }
    }

    func displayWelcome() {
      var welcomeMessage = remoteConfig[welcomeMessageConfigKey].stringValue
      var goodMorningMessage = remoteConfig[goodMorningMessageConfigKey].stringValue

      if remoteConfig[welcomeMessageCapsConfigKey].boolValue {
        welcomeMessage = welcomeMessage?.uppercased()
          goodMorningMessage = goodMorningMessage?.uppercased()
      }
      welcomeLabel.text = welcomeMessage
        goodMorningLabel.text = goodMorningMessage
    }

  }
