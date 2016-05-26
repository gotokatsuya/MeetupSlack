//
//  CommentFlowPresenter.swift
//  MeetupSlack
//
//  Created by goka on 2016/04/26.
//  Copyright © 2016年 goka. All rights reserved.
//

import Foundation
import Cocoa

class SlackMessagePresenter {
    
    let slackMessageUseCase = SlackMessageUseCase(token: SLACK_TOKEN)
    
    private var messages: [String: (SlackMessageView)] = [:]
    private var messageViews: [SlackMessageView?] = []
    private var window: NSWindow = NSWindow()
    
    func receiveSlackMessage(screen: NSScreen) {
        refreshMessages()
        window = makeMessageWindow(screen)
        slackMessageUseCase.registerCallback({(text:String) in
            self.addMessage(text)
        })
        slackMessageUseCase.connect()
    }
    
    func stopReceiveMessage() {
        window.orderOut(nil)
        refreshMessages()
    }
}

private extension SlackMessagePresenter {
    
    func refreshMessages() {
        messages = [:]
        messageViews = []
    }
    
    func addMessage(text: String) {
        if messages[text] != nil {
            return
        }
        let view = makeMessageView(text)
        window.contentView?.addSubview(view)
        messages[text] = (view: view)
        startAnimationComment(text, view: view)
    }
    
    func removeMessage(text: String) {
        if messages[text] == nil {
            return
        }
        messages[text]!.removeFromSuperview()
        messages[text] = nil
    }
    
    func startAnimationComment(text: String, view: SlackMessageView) {
        let windowFrame = self.window.frame
        let v: CGFloat = 200.0
        let firstDuration = NSTimeInterval(view.frame.width / v)
        let len = windowFrame.width
        let secondDuration = NSTimeInterval(len / v)
        NSAnimationContext.runAnimationGroup(
            { context in
                context.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                context.duration = firstDuration
                view.animator().frame = CGRectOffset(view.frame, -view.frame.width, 0)
                
            }, completionHandler: { [unowned self] in
                
                for (index, v) in self.messageViews.enumerate() {
                    if v == view {
                        self.messageViews[index] = nil
                        break;
                    }
                }
                
                NSAnimationContext.runAnimationGroup(
                    { context in
                        context.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                        context.duration = secondDuration
                        view.animator().frame = CGRectOffset(view.frame, -len, 0)
                        
                    }, completionHandler: {
                        self.removeMessage(text)
                    }
                )
            }
        )
    }
    
    func makeMessageView(text: String) -> SlackMessageView {
        
        let messageView: SlackMessageView = SlackMessageView.newSlackMessageView(text, fontColor: NSColor.blackColor())
        
        var space = 0
        if messageViews.count == 0 {
            messageViews.append(messageView)
        } else {
            var add = false
            for (index, view) in messageViews.enumerate() {
                if view == nil {
                    messageViews[index] = messageView
                    space = index
                    add = true
                    break
                }
            }
            if !add {
                messageViews.append(messageView)
                space = messageViews.count
            }
        }
        
        messageView.layoutSubtreeIfNeeded()
        
        let windowFrame = self.window.frame
        let y = (windowFrame.height - messageView.frame.height) - (CGFloat(space) * messageView.frame.height)
        messageView.frame.origin = CGPointMake(windowFrame.width, y)
        
        return messageView
    }
    
    func makeMessageWindow(screen: NSScreen) -> NSWindow {
        
        let menuHeight: CGFloat = 23.0
        
        let size = CGSizeMake(screen.frame.size.width, screen.frame.size.height - menuHeight)
        let frame = NSRect(origin: CGPointZero, size: size)
        
        window = NSWindow(contentRect: frame, styleMask: NSResizableWindowMask, backing: .Buffered, defer: false, screen: screen)
        
        window.styleMask = NSBorderlessWindowMask
        window.opaque = false
        window.hasShadow = false
        window.movable = true
        window.movableByWindowBackground = true
        window.releasedWhenClosed = false
        window.backgroundColor = NSColor.clearColor()
        
        window.level = Int(CGWindowLevelForKey(.MaximumWindowLevelKey))
        window.makeKeyAndOrderFront(nil)
        
        return window
    }
    
}