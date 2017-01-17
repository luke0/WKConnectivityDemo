//
//  InterfaceController.swift
//  WK_DataTransfer WatchKit Extension
//
//  Created by Luke Inger on 13/01/2017.
//  Copyright © 2017 Luke Inger. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation

class InterfaceController: WKInterfaceController {
    
    //MARK: - Outlets
    @IBOutlet var tableDetails: WKInterfaceTable!
    @IBOutlet var buttonSendMessage: WKInterfaceButton!
    
    //MARK: - Objects
    var DTWCSession:WCSession = WCSession.default()
    
    //MARK: - Data
    var items:NSMutableArray = NSMutableArray()
    var itemIndex:NSInteger = 0
    
    //MARK: - View Hierarchy
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        //The crown focus and delegate must be set
        crownSequencer.focus()
        crownSequencer.delegate = self
        
        // Configure interface objects here.
        self.activateSession()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        self.setButtonTitle()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    //MARK: - WCSession
    func activateSession() {
        
        if WCSession.isSupported() {
            DTWCSession.delegate = self
            DTWCSession.activate()
        } else {
            print("WCSession is not supported on Watch")
        }
        
    }
    
    func sendRequestToDevice() {
        
        let message:DTMessage = DTMessage()
        message.addItem(title: "User", value: "Joe Bloggs")
        message.addItem(title: "Request", value: "Data")
        
        DTWCSession.sendMessage(message.toDict(), replyHandler: { (replayDic: [String : Any]) -> Void in
            
            //Convert the reply back into a DTMessage format
            var msg:DTMessage = DTMessage()
            msg = msg.fromDict(dict: replayDic)
            
            for item in msg.Values {
                if let i = item as? DTMessageItem {
                    self.items.add(i)
                }
            }
            
            self.loadTable()
            
        }, errorHandler: { (error) -> Void in
            print(error)
        })
        
    }
    
    //MARK: - Button Actions
    @IBAction func buttonSendMessage_DidTap() {
        sendRequestToDevice()
    }
    
    func setButtonTitle(){
        self.buttonSendMessage.setTitle("Load Items \(itemIndex)")
    }
    
    //MARK: - Table Methods
    func loadTable() {
        
        tableDetails.setNumberOfRows(items.count, withRowType: "TableData")
        
        for index in 0..<items.count {
            if let controller = tableDetails.rowController(at: index) as? TableRowController {
                if let item = self.items.object(at: index) as? DTMessageItem {
                    controller.labelDetails.setText(item.value)
                }
            }
        }
        
    }
}

extension InterfaceController: WKCrownDelegate {
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {

        if rotationalDelta>0 {
            //Positive Rotation
            itemIndex += 1
        } else {
            //Negative Roation
            itemIndex -= 1
        }
        
        self.setButtonTitle()
    }
    
    func crownDidBecomeIdle(_ crownSequencer: WKCrownSequencer?) {
        self.setButtonTitle()
    }

}

extension InterfaceController: WCSessionDelegate {
 
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == WCSessionActivationState.activated {
            print("WC Session Activated")
        } else if activationState == WCSessionActivationState.inactive {
            print("WC Session Inactive")
        } else if activationState == WCSessionActivationState.notActivated {
            print("WC Session Not Activate")
        }
    }
    
}
