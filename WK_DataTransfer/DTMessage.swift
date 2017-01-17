//
//  DTMessage.swift
//  WK_DataTransfer
//
//  Created by Luke Inger on 13/01/2017.
//  Copyright © 2017 Luke Inger. All rights reserved.
//

import UIKit

class DTMessage: NSObject {
    
    var Values:NSMutableArray = NSMutableArray()
    
    func addItem(title:String,value:String){
        let messageItem:DTMessageItem = DTMessageItem()
        messageItem.title = title
        messageItem.value = value
        Values.add(messageItem)
    }
    
    func toDict() -> [String:Any] {
        var emptyDictionary = Dictionary<String, Any>()
        for message in Values {
            if let msg = message as? DTMessageItem {
                
                if let t = msg.title, let v = msg.value {
                    emptyDictionary[t] = v
                }
            }
        }
        return emptyDictionary
    }
    
    func fromDict(dict:[String:Any]) -> DTMessage {
        let message:DTMessage = DTMessage()
        for (title,value) in dict {
                message.addItem(title: title, value: value as! String)
        }
        
        return message
    }

}

class DTMessageItem: NSObject {
    
    var title:String?
    var value:String?
    
}
