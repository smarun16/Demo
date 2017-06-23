//
//  LURefreFriendsViewController.swift
//  Levare User
//
//  Created by AngMac137 on 11/21/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

import UIKit


class LURefreFriendsViewController: UIViewController {
    
    // Outlets
    @IBOutlet var myRefreImageView: UIImageView!
    @IBOutlet var myReferLabel: UILabel!
    @IBOutlet var myCollectionView: UICollectionView!
    
    //Model
    var myInfoArray  = [[String: AnyObject]]()
    var myPromotionString : String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupModule()
        loadModule()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        
        
    }
    
    func setupModule() {
        
        
        let aRefralString = String(format : "Share your promo code %@ with friends and they will get their first ride free(upto $2). Once they have tried levare you will automatically get free ride(upto $2)next time you use levare", myPromotionString)
        
        let aString = NSMutableAttributedString(string :aRefralString, attributes: [NSFontAttributeName: UIFont .systemFont(ofSize: 14.0)])
        
        aString.addAttribute(NSForegroundColorAttributeName, value: [self .getColorFromString(hex: COLOR_APP_PRIMARY).cgColor], range: NSMakeRange(23, myPromotionString.characters.count))
        
        myReferLabel.attributedText = aString
        
    }
    
    func loadModule() {
        
        
        myInfoArray.insert([KEY_TEXT : "Facebook" as AnyObject, KEY_IMAGE : #imageLiteral(resourceName: "icon_facebook")], at: 0)
        myInfoArray.insert([KEY_TEXT : "Twitter" as AnyObject, KEY_IMAGE : #imageLiteral(resourceName: "icon_twitter")], at: 1)
        myInfoArray.insert([KEY_TEXT : "Whatsapp" as AnyObject, KEY_IMAGE : #imageLiteral(resourceName: "icon_whatsapp")], at: 2)
        myInfoArray.insert([KEY_TEXT : "Message" as AnyObject, KEY_IMAGE : #imageLiteral(resourceName: "icon_message")], at: 3)
        myInfoArray.insert([KEY_TEXT : "Email" as AnyObject, KEY_IMAGE : #imageLiteral(resourceName: "icon_mail")], at: 4)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 2
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (section == 0) ? 3 : 2
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let aCell : UICollectionViewCell!
        let shareCell = "shareCell"
        
        aCell = collectionView.dequeueReusableCell(withReuseIdentifier: shareCell, for: indexPath)
        
        let aImageView = aCell .viewWithTag(1) as! UIImageView!
        let aLabel = aCell.viewWithTag(2) as! UILabel!
        
        if indexPath.section == 0 {
            
            aImageView?.image = myInfoArray[indexPath.row][KEY_IMAGE] as! UIImage?
            aLabel?.text = myInfoArray[indexPath.item][KEY_TEXT] as! String?
        }
        else {
            
            aImageView?.image = myInfoArray[indexPath.row + 3][KEY_IMAGE] as! UIImage?
            aLabel?.text = myInfoArray[indexPath.item + 3][KEY_TEXT] as! String?
        }
        
        return aCell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,                                sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return (indexPath.section == 0) ? CGSize(width:collectionView.frame.size.width/3,height:collectionView.frame.size.width/3) : CGSize(width:collectionView.frame.size.width/2,height:collectionView.frame.size.width/2)
    }

    public func collectionView(_collectionView : UICollectionView, didSelectItemAt indexpath : IndexPath) {
        
        if indexpath.section == 0 {
            
            if indexpath.item == 0 {
                
            }
            else if indexpath.item  == 1 {
                
            }
            else if indexpath.item == 2 {
                
            }
        }
        else {
            
            if indexpath.item == 0 {
                
                
            }
            else if indexpath.item == 1 {
                
                
            }
        }
    }
    
    //MARK:  Helper
    
    func setUpNavigationController() {
        
        self.navigationController?.navigationBar.barTintColor = getColorFromString(hex: COLOR_APP_PRIMARY)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar .isTranslucent = true
        // self.navigationController?.navigationBar.barStyle : UIBarStyleBlackTranslucent!
    }
    
    func getColorFromString (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func getColorByHex(rgbHexValue:UInt32) -> UIColor {
        
        let red = Double((rgbHexValue & 0xFF0000) >> 16) / 256.0
        let green = Double((rgbHexValue & 0xFF00) >> 8) / 256.0
        let blue = Double((rgbHexValue & 0xFF)) / 256.0
        
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(1.0))
    }
    
     
    
}
