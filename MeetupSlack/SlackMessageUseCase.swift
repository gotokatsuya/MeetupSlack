//
//  Leaderboard.swift
//  MeetupSlack
//
//  Created by goka on 2016/05/26.
//  Copyright © 2016年 goka. All rights reserved.
//

import SlackKit
import Foundation

public class SlackMessageUseCase : NSObject {
    
    let client: Client
    
    init(token: String) {
        client = Client(apiToken: token)
    }
    
    var callback: ((String -> Void))?
    
    public func connect() {
        client.connect()
        NSTimer.scheduledTimerWithTimeInterval(5.0,
                                               target: self,
                                               selector: #selector(SlackMessageUseCase.fetchChannelHisotry),
                                               userInfo: nil,
                                               repeats: true)
    }
    
    func fetchChannelHisotry() {
        let now: NSDate = NSDate()
        let past: NSDate = NSDate().dateByAddingTimeInterval(-5)
        client.webAPI.channelHistory(SLACK_CHANNEL_ID, latest: "\(now.timeIntervalSince1970)", oldest: "\(past.timeIntervalSince1970)", inclusive: false, count: 50, unreads: false, success: {(history) -> Void in
            if let hist = history {
                self.handleReceivedMessages(hist.messages)
            }
        }, failure: nil)
    }
    
    private func handleReceivedMessages(messages: [Message]) {
        if self.callback == nil {
            print("Not implemented callback.")
            return
        }
        for message in messages {
            if let text = message.text {
                self.callback!(text)
            }
        }
    }
    
    public func registerCallback(callback: (String -> Void)) {
        self.callback = callback
    }
}