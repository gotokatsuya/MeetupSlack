//
//  SlackReceiveMessageViewController.swift
//  MeetupSlack
//
//  Created by goka on 2016/04/26.
//  Copyright © 2016年 goka. All rights reserved.
//

import Cocoa

class SlackMessageViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let slackMessagePresenter = SlackMessagePresenter()
        if let screens = NSScreen.screens() {
            let screen = screens[0]
            slackMessagePresenter.receiveSlackMessage(screen)
        }
    }
}
