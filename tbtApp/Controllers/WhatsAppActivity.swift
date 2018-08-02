//
//  ViewController.swift
//  tbtApp
//
//  Created by Selin Ersev on 26.07.2018.
//  Copyright © 2018 Selin Ersev. All rights reserved.
//

import UIKit

class WhatsAppActivity : UIActivity{
    
    override init() {
        self.text = ""
        
    }
    
    var text:String?
    
    
    override func activityType()-> String {
        return NSStringFromClass(self.classForCoder)
    }
    
    override func activityImage()-> UIImage
    {
        return UIImage(named: "whatsapp2")!;
    }
    
    override func activityTitle() -> String
    {
        return "WhatsApp";
    }
    
    override class func activityCategory() -> UIActivityCategory{
        return UIActivityCategory.Share
    }
    
    func getURLFromMessage(message:String)-> NSURL
    {
        var url = "whatsapp://"
        
        if (message != "")
        {
            url = "\(url)send?text=\(message)"
        }
        
        return NSURL(string: url)!
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        for activityItem in activityItems
        {
            if (activityItem.isKindOfClass(NSString))
            {
                self.text = activityItem as? String;
                var whatsAppURL:NSURL  = self.getURLFromMessage(self.text!)
                return UIApplication.sharedApplication().canOpenURL(whatsAppURL)
            }
        }
        return false;
    }
    
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        for activityItem in activityItems{
            if(activityItem.isKindOfClass(NSString)){
                var whatsAppUrl:NSURL = self.getURLFromMessage(self.text!)
                if(UIApplication.sharedApplication().canOpenURL(whatsAppUrl)){
                    UIApplication.sharedApplication().openURL(whatsAppUrl)
                }
                break;
            }
        }
    }
}
