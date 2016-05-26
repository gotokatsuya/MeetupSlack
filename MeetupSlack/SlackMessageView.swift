//
//  CommentView.swift
//  MeetupSlack
//
//  Created by goka on 2016/04/26.
//  Copyright © 2016年 goka. All rights reserved.
//

import Cocoa

class SlackMessageView: NSView {
    
    @IBOutlet weak var messageTextField: NSTextField!
    
    class var nibName: String { get { return "SlackMessageView" } }
    
    class func newSlackMessageView(text: String, fontColor: NSColor? = nil) -> SlackMessageView {
        
        var topLevelObjects: NSArray?
        let nib = NSNib(nibNamed: nibName, bundle: NSBundle.mainBundle())!
        nib.instantiateWithOwner(nil, topLevelObjects: &topLevelObjects)
        
        var view: SlackMessageView!
        
        for object: AnyObject in topLevelObjects! {
            if let obj = object as? SlackMessageView {
                view = obj
                break
            }
        }
        
        view.messageTextField.stringValue = text
        
        let attributes =  [
            NSStrokeColorAttributeName: NSColor.blackColor(),
            NSStrokeWidthAttributeName: NSNumber(float: -4.0),
            NSForegroundColorAttributeName: fontColor ?? NSColor.whiteColor(),
        ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        view.messageTextField.cell!.attributedStringValue = attributedString
        return view
    }
}