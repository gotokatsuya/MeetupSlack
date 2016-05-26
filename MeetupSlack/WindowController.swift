//
//  WindowController.swift
//  MeetupSlack
//
//  Created by goka on 2016/04/26.
//  Copyright © 2016年 goka. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window!.delegate = self
    }
}

extension WindowController: NSWindowDelegate {
    func windowWillClose(notification: NSNotification) {
        NSApplication.sharedApplication().terminate(NSApp?.keyWindow!)
    }
}