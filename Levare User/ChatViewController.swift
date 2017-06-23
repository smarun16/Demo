//
//  ChatViewController.swift
//  Levare
//
//  Created by Arun Prasad.S, ANGLER - EIT on 18/05/17.
//  Copyright © 2017 AngMac137. All rights reserved.
//

import UIKit
import Foundation
import SwiftR
import SwiftyJSON

class ChatViewController : UIViewController, UITextViewDelegate,UITableViewDataSource, UITableViewDelegate
{
    
    var myChatInfoMutableArray:[Any] = []
    var gTripIdString,gUserIdString, myTextViewString : String!
    var myTripStatusIdInteger : Int!
    
    // SignalR
    var gHub : Hub!
    var gHubConnection : SignalR!
    var callBackBlock: ((_ iscallBack: Bool, _ isRequestCancel: Bool) -> Void)? = nil
    
    
    @IBOutlet var myTableView: UITableView!
    @IBOutlet var myTextView: UITextView!
    @IBOutlet var mySendButton: UIButton!
    @IBOutlet var myTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var myTextViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var myTableViewTopConstraint: NSLayoutConstraint!
    
    //MARK:View Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // setup UI & Content
        setupUI()
        setupModel()
        
        // Load Contents
        loadModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if myChatInfoMutableArray.count > 0 {
            
            let scrollToIndexpath = IndexPath(row: myChatInfoMutableArray.count - 1, section: 0)
            myTableView.scrollToRow(at: scrollToIndexpath, at: .bottom, animated: true)
        }
        
    }
    
    // MARK UI Intial Set Up & its helper
    
    func setupUI() {
        
        setUpNavigationBar()
        
        myTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        myTableView.estimatedRowHeight = 100
        myChatInfoMutableArray = OBJ_SESSION?.getChatInfo() as! [Any]
        
        SWIFT_HELPER.roundCorner(for: mySendButton, withRadius: 5)
        SWIFT_HELPER.roundCorner(for: myTextView, radius: 5, borderColor: UIColor.lightGray)
        
    }
    
    func setUpNavigationBar() {
        
        navigationController?.navigationBar.barTintColor = (OBJ_HELPER?.getColorFromHexaDecimal(COLOR_APP_PRIMARY))!
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationController?.navigationBar.layer.shadowColor = UIColor.white.cgColor
        
        // TO SET TILE COLOR & FONT
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont(name: FONT_HELVETICA_NEUE, size: CGFloat(14.0))
        label.textAlignment = .center
        label.textColor =  UIColor.white
        navigationItem.titleView = label
        label.text = SCREEN_TITLE_CHAT
        label.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(leftBarButtonTapEvent(sender:)))
    }
    
    func setupModel() {
        
        let aTapGesture = UITapGestureRecognizer(target: self, action: #selector(touchesEndEditing))
        aTapGesture.numberOfTouchesRequired = 1
        self.myTableView.addGestureRecognizer(aTapGesture)
        
        if myTextView.text == "" {
            
            mySendButton.backgroundColor = UIColor.lightGray
            mySendButton.isUserInteractionEnabled = false
        }
        
    }
    
    func loadModel()
    {
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.updateViewForchatStatusChange), name: NSNotification.Name(rawValue: NOTIFICATION_VIEW_UPADTE_BASED_ON_CHAT_STATUS), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.updateRequestBasedOnStatusChange), name: NSNotification.Name(rawValue: NOTIFICATION_VIEW_UPADTE_BASED_ON_REQUEST_STATUS), object: nil)
        
    }
    
    //MARK:  UITableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myChatInfoMutableArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var aCell  = tableView.dequeueReusableCell(withIdentifier: "chatCell")
        
        if (aCell == nil) {
            
            aCell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: nil )
        }
        
        let gRightLabel: UILabel? = (aCell?.viewWithTag(1) as? UILabel)
        let gLeftLabel: UILabel? = (aCell?.viewWithTag(4) as? UILabel)
        
        
        var gRightView,gLeftView : UIView!
        
        gRightView = aCell?.viewWithTag(2)
        gLeftView = aCell?.viewWithTag(3)
        
        
        let aMessageString = replaceOptionalValue(aString: (myChatInfoMutableArray[indexPath.row] as AnyObject)["Message"] as! String!)
        
        if  (myChatInfoMutableArray[indexPath.row] as AnyObject)["Type"] as! String! != SR_CUSTOMER_TYPE {
            
            gLeftLabel?.isHidden = true
            gLeftView.isHidden = true
            gRightLabel?.isHidden = false
            gRightView.isHidden = false
            gRightLabel?.text = aMessageString
        }
            
        else {
            
            gRightLabel?.isHidden = true
            gRightView.isHidden = true
            gLeftLabel?.isHidden = false
            gLeftView.isHidden = false
            gLeftLabel?.text = aMessageString
        }
        
        SWIFT_HELPER.roundCorner(for: gRightView, withRadius: 6)
        SWIFT_HELPER.roundCorner(for: gLeftView, withRadius: 6)
        
        return aCell!
    }
    
    func tableView(_ tableView: UITableView,willDisplay cell: UITableViewCell,forRowAt indexPath: IndexPath) {
        
        if cell.responds(to:(#selector(setter: UITableViewCell.separatorInset))) {
            
            cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10)
        }
        
        if cell.responds(to:(#selector(setter: UIView.layoutMargins))) {
            
            cell.layoutMargins = UIEdgeInsetsMake(0, 10, 0, 10)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath) {
        
        myTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        
        if myTableView.responds(to:(#selector(setter: UITableViewCell.separatorInset))) {
            
            myTableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10)
        }
        
        if myTableView.responds(to:(#selector(setter: UIView.layoutMargins))) {
            
            myTableView.layoutMargins = UIEdgeInsetsMake(0, 10, 0, 10)
        }
    }
    
    //MARK: UIButton Title
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        
        sendButtonTapped()
    }
    
    func sendButtonTapped()  {
        
        mySendButton.backgroundColor = UIColor.lightGray
        mySendButton.isUserInteractionEnabled = false
        sendButtonTapActionCall()
    }
    
    func sendButtonTapActionCall() {
        
        do {
            let aTripID = gTripIdString as String!
            let aMessage = self.myTextView.text as String!
            
            try gHub.invoke(SR_SEND_CHAT_MESSAGE, arguments: [aTripID! ,replaceOptionalValue(aString: "\((OBJ_SESSION?.getUserInfo()[0] as AnyObject!)[K_CUSTOMER_ID])"),SR_CUSTOMER_TYPE,aMessage!], callback: { (result, error) in
                
                print(error.debugDescription)
                
                if result != nil {
                    
                    let message = String(describing: result as! String)
                    let json = JSON(data: message.data(using: .utf8)!)
                    
                    if  json[kRESPONSE][kRESPONSE_CODE].intValue == kSUCCESS_CODE {
                        
                        self.myTableView.reloadDataWithAnimation()
                        self.myTextView.text = "";
                        self.mySendButton.backgroundColor = UIColor.lightGray
                        self.mySendButton.isUserInteractionEnabled = false
                        self.myTextViewHeightConstraint.constant = 30
                    }
                        
                    else if json[kRESPONSE][kRESPONSE_CODE].intValue == k_BAD_REQUEST {
                        
                        OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: json[kRESPONSE][kRESPONSE_CODE].stringValue)
                    }
                        
                    else if json[kRESPONSE][kRESPONSE_CODE].intValue == K_NO_DATA_CODE {
                        
                        SWIFT_HELPER.showAlertView(self, title: SCREEN_TITLE_CHAT, message: json[kRESPONSE][kRESPONSE_CODE].stringValue, okButtonBlock: { (_ action : UIAlertAction) in
                            
                            self.dismiss(animated: true, completion: {() -> Void in
                                
                                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATION_VIEW_UPADTE_BASED_ON_CHAT_STATUS), object:nil)
                                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATION_VIEW_UPADTE_BASED_ON_REQUEST_STATUS), object: nil)
                                self.myTextView.resignFirstResponder()
                                self.myTextView.text = "";
                                self.myTextViewHeightConstraint.constant = 30
                                
                                if (self.callBackBlock != nil) {
                                    self.callBackBlock!(true, false)
                                }
                            })
                        })
                    }
                        
                    else {
                        
                        OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: MESSAGE_SOMETHING_WENT_WRONG)
                    }
                }
                else {
                    
                    OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: MESSAGE_SOMETHING_WENT_WRONG)
                }
            })
            
        }
        catch {
            
        }
    }
    func leftBarButtonTapEvent(sender : UIBarButtonItem) {
        
        navigationController?.dismiss(animated: true, completion: {() -> Void in
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATION_VIEW_UPADTE_BASED_ON_CHAT_STATUS), object:nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATION_VIEW_UPADTE_BASED_ON_REQUEST_STATUS), object: nil)
            
            if (self.callBackBlock != nil) {
                self.callBackBlock!(true, false)
            }
        })
    }
    
    //MARK: UITextView Delegate Methods
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        
        let currenttext = textView.text as NSString?
        
        
        let aText = currenttext?.replacingCharacters(in: range, with: text)
        let aStr = aText?.replacingOccurrences(of: " ", with: "")
        
        if ((aStr?.characters.count) != 0) {
            
            mySendButton.backgroundColor = UIColor.black
            mySendButton.isUserInteractionEnabled = true
        }
        else {
            
            mySendButton.backgroundColor = UIColor.lightGray
            mySendButton.isUserInteractionEnabled = false
        }
        myTextViewHeightConstraint.constant = ( textView.contentSize.height > 150) ? 150 : textView.contentSize.height
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if myChatInfoMutableArray.count > 0 {
            
            let scrollToIndexpath = IndexPath(row: myChatInfoMutableArray.count - 1, section: 0)
            myTableView.scrollToRow(at: scrollToIndexpath, at: .bottom, animated: true)
        }
        
        OBJ_HELPER?.slideUpViewTransFormMakeTranslationView(self.view)
        
        if myTableView.contentSize.height < 250 {
            
            myTableViewTopConstraint.constant = 250
        }
        else {
            
            myTableViewTopConstraint.constant = 0
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        OBJ_HELPER?.slideDownViewTransFormMakeTranslationView(self.view)
        myTableViewTopConstraint.constant = 0
        
    }
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        
    }
    
    //MARK: Helper
    
    // Hide Keyboard
    func touchesEndEditing() {
        
        self.view.endEditing(true)
    }
    
    //For update chat message
    func updateViewForchatStatusChange(notification:NSNotification){
        
        var dictionary = notification.userInfo
        let response = dictionary?[NOTIFICATION_CHAT_STATUS_KEY]
        
        let message = String(describing: response as! String)
        let jsonResponse = try? JSON(data: message.data(using: .utf8)!)
        
        if  jsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == kSUCCESS_CODE {
            
            if let data = jsonResponse {
                
                let aArray = data["Chat_Info"].arrayObject!
                
                let  aNewArray = aArray as? Array<Any>
                
                if let aNewArray = aNewArray {
                    
                    
                    myChatInfoMutableArray.append(aNewArray[0])
                    OBJ_SESSION?.setChatInfo(myChatInfoMutableArray as! NSMutableArray )
                    
                }
                else {
                    
                    print("error")
                }
            }
            
            
            myTableView.reloadData()
            
            let lastRowNumber = myTableView.numberOfRows(inSection: 0) == 0 ? 0 : myTableView.numberOfRows(inSection: 0)
            
            if lastRowNumber > 0 , myTextView.isFirstResponder {
                
                myTextView.text = "";
                myTextViewHeightConstraint.constant = 30;
                
                if myChatInfoMutableArray.count > 0 {
                    
                    let scrollToIndexpath = IndexPath(row: myChatInfoMutableArray.count - 1, section: 0)
                    myTableView.scrollToRow(at: scrollToIndexpath, at: .bottom, animated: true)
                }
            }
            
        }
        else if  jsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == 0 || jsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == -1 {
            
            OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: jsonResponse?[kRESPONSE][kRESPONSE_CODE].stringValue)
        }
            
        else {
            
            OBJ_HELPER?.showNotificationWarning(in: self, withMessage: MESSAGE_SOMETHING_WENT_WRONG)
        }
        
        
    }
    // For show alert for request status
    
    func updateRequestBasedOnStatusChange(notification:NSNotification)  {
        
        var dictionary = notification.userInfo
        print(dictionary)
        let response = dictionary?[NOTIFICATION_REQUEST_STATUS_KEY]
        print(response)
        let aReceivedStatus = self.replaceOptionalValue(aString: response as! String)
        //let message = String(describing: response as! String)
        let json = JSON(data: aReceivedStatus.data(using: .utf8)!)
        
        if  json[kRESPONSE][kRESPONSE_CODE].intValue == 1 {
            
            let myTripStatusIdInteger = json[SR_TRIP_STATUS_ID].intValue
            
            if (myTripStatusIdInteger == SR_TRIP_REQUEST) {
                
                OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: json[kRESPONSE][kRESPONSE_CODE].stringValue)
            }
                
            else if myTripStatusIdInteger == SR_TRIP_BEFORE_CANCEL || myTripStatusIdInteger == SR_TRIP_AFTER_CANCEL {
                
                let tripCancelAlert = UIAlertController(title: SCREEN_TITLE_DASHBOARD, message: "Trip cancelled", preferredStyle: UIAlertControllerStyle.alert)
                
                tripCancelAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                    
                    self.dismiss(animated: true, completion: {() -> Void in
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATION_VIEW_UPADTE_BASED_ON_CHAT_STATUS), object:nil)
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATION_VIEW_UPADTE_BASED_ON_REQUEST_STATUS), object: nil)
                    })
                }))
                
                present(tripCancelAlert, animated: true, completion: nil)
            }
            else if myTripStatusIdInteger == SR_TRIP_ACCEPTED || myTripStatusIdInteger == SR_TRIP_ARRIVED {
                
                OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: json[kRESPONSE][kRESPONSE_MESSAGE].stringValue)
            }
                
            else {
                
                self.navigationController?.dismiss(animated: true, completion: {() -> Void in
                    
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATION_VIEW_UPADTE_BASED_ON_CHAT_STATUS), object:nil)
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATION_VIEW_UPADTE_BASED_ON_REQUEST_STATUS), object: nil)
                    
                    if (self.callBackBlock != nil) {
                        
                        self.callBackBlock!(false, false)
                    }
                })
                
            }
        }
        else if  json[kRESPONSE][kRESPONSE_CODE].intValue == 0 || json[kRESPONSE][kRESPONSE_CODE].intValue == -1 {
            
            OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: json[kRESPONSE][kRESPONSE_CODE].stringValue)
        }
        else {
            
            OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: MESSAGE_SOMETHING_WENT_WRONG)
        }
    }
    
    func replaceOptionalValue(aString: String) -> String {
        
        // To remove Optional(Optional(  AND ))
        
        let aNewString =  String(describing: aString).replacingOccurrences(of: DOUBLE_OPTIONAL_REMOVE_STRING, with: "").replacingOccurrences(of: REMOVE_BRACKET, with: "")
        return aNewString
    }
}
