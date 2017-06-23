 //
//  DashBoardRequestViewController.swift
//  Levare
//
//  Created by Gopinath, ANGLER - EIT on 29/05/17.
//  Copyright © 2017 AngMac137. All rights reserved.
//

import UIKit
import Foundation
import SwiftR
import SwiftyJSON
import GoogleMaps
import MapKit
import AVFoundation

let ACCEPTED = "Accepted"
let ARRIVED = "Arrived"
let START_RIDE = "Start Ride"
let END_RIDE = "End Ride"
let COMPLETED = "Completed"
let OPTIONAL_REMOVE_STRING = "Optional(\""
let OPTIONAL_REMOVE_BRACKET = "\")"
let DOUBLE_OPTIONAL_REMOVE_STRING = "Optional(Optional("
let REMOVE_BRACKET = "))"

enum SearchTypeEnum {
    
    case SEARCH_TYPE_SOURCE
    case SEARCH_TYPE_DESTINATION
    case SEARCH_TYPE_NONE
}


class DashBoardRequestViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate, UITextFieldDelegate, LUFavouritePopViewControllerDelegate,LUFavouriteSearchViewControllerDelegate {
    
    //MARK: IBOUTLETS
    @IBOutlet var myBidView: UIView!
    @IBOutlet var myBidBgView: UIView!
    @IBOutlet var myRequestView: UIView!
    @IBOutlet var myRequestShareView: UIView!
    @IBOutlet var myBidAmountView: UIView!
    @IBOutlet var myShareView: UIView!
    @IBOutlet var myCancelView: UIView!
    @IBOutlet var myCancelReasonView: UIView!
    @IBOutlet var myNotificationView: UIView!
    @IBOutlet var myEstimatedfare,myBidTimeLabel,myDriverNameLabel,myRatingLabel,myCancelChargeLabel: UILabel!
    @IBOutlet var myBidPopImageView,myProfileImageView : UIImageView!
    @IBOutlet var myBidAmountTextfield : UITextField!
    @IBOutlet var myBidSubmitButton,myCallButton,myMessageButton : UIButton!
    @IBOutlet var myTableView : UITableView!
    @IBOutlet var myRequestButtonHeightConstraint : NSLayoutConstraint!
    @IBOutlet var myMapView : GMSMapView!
    @IBOutlet var myClockImageView : UIImageView!
    @IBOutlet var myPromotionImageView : UIImageView!
    @IBOutlet var myBidImageView : UIImageView!
    @IBOutlet var myCardImageView :UIImageView!
    @IBOutlet var mytimeLabel : UILabel!
    @IBOutlet var myAmountLabel : UILabel!
    @IBOutlet var myPromotionLabel : UILabel!
    @IBOutlet var myBidLabel : UILabel!
    @IBOutlet var myBgView : UIView!
    @IBOutlet var myActivityIndicatorView : UIView!
    @IBOutlet var mySearchView : UIView!
    @IBOutlet var mySearchSourceView : UIView!
    @IBOutlet var mySearchSourceTextfield : UITextField!
    @IBOutlet var mySearchSourceImageView : UIImageView!
    @IBOutlet var mySearchDistinationView : UIView!
    @IBOutlet var mySearchDistinationTextfield : UITextField!
    @IBOutlet var mySearchDistinationImageView : UIImageView!
    @IBOutlet var mySearchSourceLabel : UILabel!
    @IBOutlet var mySearchDistinationLabel : UILabel!
    @IBOutlet var mySearchSourceViewBottomConstraint : NSLayoutConstraint!
    @IBOutlet var mySubmitButton : UIButton!
    @IBOutlet var myMapAnnotationImageView : UIImageView!
    @IBOutlet var myDestinationFavButton : UIButton!
    @IBOutlet var mySourceFavButton : UIButton!
    @IBOutlet var myScrollView : UIScrollView!
    @IBOutlet var myNVLoadingView : UIView!
    @IBOutlet var myRequestLoadingView : UIView!
    @IBOutlet var myTimerLabel : UILabel!
    @IBOutlet var myBidAmountAlert : UILabel!
    @IBOutlet var myOnGoingLoadingView : UIView!
    @IBOutlet var  loadingLabel : UILabel!
    @IBOutlet var progressRing : activityIndicator?
    @IBOutlet var myRequestLoadingButton : UIButton!
    @IBOutlet var myRequestCancelLabel : UILabel!
    
    var myDGActivityIndicatorView: DGActivityIndicatorView!
    
    var loader : NVActivityIndicatorView!
    
    
    // MARK: Model (variable Declaration)
    
    var gMapMutableInfo : [String] = []
    var myDriverInfoMutableArray : [Any] = []
    var myDriverRoutInfoMutableArray : [String] = []
    var gSearchInfoArray : [String] = []
    var myMapInfoArray : [String] = []
    var gSearchEnumInt = Int()
    
    
    var gServiceTag : TagServiceType!
    
    var  mySearchTypeEnum = SearchTypeEnum.SEARCH_TYPE_NONE
    
    var gFavoriteDestinationIdString, gfavoriteIdString : String!
    
    var gettingAddressFromLatLng : Bool = false
    var isSignalRSetUp : Bool = false
    var isForFavLocation : Bool = false
    var isLocationUpdated : Bool = false
    var isForOnGoingRequest : Bool = false
    var isInChatScreen : Bool = false
    var isDriverRoutDrawn : Bool = false
    var isMoveToInvoiceScreen : Bool = false
    var isRequestDeclined : Bool = false
    var isMapViewChanged  : Bool = false
    var isFavChanged : Bool = false
    var isFavSource : Bool = false
    var isFavDestination : Bool = false
    
    
    var myDeltingLocation : Int = 0
    var myRequestDeclinedInteger : Int = 0
    var myServiceID : Int = 0
    var myCancelIndex : Int = 0
    var myTripStatusIdInteger : Int = 0
    var myEstimatedValue : Int = 0
    var myCurrentRequest : Int = 0
    var seconds = 1
    
    var myLocationCoordinate : CLLocationCoordinate2D!
    var myLocationManager : CLLocationManager!
    var geocoder : GMSGeocoder!
    var placemark : CLPlacemark!
    var myRoutePolyLine : GMSPolyline! //your line
    var myRoutePolyLineView : MKPolylineRenderer! //overlay view
    var myUserMarker : GMSMarker!
    var aStatusString : String = ""
    
    
    var myInfoMutableArray : [Any] = []
    var myMapLocationMutableArray : [Any] = []
    var mySignalRConnectionMutableArray : [Any] = []
    
    var myServiceTypeMutableArray : [[String : Any]] = []
    var myServiceLocationTypeMutableArray : [Dictionary<String, Any>] = []
    var myCancelReasonMutableArray : [String] = []
    var mySearchMutableInfo : [String] = []
    var myMapLatLongMutableArray : [String] = []
    var myRideResponseMutableArray:[Dictionary<String, Any>] = []
    
    var myInfoMutableDict : [String : Any] = [:]
    var myFavSourseMutableDictionary : [String : Any] = [:]
    var myCurrentFavMutableDict : [String : Any] = [:]
    var myFavDestMutableDictionary : [String : Any] = [:]
    
    var myAddressString,myFavoritePrimaryLocation, myCancelIdString,
    myTripIdString, myMobileNumberString, myCancelCharge,
    myBidAmountString, myNearestVehicleResponseString, myPromoCodeIdString : String!
    
    var myHubProxyConnection :SignalR!
    var myHubProxy : Hub!
    
    
    private var aInterval = 0
    private var myTimer: Timer!
    private var myDifferenceInterval: TimeInterval = 0
    private var myNearestTripTimer: Timer!
    private var connectionTimer: Timer!
    private var isRequestStarted: Bool = false
    private var isStatusChanged: Bool = false
    private var isCanceled : Bool = false
    private var isAdded: Bool = false
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // setup UI & Content
        setupUI()
        setupModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        isLocationUpdated = false

        print(OBJ_SESSION?.isRequested() as Any)
        print(OBJ_SESSION?.isAlertShown() as Any)
        
        if (OBJ_SESSION?.isRequested()) == true  && (OBJ_SESSION?.isAlertShown()) == false  {
            
            getOnGoingRequest()
        }
        
        isMoveToInvoiceScreen = false
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(DashBoardRequestViewController.changeViewBasedOnFav), name: NSNotification.Name(rawValue: NOTIFICATION_VIEW_UPADTE_BASED_ON_REQUEST_STATUS_FROM_BACKGROUND), object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: View Init
    
    func setupUI() {
        
        
        let aServiceType = gServiceTag.service_type_name.characters.count > 0 ? gServiceTag.service_type_name : ""
        // To set navigation bar to present with navigation
        mySubmitButton.setTitle(TWO_STRING(string1: "Request for", string2: aServiceType!), for: .normal)
        
        setUpTapActionForView()
        
        SWIFT_HELPER.roundCorner(for: myBidAmountView, radius: 6, borderColor:UIColor.black)
        SWIFT_HELPER.roundCornerView(aView: self.myProfileImageView)
        SWIFT_HELPER.roundCorner(for: self.mySearchSourceImageView, radius: 6, borderColor:UIColor.clear)
        SWIFT_HELPER.roundCorner(for: self.mySearchDistinationImageView, radius: 6, borderColor:UIColor.clear)
        SWIFT_HELPER.roundCorner(for: self.myBidView, radius: 6, borderColor:UIColor.clear)
        SWIFT_HELPER.roundCorner(for: self.myCancelReasonView, radius: 6,borderColor:UIColor.clear)
        
        self.hideRequestLoadingView()
        
        SWIFT_HELPER.fadeAnimationfor(view: myBidBgView, alpha: 0, duration: 0, delay: 0)
        SWIFT_HELPER.fadeAnimationfor(view: myRequestView, alpha: 0, duration: 0, delay: 0)
        SWIFT_HELPER.fadeAnimationfor(view: myRequestLoadingView , alpha: 0, duration: 0, delay: 0)
        
        self.myMapView.isHidden = true
        
        mySearchSourceTextfield.delegate = self
        mySearchDistinationTextfield.delegate = self
        
        self.myCurrentFavMutableDict = [String : Any]()
        self.myMapLatLongMutableArray = [String]()
        self.myMapInfoArray = [String]()
        self.myMapLocationMutableArray = [Any]()
        
        self.mySearchMutableInfo =  [String]()
        self.mySignalRConnectionMutableArray =  [Any]()
        self.myServiceLocationTypeMutableArray =  [Dictionary<String, Any>]()
        self.myServiceTypeMutableArray =  [Dictionary<String, Any>]()
        self.myRideResponseMutableArray = [Dictionary<String, Any>]()
        
        self.myCancelReasonMutableArray =  [String]()
        mySearchTypeEnum = SearchTypeEnum.SEARCH_TYPE_SOURCE

        mySearchSourceViewBottomConstraint.constant = 0
        
        if self.gSearchInfoArray.count > 0 {
            
            mySearchSourceTextfield.text = self.gSearchInfoArray[0]
            mySearchDistinationTextfield.text = self.gSearchInfoArray[1]
        }
        mySourceFavButton.isSelected = isFavSource
        myDestinationFavButton.isSelected = isFavDestination
        
        if (self.gSearchInfoArray.count > 0) {
            
            mySearchMutableInfo.append(self.gSearchInfoArray[0])
            mySearchMutableInfo.append(self.gSearchInfoArray[1])
        }
    }
    
    func setUpNavigationBarWithCancelButton() {
        
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
        label.text = SCREEN_TITLE_DASHBOARD
        label.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem (title: "Cancel", style: .plain, target: self, action: #selector(self.leftBarButtonTapEvent))
    }
    
    // MARK: -Model
    func setupModel() {
        
        myPromoCodeIdString = ""
        self.myTimerLabel.text = String("00:00")
        myFavSourseMutableDictionary = [String: Any]()
        myFavDestMutableDictionary = [String: Any]()
        mySourceFavButton.isSelected = isFavSource
        myDestinationFavButton.isSelected = isFavDestination
        
        
        // Set text in textfield based on the search
        if mySearchTypeEnum == .SEARCH_TYPE_SOURCE {
            
            myDestinationFavButton.isHidden = true
            mySourceFavButton.isHidden = false
            myDestinationFavButton.isUserInteractionEnabled = false
            mySourceFavButton.isUserInteractionEnabled = true
            mySearchSourceView.isUserInteractionEnabled = true
            mySearchDistinationView.isUserInteractionEnabled = false
            mySearchSourceView.backgroundColor = UIColor.clear
            mySearchDistinationView.backgroundColor = OBJ_HELPER?.getColorFromHexaDecimal(COLOR_GROUP_TABLE_VIEW)
        }
        else {
            myDestinationFavButton.isHidden = false
            myDestinationFavButton.isUserInteractionEnabled = true
            mySourceFavButton.isUserInteractionEnabled = false
            mySourceFavButton.isHidden = true
            mySearchSourceView.isUserInteractionEnabled = false
            mySearchDistinationView.isUserInteractionEnabled = true
            mySearchSourceView.backgroundColor = OBJ_HELPER?.getColorFromHexaDecimal(COLOR_GROUP_TABLE_VIEW)
            mySearchDistinationView.backgroundColor = UIColor.clear
        }
        
        mySubmitButton.isUserInteractionEnabled = true
        mySubmitButton.backgroundColor = UIColor.black
        myRequestLoadingButton.isHidden = true
        myRequestCancelLabel.isHidden = true
        myMapView.delegate = self
        myMapView.isMyLocationEnabled = true
        myMapView.settings.myLocationButton = false
        myMapView.mapType = .normal
        myUserMarker = GMSMarker()
        myFavoritePrimaryLocation = ""
        myCancelCharge = ""
        myTripIdString = ""
        myTripStatusIdInteger = 0
        myCancelIdString = ""
        myBidAmountString = ""
        myMobileNumberString = ""
        myBidAmountTextfield.delegate = self

        
        setUpMapView()
        
        if OBJ_SESSION?.isRequested() == true {
            
            SWIFT_NAVIGATION?.setTitleWithBarButtonItems(APP_NAME, for: self, showLeftBarButton: nil, showRightBarButton: nil)
           
            view.bringSubview(toFront: myOnGoingLoadingView)
            SWIFT_HELPER.fadeAnimationfor(view: myOnGoingLoadingView, alpha: 1.0, duration: 0.0, delay: 0)
            
            self.progressRing?.strokeColor = (OBJ_HELPER?.getColorFromHexaDecimal(COLOR_APP_PRIMARY))!
            self.progressRing?.startLoading()
            
            NotificationCenter.default.addObserver(self, selector: #selector(DashBoardRequestViewController.getOnGoingRequest), name: NSNotification.Name(rawValue: VIEW_UPADTE_BASED_ON_REQUEST_STATUS), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(DashBoardRequestViewController.changeViewBasedOnFav), name: NSNotification.Name(rawValue: VIEW_UPADTE_BASED_ON_FAV_STATUS), object: nil)

        }
        else {
            
            SWIFT_NAVIGATION?.setTitleWithBarButtonItems(gServiceTag.service_type_name, for: self, showLeftBarButton: IMAGE_BACK, showRightBarButton: nil)
            SWIFT_HELPER.fadeAnimationfor(view: myOnGoingLoadingView, alpha: 0.0, duration: 0.0, delay: 0)
            self.progressRing?.animationDidStop(.init(), finished: true)
            
        }
        
        // start signalR
        setUpSignalR()
    }
    
    func setUpMapView() {
        
        geocoder = GMSGeocoder()
        CLLocationManager.locationServicesEnabled()
        myLocationManager = CLLocationManager()
        myLocationManager!.delegate = self
        myLocationManager?.distanceFilter = 1
        myLocationManager?.requestWhenInUseAuthorization()
        myLocationManager?.desiredAccuracy = kCLLocationAccuracyBest
        myLocationManager?.startUpdatingLocation()

        myMapView.clear()
        myMapView.delegate = self
        myMapView.isMyLocationEnabled = true
        myMapView.settings.myLocationButton = false
        myMapView.mapType = .normal
    }
    
    
    //MARK: UItableView DataSource and Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myCancelReasonMutableArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier: String = "CancelCell"
        var aCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if aCell == nil {
            
            aCell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        let gImageView  = aCell?.viewWithTag(10) as! UIImageView
        let gTitleLabel = aCell?.viewWithTag(20) as! UILabel
        
        gTitleLabel.text = (myCancelReasonMutableArray[indexPath.row] as AnyObject)["Reason"] as! String!
        
        
        if indexPath.row == myCancelIndex {
            
            gTitleLabel.textColor = OBJ_HELPER?.getColorFromHexaDecimal(COLOR_APP_PRIMARY)
            gImageView.image = UIImage(named: ICON_SELECT)
            
        } else {
            
            gTitleLabel.textColor = UIColor.black
            gImageView.image = UIImage(named: ICON_UN_SELECTE)
        }
        return aCell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        myCancelIndex = indexPath.row
        myTableView.reloadDataWithAnimation()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //iOS 7
        if cell.responds(to:(#selector(setter: UITableViewCell.separatorInset))) {
            
            cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10)
            
        }
        
        // iOS 8
        if cell.responds(to:(#selector(setter: UIView.layoutMargins))) {
            
            cell.layoutMargins = UIEdgeInsetsMake(0, 10, 0, 10)
        }
    }
    
    // MARK:  TextField Delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currenttext = textField.text as NSString?
        let aUpdateString = currenttext?.replacingCharacters(in: range, with: string)
        
        if textField.tag == 100 {
            
            if (aUpdateString?.characters.count)! > 5 {
                
                return false
            }
            
            myBidAmountAlert.text = "Your bid amount cannot be less than 50% of estimated fare"
            myBidAmountAlert.textColor = UIColor.lightGray
            myBidAmountString = aUpdateString
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == mySearchSourceTextfield {
            
            mySearchTypeEnum = SearchTypeEnum.SEARCH_TYPE_SOURCE
            
            if mySearchSourceView.isUserInteractionEnabled == false {
                
                mySearchSourceView.isUserInteractionEnabled = true
                mySearchDistinationView.isUserInteractionEnabled = false
                mySearchSourceView.backgroundColor = UIColor.clear
                mySearchDistinationView.backgroundColor = OBJ_HELPER?.getColorFromHexaDecimal(COLOR_GROUP_TABLE_VIEW)
                
                UIView.transition(with: self.view, duration: 5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    
                    if (self.mySearchSourceTextfield.text?.characters.count)! > 0 {
                        
                        self.mySourceFavButton.isSelected = self.isFavSource
                        self.mySourceFavButton.isHidden = false
                        self.myDestinationFavButton.isUserInteractionEnabled = false
                        self.mySourceFavButton.isUserInteractionEnabled = true
                    }
                    
                    self.myDestinationFavButton.isHidden = true
                    self.mySearchView.bringSubview(toFront: self.mySearchSourceView)
                    self.mySearchView.bringSubview(toFront: self.mySearchSourceImageView)
                    self.mySearchView.bringSubview(toFront: self.mySearchSourceTextfield)
                    self.mySearchView.bringSubview(toFront: self.mySourceFavButton)
                    
                }, completion: { (_ finished : Bool) in
                    
                })
                
                if myMapInfoArray.count >= 1 {
                    
                    var aLocationArray: [String] = (myMapInfoArray[0] as AnyObject).components(separatedBy: ",")
                    
                    if aLocationArray.count == 2 {
                        
                        myCurrentFavMutableDict[K_FAVORITE_LATITUDE] = aLocationArray[0]
                        myCurrentFavMutableDict[K_FAVORITE_LONGITUDE] = aLocationArray[1]
                        myLocationCoordinate = CLLocationCoordinate2DMake(CDouble(aLocationArray[0])!, CDouble(aLocationArray[1])!)
                    }
                    
                    gMapMutableInfo[0] = "\(myLocationCoordinate.latitude),\(myLocationCoordinate.longitude)"
                    isForFavLocation = true
                }
                return false
                
            } else {
                
                showGMSAutocompleteViewController()
            }
            
        }
            
        else if textField == myBidAmountTextfield {
            
            let bottomOffset = CGPoint(x: CGFloat(0), y: CGFloat(myScrollView.contentSize.height - myScrollView.bounds.size.height))
            myScrollView.setContentOffset(bottomOffset, animated: true)
            return true
        }
            
        else {
            
            mySearchTypeEnum = SearchTypeEnum.SEARCH_TYPE_DESTINATION
            
            if mySearchDistinationView.isUserInteractionEnabled == false {
                
                mySearchDistinationView.isUserInteractionEnabled = true
                mySearchSourceView.isUserInteractionEnabled = false
                mySearchDistinationView.backgroundColor = UIColor.clear
                mySearchSourceView.backgroundColor = OBJ_HELPER?.getColorFromHexaDecimal(COLOR_GROUP_TABLE_VIEW)
                
                UIView.transition(with: self.view, duration: 5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    
                    if (self.mySearchDistinationTextfield.text?.characters.count)! > 0 {
                        
                        self.myDestinationFavButton.isSelected = self.isFavDestination
                        self.myDestinationFavButton.isHidden = false
                        self.mySourceFavButton.isUserInteractionEnabled = false
                        self.myDestinationFavButton.isUserInteractionEnabled = true
                    }
                    
                    self.mySourceFavButton.isHidden = true
                    self.mySearchView.bringSubview(toFront: self.mySearchDistinationView)
                    self.mySearchView.bringSubview(toFront: self.mySearchDistinationImageView)
                    self.mySearchView.bringSubview(toFront: self.mySearchDistinationTextfield)
                    self.mySearchView.bringSubview(toFront: self.myDestinationFavButton)
                }, completion: { (_ finished : Bool) in
                    
                })
                
                if myMapInfoArray.count > 1 {
                    
                    var aLocationArray: [String] = (myMapInfoArray[1] as AnyObject).components(separatedBy: ",")
                    
                    if aLocationArray.count == 2 {
                        
                        myCurrentFavMutableDict[K_FAVORITE_LATITUDE] = aLocationArray[0]
                        myCurrentFavMutableDict[K_FAVORITE_LONGITUDE] = aLocationArray[1]
                        
                        myLocationCoordinate = CLLocationCoordinate2DMake(CDouble(aLocationArray[0])!, CDouble(aLocationArray[1])!)
                        
                    }
                    self.gMapMutableInfo[1] = "\(myLocationCoordinate.latitude),\(myLocationCoordinate.longitude)";
                    isForFavLocation = true
                }
                return false
                
            } else {
                
                showGMSAutocompleteViewController()
            }
            
        }
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.returnKeyType == UIReturnKeyType.next {
            
        }
        else {
            
            view.endEditing(true)
        }
        return true
    }
    
    //MARK: Favorite Pop Screen Delegate
    
    func getSelectedAddress(asFavorite aMutableArray: NSMutableArray!, iscallBack: Bool) {
        
        if iscallBack == true {
            
            var aMutableDict : [String: Any] = [:]
            
            aMutableDict[K_FAVORITE_LATITUDE] =  (gMapMutableInfo[1] as AnyObject).components(separatedBy: ",")[0]
            aMutableDict[K_FAVORITE_LONGITUDE] = (gMapMutableInfo[1] as AnyObject).components(separatedBy: ",")[1]
            
            print(aMutableArray.count)
            
            for i in 0...aMutableArray.count - 1 {
                
                let aTag: TagFavouriteType = (aMutableArray[i] as AnyObject) as! TagFavouriteType
                
                print("\(aTag)")
                
                var aLatitude = "\(String(describing: aTag.favourite_latitude))"
                var aLongitude = "\(String(describing:  aTag.favourite_longitude))"
                
                var aCurrentLatitude = ""
                var aCurrentLongitude = ""
                
                if self.myCurrentFavMutableDict.count != 0 {
                    
                    aCurrentLatitude = "\(String(describing: self.myCurrentFavMutableDict[K_FAVORITE_LATITUDE]))"
                    aCurrentLongitude = "\(String(describing: self.myCurrentFavMutableDict[K_FAVORITE_LONGITUDE]))"
                }
                
                
                switch self.mySearchTypeEnum {
                    
                case .SEARCH_TYPE_SOURCE:
                    
                    if self.myCurrentFavMutableDict.count == 0 {
                        
                        if self.myFavSourseMutableDictionary.count == 0 {
                            
                            aCurrentLatitude = "\(String(describing: aMutableDict[K_FAVORITE_LATITUDE]))"
                            aCurrentLongitude = "\(String(describing: aMutableDict[K_FAVORITE_LONGITUDE]))"
                        }
                        else {
                            
                            aCurrentLatitude = "\(String(describing: self.myFavSourseMutableDictionary[K_FAVORITE_LATITUDE]))"
                            aCurrentLongitude = "\(String(describing: self.myFavSourseMutableDictionary[K_FAVORITE_LATITUDE]))"
                        }
                    }
                    
                    aCurrentLatitude = replaceSingleOptionalValue(aString: aCurrentLatitude)
                    aCurrentLongitude = replaceSingleOptionalValue(aString: aCurrentLongitude)
                    aLatitude = replaceSingleOptionalValue(aString: aLatitude)
                    aLongitude = replaceSingleOptionalValue(aString: aLongitude)
                    
                    print("aCurrentLatitude\(aCurrentLatitude)")
                    print("aCurrentLongitude\(aCurrentLongitude)")
                    print("aLatitude\(aLatitude)")
                    print("aLongitude\(aLongitude)")
                    
                    let alatitudeIndex = aCurrentLatitude.index(aCurrentLatitude.startIndex, offsetBy: 9)
                    let alongitudeIndex = aCurrentLongitude.index(aCurrentLongitude.startIndex, offsetBy: 9)
                    
                    let aNewCurrentLatitude = (aCurrentLatitude.substring(to:alatitudeIndex) as String)
                    let aNewCurrentLongitude = (aCurrentLongitude.substring(to:alongitudeIndex) as String)
                    
                    print("acurruetlat --- \(aNewCurrentLatitude)")
                    print("acurruetlong --- \(aNewCurrentLongitude)")
                    
                    
                    if aNewCurrentLatitude == aLatitude.substring(to: aLatitude.index(before: aLatitude.endIndex)) && aNewCurrentLongitude ==  aLongitude.substring(to: aLongitude.index(before: aLongitude.endIndex)) {
                        
                        self.myFavSourseMutableDictionary[K_FAVORITE_ID] = aTag.favourite_type_id;
                        
                        self.mySourceFavButton.isSelected = true
                        self.isFavSource = true
                        self.gfavoriteIdString = aTag.favourite_type_id
                        self.myDestinationFavButton.isUserInteractionEnabled = false
                        self.mySourceFavButton.isUserInteractionEnabled = true
                        
                    }
                    
                    
                default:
                    
                    if self.myCurrentFavMutableDict.count == 0 {
                        
                        if self.myFavDestMutableDictionary.count == 0 {
                            
                            aCurrentLatitude = "\(String(describing: aMutableDict[K_FAVORITE_LATITUDE]))"
                            aCurrentLongitude = "\(String(describing: aMutableDict[K_FAVORITE_LONGITUDE]))"
                        }
                        else {
                            
                            aCurrentLatitude = "\(String(describing: self.myFavDestMutableDictionary[K_FAVORITE_LATITUDE]))"
                            aCurrentLongitude = "\(String(describing: self.myFavDestMutableDictionary[K_FAVORITE_LATITUDE]))"
                        }
                    }
                    
                    aCurrentLatitude = replaceSingleOptionalValue(aString: aCurrentLatitude)
                    aCurrentLongitude = replaceSingleOptionalValue(aString: aCurrentLongitude)
                    aLatitude = replaceSingleOptionalValue(aString: aLatitude)
                    aLongitude = replaceSingleOptionalValue(aString: aLongitude)
                    
                    let alatitudeIndex = aCurrentLatitude.index(aCurrentLatitude.startIndex, offsetBy: 9)
                    let alongitudeIndex = aCurrentLongitude.index(aCurrentLongitude.startIndex, offsetBy: 9)
                    
                    let aNewCurrentLatitude = (aCurrentLatitude.substring(to:alatitudeIndex) as String)
                    let aNewCurrentLongitude = (aCurrentLongitude.substring(to:alongitudeIndex) as String)
                    
                    if aNewCurrentLatitude == aLatitude.substring(to: aLatitude.index(before: aLatitude.endIndex)) && aNewCurrentLongitude ==  aLongitude.substring(to: aLongitude.index(before: aLongitude.endIndex)) {
                        
                        self.myFavDestMutableDictionary[K_FAVORITE_ID] = aTag.favourite_type_id;
                        
                        self.myDestinationFavButton.isSelected = true
                        self.isFavDestination = true
                        self.gFavoriteDestinationIdString = aTag.favourite_type_id
                        self.myDestinationFavButton.isUserInteractionEnabled = true
                        self.mySourceFavButton.isUserInteractionEnabled = false
                    }
                }
            }
        }
        
    }
    
    //MARK: GMS AutoComplete
    
    func showGMSAutocompleteViewController() {
        
        // To change favorite id based on the field for delete action
        switch self.mySearchTypeEnum {
            
        case .SEARCH_TYPE_SOURCE:
            
            mySourceFavButton.isSelected = isFavSource
            mySourceFavButton.isHidden = false
            myDestinationFavButton.isUserInteractionEnabled = false
            mySourceFavButton.isUserInteractionEnabled = true
            
        default:
            
            myDestinationFavButton.isSelected = isFavDestination
            myDestinationFavButton.isHidden = false
            mySourceFavButton.isUserInteractionEnabled = false
            myDestinationFavButton.isUserInteractionEnabled = true
        }
        
        
        let aViewController =  storyboard?.instantiateViewController(withIdentifier: "LUFavouriteSearchViewController") as! LUFavouriteSearchViewController!
        aViewController?.gLocationCoordinate = (self.myMapView.myLocation?.coordinate)!
        aViewController?.gDelegate = self
        aViewController?.isFromSwiftDasbordScreen = true
        
        /*     aViewController?.callBackBlock = {
         
         }as! (Bool, NSMutableArray?) -> Void
         */
        let aNavigationController = UINavigationController(rootViewController: aViewController!)
        self.navigationController?.present(aNavigationController, animated: true, completion: { _ in })
    }
    
    func getSelectedAddress(fromGMSList aMutableDict: NSMutableDictionary!, iscallBack: Bool) {
        
        if iscallBack {
            
            let aNewDict = aMutableDict
            
            if let aNewDict = aNewDict {
                
                print("aNewDict --- \(aNewDict)")
                
                
                self.isFavChanged = true
                
                // Do something with the selected place
                self.myLocationCoordinate = CLLocationCoordinate2DMake(CDouble(aNewDict[K_FAVORITE_LATITUDE] as! String)!, CDouble(aNewDict[K_FAVORITE_LONGITUDE] as! String)!)
                
                var aMutableDictionary : [String : Any] = [:]
                
                aMutableDictionary[K_FAVORITE_LATITUDE] = replaceSingleOptionalValue(aString: "\(String(describing: aNewDict[K_FAVORITE_LATITUDE]))")
                aMutableDictionary[K_FAVORITE_LONGITUDE] = replaceSingleOptionalValue(aString: "\(String(describing: aNewDict[K_FAVORITE_LONGITUDE]))")
                aMutableDictionary[K_FAVORITE_ADDRESS] = replaceSingleOptionalValue(aString: "\(String(describing: aNewDict[K_FAVORITE_ADDRESS]))")
                aMutableDictionary[K_FAVORITE_DISPLAY_NAME] = ""
                aMutableDictionary[K_FAVORITE_PRIMARY_LOCATION] = ""
                aMutableDictionary[K_FAVORITE_ID] = ""
                
                print("aMutableDictionary -- \(aMutableDictionary)")
                
                // To set current favorite feild date with myCurrentFavMutableDict
                self.myCurrentFavMutableDict[K_FAVORITE_LATITUDE] = replaceSingleOptionalValue(aString: "\(String(describing: aNewDict[K_FAVORITE_LATITUDE]))")
                self.myCurrentFavMutableDict[K_FAVORITE_LONGITUDE] = replaceSingleOptionalValue(aString: "\(String(describing: aNewDict[K_FAVORITE_LONGITUDE]))")
                self.myCurrentFavMutableDict[K_FAVORITE_ADDRESS] = replaceSingleOptionalValue(aString:  "\(String(describing: aNewDict[K_FAVORITE_ADDRESS]))")
                
                print("myCurrentFavMutableDict -- \(self.myCurrentFavMutableDict)")

                // Set text in textfield based on the search
                
                switch self.mySearchTypeEnum {
                    
                case .SEARCH_TYPE_SOURCE:
                    
                    self.myFavSourseMutableDictionary = aMutableDictionary
                    print("myFavSourseMutableDictionary -- \(self.myFavSourseMutableDictionary)")
                    

                    self.myDestinationFavButton.isHidden = true
                    self.mySourceFavButton.isHidden = false
                    
                    self.myDestinationFavButton.isUserInteractionEnabled = false
                    self.mySourceFavButton.isUserInteractionEnabled = true
                    
                    self.mySearchSourceView.isUserInteractionEnabled = true
                    self.mySearchDistinationView.isUserInteractionEnabled = false
                    self.mySearchSourceView.backgroundColor = UIColor.clear
                    self.mySearchDistinationView.backgroundColor = OBJ_HELPER?.getColorFromHexaDecimal(COLOR_GROUP_TABLE_VIEW)
                    
                    let aString : String = replaceSingleOptionalValue(aString: "\(String(describing: aNewDict[K_FAVORITE_ADDRESS]))")
                    print("astr --- \(aString)")

                    
                    self.mySearchSourceTextfield.text = aString
                    
                    self.gMapMutableInfo[0] = "\(self.myLocationCoordinate.latitude),\(self.myLocationCoordinate.longitude)"
                    
                default:
                    
                    self.myFavDestMutableDictionary = aMutableDictionary
                    print("myFavDestMutableDictionary -- \(self.myFavDestMutableDictionary)")

                    self.myDestinationFavButton.isHidden = false
                    self.mySourceFavButton.isHidden = true
                    
                    self.myDestinationFavButton.isUserInteractionEnabled = true
                    self.mySourceFavButton.isUserInteractionEnabled = false
                    
                    self.mySearchSourceView.isUserInteractionEnabled = false
                    self.mySearchDistinationView.isUserInteractionEnabled = true
                    self.mySearchDistinationView.backgroundColor = UIColor.clear
                    self.mySearchSourceView.backgroundColor = OBJ_HELPER?.getColorFromHexaDecimal(COLOR_GROUP_TABLE_VIEW)
                    
                    let aString : String = replaceSingleOptionalValue(aString: "\(String(describing: aNewDict[K_FAVORITE_ADDRESS]))")
                    print("adesstr --- \(aString)")
                    
                    self.mySearchDistinationTextfield.text = aString
                    
                    self.gMapMutableInfo[1] = "\(self.myLocationCoordinate.latitude),\(self.myLocationCoordinate.longitude)"
                }
            }
            self.isForFavLocation = true
            self.showLoadingActivityIndicator()
            self.getAddressFromLocation()
            
            DispatchQueue.main.asyncAfter(deadline:  .now() + 0.5, execute: {
                
                self.zoomToLocation()
            })
            
            self.getFareEstimation()
            
        }
        else {
            
            switch self.mySearchTypeEnum {
                
            case .SEARCH_TYPE_SOURCE:
                
                if (self.mySearchSourceTextfield.text?.characters.count)! > 0 {
                    
                    self.mySourceFavButton.isSelected = self.isFavSource
                    self.mySourceFavButton.isHidden = false
                    self.myDestinationFavButton.isUserInteractionEnabled = false
                    self.mySourceFavButton.isUserInteractionEnabled = true
                }
                else {
                    
                    self.mySourceFavButton.isHidden = true
                }
                
            default:
                
                if (self.mySearchDistinationTextfield.text?.characters.count)! > 0 {
                    
                    self.myDestinationFavButton.isSelected = self.isFavDestination
                    self.myDestinationFavButton.isHidden = false
                    self.myDestinationFavButton.isUserInteractionEnabled = true
                    self.mySourceFavButton.isUserInteractionEnabled = false
                }
                else {
                    
                    self.myDestinationFavButton.isHidden = false
                }
            }
        }
    }

    // MARK: UIButton methods -
    
    func leftBarButtonTapEvent() {
        
        if self.mySearchSourceTextfield.text?.characters.count == 0 {
            
            mySearchSourceTextfield.text = "\(mySearchMutableInfo[0])"
        }
            
        else if self.mySearchDistinationTextfield.text?.characters.count == 0 {
            
            mySearchSourceTextfield.text = "\(mySearchMutableInfo[1])"
        }
        
        if OBJ_SESSION?.isRequested() == true && isRequestStarted == true {
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATION_VIEW_UPADTE_BASED_ON_CHAT_STATUS), object: nil)
            
            SWIFT_APPDELEGATE.sideMenu.toggle(MMDrawerSide.left, animated: true, completion: {(_ finished: Bool) -> Void in
                
                let aMutableArray = NSMutableArray()
                aMutableArray.add(self.mySearchSourceTextfield.text as Any)
                aMutableArray.add(self.mySearchDistinationTextfield.text as Any)
                aMutableArray.add((self.isFavSource) ? "1" : "0")
                aMutableArray.add((self.isFavDestination) ? "1" : "0")
                aMutableArray.add(self.gMapMutableInfo[0])
                aMutableArray.add(self.gMapMutableInfo[1])
                OBJ_SESSION?.setSearchInfo(aMutableArray)
            })
        }
            
        else {
            
            isRequestDeclined = false
            myTimer.invalidate()
            myRequestDeclinedInteger = 0
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {() -> Void in
                
                if self.mySignalRConnectionMutableArray.count > 0 {
                    
                    self.goOffline()
                }
                OBJ_SESSION?.setChatInfo(NSMutableArray())
                self.myHubProxyConnection.stop()

            })
            
            var aMutableArray = [Any]()
            aMutableArray.append("\(String(describing: mySearchSourceTextfield.text))")
            aMutableArray.append("\(String(describing: mySearchDistinationTextfield.text))")
            aMutableArray.append((isFavSource) ? "1" : "0")
            aMutableArray.append((isFavDestination) ? "1" : "0")
            aMutableArray.append(gMapMutableInfo[0])
            aMutableArray.append(gMapMutableInfo[1])
            OBJ_SESSION?.setSearchInfo(NSMutableArray())
            hideRequestLoadingView()
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func popUpBidButtonTapped(_ sender: Any) {
        
        if (self.myBidAmountTextfield.text?.characters.count)! == 0 {
            
            myBidAmountAlert.text = "Please enter your Bid amount"
            myBidAmountAlert.textColor = UIColor.red
            
            OBJ_HELPER?.shakeAnimation(for: myBidAmountAlert, callBack: {() -> Void in
                
                self.myBidAmountTextfield.becomeFirstResponder()
            })
            return
        }
            
       else if (Int(self.myBidAmountTextfield.text!)! < self.myEstimatedValue/2) {
            
            myBidAmountAlert.textColor = UIColor.red
            
            OBJ_HELPER?.shakeAnimation(for: myBidAmountAlert, callBack: {() -> Void in
                
                self.myBidAmountTextfield.becomeFirstResponder()
            })
            return
        }
            
        else {
            
            if myServiceTypeMutableArray.count < 0 {
                
                OBJ_HELPER?.showAlertView(self, title: APP_NAME, message: "Wait for a while! We are fetching your nearest vehicles")
                return
            }
            
            SWIFT_HELPER.fadeAnimationfor(view: myActivityIndicatorView, alpha: 0, duration: 0, delay: 0)
            
            SWIFT_HELPER.fadeAnimationfor(view: myBidBgView, alpha: 0, duration: 0, delay: 0)
            
            myRequestLoadingButton.isHidden = true
            myRequestCancelLabel.isHidden = true
            OBJ_SESSION?.setChatInfo(NSMutableArray())
            showRequestLoadingView()
            OBJ_SESSION?.isRequested(true)
            requestForRide()
        }
    }
    
    @IBAction func addAmountButtonTapped(_ sender: Any) {
        
        if myServiceTypeMutableArray.count > 0 {
            
            let aViewController = SWIFT_STORY_BOARD.instantiateViewController(withIdentifier: "LUFareEstimationViewController") as! LUFareEstimationViewController
            aViewController.mySourseString = mySearchSourceTextfield.text
            aViewController.myDestinationString = mySearchDistinationTextfield.text
            aViewController.gServiceTypeMutableArray = myServiceTypeMutableArray as! NSMutableArray
            aViewController.myServiceType = gServiceTag.service_type_name
            aViewController.gPeopleCountString = gServiceTag.vehicle_max_range
            navigationController?.pushViewController(aViewController, animated: true)
        }
    }
    
    @IBAction func addPromotionButton(_ sender: Any) {
        
        let aViewController = SWIFT_STORY_BOARD.instantiateViewController(withIdentifier: "LUFavouritePopViewController") as! LUFavouritePopViewController
        aViewController.modalPresentationStyle = .overCurrentContext
        aViewController.isForPromoCode = true
        
        aViewController.promoCodeCallBackBlock = {(_ isCallBack: Bool!, _ aString: String!, _ aProString: String!) -> Void in
            
            if isCallBack {
                
                self.myPromoCodeIdString = aString
                self.myPromotionLabel.text = aProString
            }
            } as! (Bool, String?, String?) -> Void
        
        // To present view controller on the top of all view controller with clear background
        SWIFT_APPDELEGATE.window?.rootViewController?.present(aViewController, animated: true, completion: {() -> Void in
        })
    }
    
    @IBAction func customerBidButtonTapped(_ sender: Any) {
        
        view.bringSubview(toFront: myBidBgView)
        SWIFT_HELPER.fadeAnimationfor(view: myActivityIndicatorView, alpha: 0, duration: 0, delay: 0)
        SWIFT_HELPER.fadeAnimationfor(view: myBidBgView, alpha: 1, duration: 0, delay: 0)
        SWIFT_HELPER.fadeAnimationfor(view: myRequestView, alpha: 0, duration: 0, delay: 0)
        
        SWIFT_HELPER.fadeAnimationfor(view: myCancelReasonView, alpha: 0, duration: 0, delay: 0)
        SWIFT_HELPER.fadeAnimationfor(view: myBidView, alpha: 1, duration: 0, delay: 0)
        
        myBidAmountTextfield.text = ""
        myBidBgView.isUserInteractionEnabled = true
        
        let aGesture = UITapGestureRecognizer(target: self, action: #selector(self.BidBgViewTapped))
        aGesture.numberOfTapsRequired = 1
        myBidBgView.addGestureRecognizer(aGesture)
    }
    
    func BidBgViewTapped() {
        
        if myBidAmountTextfield.isFirstResponder == true {
            
            myBidAmountTextfield.resignFirstResponder()
        }
        else {
            
            SWIFT_HELPER.fadeAnimationfor(view: myActivityIndicatorView, alpha: 0, duration: 0, delay: 0)
            SWIFT_HELPER.fadeAnimationfor(view: myBidBgView, alpha: 0, duration: 0, delay: 0)
        }
    }
    
    @IBAction func requestButtonTapped(_ sender: Any) {
        
        self.hideRequestLoadingView()
        
        if mySearchSourceTextfield.text?.characters.count == 0 {
            
            OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: "Please choose your from location")
            return
            
        }
        else if mySearchDistinationTextfield.text?.characters.count == 0 {
            
            OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: "Please choose your to location")
            
            return
        }
            
        else {
            if myServiceTypeMutableArray.count < 0 {
                
                OBJ_HELPER?.showAlertView(self, title: APP_NAME, message: "Wait for a while! We are fetching your nearest vehicles")
                return
            }
            
            SWIFT_HELPER.fadeAnimationfor(view: myActivityIndicatorView, alpha: 0, duration: 0, delay: 0)
            
            SWIFT_HELPER.fadeAnimationfor(view: myBidBgView, alpha: 0, duration: 0, delay: 0)
            
            myRequestLoadingButton.isHidden = true
            myRequestCancelLabel.isHidden = true
            OBJ_SESSION?.setChatInfo(NSMutableArray())
            showRequestLoadingView()
            OBJ_SESSION?.isRequested(true)
            requestForRide()
        }
    }
    @IBAction func messageButtonTapped(_ sender : Any) {
        
        let aViewController = SWIFT_STORY_BOARD.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        aViewController.gTripIdString = myTripIdString
        aViewController.gUserIdString = ""
        aViewController.gHub = self.myHubProxy
        aViewController.gHubConnection = self.myHubProxyConnection
        
        aViewController.callBackBlock = {(_ isCallBack: Bool! , _ isreqUestCancel: Bool!)-> Void in
            
            if isCallBack {
                
                self.setUpSignalR()
            }
            
            if isreqUestCancel {
                
                SWIFT_NAVIGATION?.setTitleWithBarButtonItems(self.gServiceTag.service_type_name, for: self, showLeftBarButton: IMAGE_BACK, showRightBarButton: nil)
                let aServiceType = self.gServiceTag.service_type_name.characters.count > 0 ? self.gServiceTag.service_type_name : ""
                // To set navigation bar to present with navigation
                self.mySubmitButton.setTitle(TWO_STRING(string1: "Request for", string2: aServiceType!), for: .normal)
                if self.isForOnGoingRequest == true {
                    
                    var aMutableArray = [Any]()
                    aMutableArray.append(self.mySearchSourceTextfield.text as Any)
                    aMutableArray.append(self.mySearchDistinationTextfield.text as Any)
                    aMutableArray.append((self.isFavSource) ? "1" : "0")
                    aMutableArray.append((self.isFavDestination) ? "1" : "0")
                    aMutableArray.append(self.gMapMutableInfo[0])
                    aMutableArray.append(self.gMapMutableInfo[1])
                    OBJ_SESSION?.setSearchInfo(aMutableArray as! NSMutableArray)
                    
                    OBJ_SESSION?.isRequested(false)
                    OBJ_HELPER?.navigateToMenuDetailScreen()
                }
                    
                else {
                    
                    SWIFT_HELPER.fadeAnimationfor(view: self.myActivityIndicatorView, alpha: 0, duration: 0, delay: 0)
                    SWIFT_HELPER.fadeAnimationfor(view: self.myBidBgView, alpha: 0, duration: 0, delay: 0)
                    SWIFT_HELPER.fadeAnimationfor(view: self.myRequestView, alpha: 0, duration: 0, delay: 0)
                    SWIFT_HELPER.fadeAnimationfor(view: self.myBidView, alpha: 1, duration: 0, delay: 0)
                    
                    self.myRequestButtonHeightConstraint.constant = 45
                    self.hideRequestLoadingView()
                    self.isInChatScreen = false
                }
            }
        }
        
        myNearestTripTimer.invalidate()
        isInChatScreen = true
        let aNavigationController = UINavigationController(rootViewController: aViewController)
        self.navigationController?.present(aNavigationController, animated: true, completion: nil)
    }
    
    @IBAction func callButtonTapped(_ sender : Any) {
        
        let canCall: Bool = (OBJ_HELPER?.call(toNumber: myMobileNumberString))!
        
        if (!canCall) {
            
            OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: "No SIM card present")
        }
    }
    
    @IBAction func cancelRequestButtonTapped(_ sender : Any) {
        
        SWIFT_HELPER.fadeAnimationfor(view: myCancelReasonView, alpha: 0, duration: 0, delay: 0)
        SWIFT_HELPER.fadeAnimationfor(view: myBidBgView, alpha: 0, duration: 0, delay: 0)
        SWIFT_HELPER.fadeAnimationfor(view: myRequestLoadingView, alpha: 0, duration: 0, delay: 0)
        SWIFT_NAVIGATION?.setTitleWithBarButtonItems(gServiceTag.service_type_name, for: self, showLeftBarButton: IMAGE_BACK, showRightBarButton: nil)
        
        // This is to set request in bidding (or) normal requesst
        myBidAmountString = ""
        myBidAmountTextfield.text = ""
        
        myTripStatusIdInteger = SR_TRIP_BEFORE_CANCEL
        
        cancelTrip()
    }
    
    @IBAction func favSourceButtonTapped(_ sender: Any) {
        
        if isFavSource == true {
            
            callDeleteWebService()
        }
        else {
            
            addOrDeletebasedOnTheButtonStatus(aBoolValue: true)
        }
    }
    
    @IBAction func favDescButtonTapped(_ sender: Any) {
        
        if isFavDestination == true {
            
            callDeleteWebService()
        }
        else {
            
            addOrDeletebasedOnTheButtonStatus(aBoolValue: true)
        }
    }
    
    //MARK: Map View Delegate Methods
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            
            let aLocation: CLLocation? = locations[0]
            
            // This is method is getting called as soon as screen is loaded but the lat lng is incorrect, its not user location so below code is a workaround
            if aLocation?.coordinate.longitude == -40.0 {
                
                return
            }
            
            manager.stopUpdatingLocation()
            
            isForFavLocation = true
            
            if isLocationUpdated == false {
             
                isLocationUpdated = true
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {() -> Void in
                    
                    self.getAddressFromLocation()
                    self.zoomToLocation()
                    OBJ_HELPER?.removeLoading(in:self)
                })
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        isLocationUpdated = false
        manager.stopUpdatingLocation()
        hideLoadingActivityIndicator()
        
        
        OBJ_HELPER?.removeLoading(in: self)
        
        OBJ_HELPER?.showRetryAlert(in: self, details: ALERT_UNABLE_TO_FETCH_LOCATION_DICT , retry: {
            
            OBJ_HELPER?.showLoading(in: self, text: "Fetching your location")
            OBJ_HELPER?.removeRetryAlert(in: self)
            
            manager.startUpdatingLocation()
        })
    }
    
    //MARK: Web Service
    
    func callDeleteWebService() {
        
        // http://192.168.0.48/PPTCustomer/API/CustomerFavourites/DeleteFavourites?StrJson={"Favourites_Info":{"Fav_Id":"11","Customer_Id":"49"} }
        
        if OBJ_HELPER?.networkRechableForSwiftClass() == false {
            
            var aDictAlert = [AnyHashable: Any]()
            
            aDictAlert[KEY_ALERT_TITLE] = SCREEN_TITLE_DASHBOARD
            aDictAlert[KEY_ALERT_DESC] = "\(ALERT_NO_INTERNET). Tap to try again"
            aDictAlert[KEY_ALERT_IMAGE] = "icon_no_internet"
            
            // List is empty so show 'Tap to retry' view
            OBJ_HELPER?.showRetryAlert(in: self, details: aDictAlert, retry: {() -> Void in

                if OBJ_HELPER?.networkRechableForSwiftClass() == true {
                    
                    OBJ_HELPER?.removeRetryAlert(in: self)
                    OBJ_HELPER?.removeLoading(in: self)
                    self.callDeleteWebService()
                }
            })
            
            return
        }
        
        var aMutableDict: [String:Any] = [:]
        var aNewMutableDict: [String:Any] = [:]
        
        var string : String
        
        switch mySearchTypeEnum {

        case .SEARCH_TYPE_SOURCE:

            aMutableDict[K_FAVORITE_ID] =  gfavoriteIdString
            
        default:
            
            aMutableDict[K_FAVORITE_ID] =  gFavoriteDestinationIdString
        }
        
        aMutableDict[K_CUSTOMER_ID] = (OBJ_SESSION?.getUserInfo()[0] as AnyObject!)[K_CUSTOMER_ID]!
        print(aMutableDict as! NSMutableDictionary)
        
        aNewMutableDict["Favourites_Info"] = aMutableDict as! NSMutableDictionary
        print(aNewMutableDict as! NSMutableDictionary)
        
        OBJ_HELPER?.showLoading(in: self)
        let aCaseString : String! = SWIFT_WEB_SERVICE_URL + CASE_DELETE_FAVORITE_LIST
        
        NotificationCenter.default.addObserver(self, selector: #selector(DashBoardRequestViewController.updateFavourites), name: NSNotification.Name(rawValue: NOTIFICATION_VIEW_UPADTE_FAV_DELETED), object: nil)
        
        OBJ_HELPER?.favDeleteRequestHandler(aNewMutableDict as! NSMutableDictionary, withAPI: aCaseString, andFavPrimaryLoc: myFavoritePrimaryLocation)
    }
    
    func updateFavourites(notification:NSNotification){
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATION_VIEW_UPADTE_FAV_DELETED), object: nil)
        
        let dictionary = notification.userInfo
        
        if ((dictionary?.count) != nil) {
            
            switch self.mySearchTypeEnum {
                
            case .SEARCH_TYPE_SOURCE:
                
                self.isFavSource = false
                self.mySourceFavButton.isSelected = self.isFavSource
                self.myDestinationFavButton.isUserInteractionEnabled = false
                self.mySourceFavButton.isUserInteractionEnabled = true
                
            default:
                
                self.isFavDestination = false
                self.myDestinationFavButton.isSelected = self.isFavDestination
                self.mySourceFavButton.isUserInteractionEnabled = false
                self.myDestinationFavButton.isUserInteractionEnabled = true
            }
        }
        else {
            
            OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: MESSAGE_SOMETHING_WENT_WRONG)
        }
        
        OBJ_HELPER?.removeLoading(in: self)
    }
    
    func fetchPolylinewithCompletionHandler (completionHandler: @escaping (_ aGMSPolyline: GMSPolyline) -> Void, failedBlock: @escaping (_ error: Error?) -> Void) {
        
        if  OBJ_HELPER?.networkRechableForSwiftClass() == false {
            
            var aDictAlert = [AnyHashable: Any]()
            aDictAlert[KEY_ALERT_TITLE] = SCREEN_TITLE_DASHBOARD
            aDictAlert[KEY_ALERT_DESC] = "\(ALERT_NO_INTERNET). Tap to try again"
            aDictAlert[KEY_ALERT_IMAGE] = "icon_no_internet"
            
            // List is empty so show 'Tap to retry' view
            
            OBJ_HELPER?.showRetryAlert(in: self, details: aDictAlert, retry: {() -> Void in
                
                if  OBJ_HELPER?.networkRechableForSwiftClass() == true {
                    
                    OBJ_HELPER?.removeRetryAlert(in: self)
                    OBJ_HELPER?.removeLoading(in: self)
                    
                    
                    self.fetchPolylinewithCompletionHandler(completionHandler: {(_ aGMSPolyline: GMSPolyline) -> Void in
                        
                        // To draw a Route
                        self.myRoutePolyLine = aGMSPolyline
                        self.myRoutePolyLine?.strokeColor = UIColor.red
                        self.myRoutePolyLine?.strokeWidth = 2.0
                        self.myRoutePolyLine?.map = self.myMapView
                        
                    }, failedBlock: {(_ error: Error?) -> Void in
                        
                    })
                    self.myMapView.reloadInputViews()
                }
            })
            return
        }
        
        let directionsUrl = URL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\((gMapMutableInfo[0].components(separatedBy: ",")[0])),\((gMapMutableInfo[0].components(separatedBy: ",")[1]))&destination=\((gMapMutableInfo[1].components(separatedBy: ",")[0])),\((gMapMutableInfo[1].components(separatedBy: ",")[1]))&sensor=false&mode=driving")!
        
        let fetchDirectionsTask : URLSessionDataTask? =  URLSession.shared.dataTask(with: directionsUrl, completionHandler: { data, response, error in
            
            if let e = error {
                
                print(">>>>>> [URLDataTask completion]: \(e.localizedDescription)")
                return
            }
            
            if let data = data {
                
                if let json = JSON(data: data).dictionaryObject {
                    
                    var routesArray = json["routes"] as? [Any]
                    var polyline: GMSPolyline? = nil
                    
                    if (routesArray?.count)! > 0 {
                        
                        var routeDict: [AnyHashable: Any]? = (routesArray?[0] as? [AnyHashable: Any])
                        var routeOverviewPolyline: [AnyHashable: Any]? = (routeDict?["overview_polyline"] as? [AnyHashable: Any])
                        let points: String? = (routeOverviewPolyline?["points"] as? String)
                        
                        DispatchQueue.main.async(execute: {() -> Void in
                            
                            let path = GMSPath.init(fromEncodedPath: points!)
                            polyline = GMSPolyline(path: path)
                            print("polyline \(String(describing: polyline))")
                            completionHandler(polyline!)
                        })
                    }
                    
                }
                else {
                    
                }
            }
            else {
                
            }
        })
        fetchDirectionsTask?.resume()
    }
    
    func fetchPolylineFromDriverLocationWithCompletionHandler(completionHandler: @escaping (_ aGMSPolyline: GMSPolyline)-> Void, failurBlock: @escaping (_ error: Error?) -> Void) {
        
        if OBJ_HELPER?.networkRechableForSwiftClass() == false {
            
            var aDictAlert = [AnyHashable: Any]()
            aDictAlert[KEY_ALERT_TITLE] = SCREEN_TITLE_DASHBOARD
            aDictAlert[KEY_ALERT_DESC] = "\(ALERT_NO_INTERNET). Tap to try again"
            aDictAlert[KEY_ALERT_IMAGE] = "icon_no_internet"
            
            // List is empty so show 'Tap to retry' view
            
            OBJ_HELPER?.showRetryAlert(in: self, details: aDictAlert, retry: {() -> Void in
                
                if true {
                    
                    OBJ_HELPER?.removeRetryAlert(in: self)
                    OBJ_HELPER?.removeLoading(in: self)
                    
                    
                    self.fetchPolylineFromDriverLocationWithCompletionHandler(completionHandler: {(_ aGMSPolyline: GMSPolyline) -> Void in
                        
                        // To draw a Route
                        self.myRoutePolyLine = aGMSPolyline
                        self.myRoutePolyLine?.strokeColor = UIColor.red
                        self.myRoutePolyLine?.strokeWidth = 2.0
                        self.myRoutePolyLine?.map = self.myMapView
                        
                    }, failurBlock: {(_ error: Error?) -> Void in
                        
                    })
                    
                    self.myMapView.reloadInputViews()
                }
            })
            return
        }
        
        let directionsUrl = URL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\((myDriverRoutInfoMutableArray[0].components(separatedBy: ",")[0])),\((myDriverRoutInfoMutableArray[0].components(separatedBy: ",")[1]))&destination=\(myLocationCoordinate.latitude),\(myLocationCoordinate.longitude)&sensor=false&mode=driving")!
        
        let fetchDirectionsTask : URLSessionDataTask? =  URLSession.shared.dataTask(with: directionsUrl, completionHandler: { data, response, error in
            
            if let e = error {
                
                print(">>>>>> [URLDataTask completion]: \(e.localizedDescription)")
                return
            }
            
            if let data = data {
                
                if let json = JSON(data: data).dictionaryObject {
                    
                    let routes = json["routes"] as? [Any]
                    var polyline: GMSPolyline? = nil
                    
                    if (routes?.count)! > 0 {
                        
                        var routeDict: [AnyHashable: Any]? = (routes?[0] as? [AnyHashable: Any])
                        var routeOverviewPolyline: [AnyHashable: Any]? = (routeDict?["overview_polyline"] as? [AnyHashable: Any])
                        
                        let points: String? = (routeOverviewPolyline?["points"] as? String)
                        
                        DispatchQueue.main.async(execute: {() -> Void in
                            
                            let path = GMSPath.init(fromEncodedPath: points!)
                            polyline = GMSPolyline(path: path)
                            print("polyline \(String(describing: polyline))")
                            completionHandler(polyline!)
                        })
                    }
                    else {
                        
                    }
                }
                else {
                    
                }
            }
            else {
                
            }
        })
        
        fetchDirectionsTask?.resume()
    }
    
    //MARK: SignalR
    
    func setUpSignalR() {
        
        myHubProxyConnection = SignalR(vHUB_URL)
        myHubProxyConnection.transport = .longPolling
        myHubProxy = Hub(vHUB_PROXY)
        myHubProxyConnection.addHub(myHubProxy)
        myHubProxyConnection.queryString = ["foo": "bar"]
        myHubProxyConnection.headers = ["X-MyHeader1": "Value1", "X-MyHeader2": "Value2"]

        
        initHubListeners()
        myHubProxyConnection.start()
        isSignalRSetUp = true
        
        
        // On Methods
        
        myHubProxy.on("receiveTripStatus") { args in
            
            let message = args![0] as! String
            self.changeStatusBasedOnRequest(aMessage: message)
        }
        
        myHubProxy.on("receiveTripId") { args in
            
            let message = args![0] as! String
            self.getTripId(aMessage: message)
        }
        
        myHubProxy.on("receiveCancelTrip") { args in
            
            let message = args![0] as! String
            self.receiveCancelTrip(aMessage: message)
        }
        myHubProxy.on("receiveChatMessage") { args in
            
            let message = args![0] as! String
            self.receiveChatMessage(aMessage: message)
        }
        myHubProxy.on("receiveDriverLocation") { args in
            
            let message = args![0] as! String
            self.receiveDriverLocation(aMessage: message)
        }
        
        DispatchQueue.main.asyncAfter(deadline:  .now() + 15, execute: {
            
            if OBJ_SESSION?.isRequested() == true && self.isRequestStarted == false {
                
                self.getOnGoingRequest()
            }
            
            self.myNearestTripTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.getNearestVehiclesList), userInfo: nil, repeats: true)
        })
        
    }
    func initHubListeners(){
        
        // SignalR events
        
        myHubProxyConnection.starting = { [weak self] in
            
            print("Starting...")
        }
        
        myHubProxyConnection.reconnecting = { [weak self] in
            print("Reconnecting...")
        }
        
        myHubProxyConnection.connected = { [weak self] in
            
            if self?.myHubProxyConnection.connectionID?.characters.count != 0 {
                
                do {
                    
                    try self?.myHubProxy.invoke(SR_GO_ONLINE, arguments: [self!.replaceOptionalValue(aString: "\((OBJ_SESSION?.getUserInfo()[0] as AnyObject!)[K_CUSTOMER_ID])") ,SR_CUSTOMER_TYPE]) { (result, error) in
                        
                        
                        if result != nil {
                            
                            let message = String(describing: result as! String)
                            let json = JSON(data: message .data(using: .utf8)!).dictionaryValue
                            
                            if  json[kRESPONSE]?[kRESPONSE_CODE].intValue == kSUCCESS_CODE {
                                
                                self?.mySignalRConnectionMutableArray = [Any]() as! [[String : Any]]
                                self?.mySignalRConnectionMutableArray = (json["Connection_Info"]?.arrayValue)!
                                
                                DispatchQueue.main.asyncAfter(deadline:  .now(), execute: {
                                    
                                    if (self?.gMapMutableInfo.count)! > 0 || (self?.myMapLatLongMutableArray.count)! > 0 {
                                        
                                        self?.getFareEstimation()
                                    }
                                })
                                
                            }
                            else if json[kRESPONSE]?[kRESPONSE_CODE].intValue == K_NO_DATA_CODE || json[kRESPONSE]?[kRESPONSE_CODE].intValue == K_NO_DATA_CODE {
                                
                                OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: json[kRESPONSE]?[kRESPONSE_MESSAGE].stringValue)
                            }
                            else {
                                
                                OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: json[kRESPONSE]?[kRESPONSE_MESSAGE].stringValue)
                            }
                        }
                        else {
                            
                            OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: MESSAGE_SOMETHING_WENT_WRONG)
                        }
                    }
                }
                catch {
                    print(error)
                }
            }
        }
        
        myHubProxyConnection.reconnected = { [weak self] in
            print("Reconnected. Connection ID: \(String(describing: self?.myHubProxyConnection.connectionID!))")
        }
        
        myHubProxyConnection.disconnected = { [weak self] in
            print("Disconnected.")
        }
        
        myHubProxyConnection.connectionSlow = { print("Connection slow...") }
        
        myHubProxyConnection.error = { [weak self] error in
            print("Error: \(String(describing: error))")
            
            if let source = error?["source"] as? String , source == "TimeoutException" {
                print("Connection timed out. Restarting...")

                self?.myHubProxyConnection.start()
                
            }
        }
    }
    
    
    func getOnGoingRequest() {
        
        do {
          
            print("OnGoinGRequestArray")
            print([replaceOptionalValue(aString: "\((OBJ_SESSION?.getUserInfo()[0] as AnyObject!)[K_CUSTOMER_ID])"),SR_CUSTOMER_TYPE])
            
            try myHubProxy.invoke(SR_GET_ON_GOING_REQUEST, arguments: [replaceOptionalValue(aString: "\((OBJ_SESSION?.getUserInfo()[0] as AnyObject!)[K_CUSTOMER_ID])"),SR_CUSTOMER_TYPE], callback: { (result, error) in
                
                
                if result != nil {
                    
                    let message = String(describing: result as! String)
                    
                    let aResponseString = self.encodeJSONResponse(response: message)
                    let aJsonResponse = try? JSON(data: aResponseString.data(using: .utf8)!)
                    
                    if  aJsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == kSUCCESS_CODE {
                        
                        SWIFT_HELPER.fadeAnimationfor(view: self.myOnGoingLoadingView, alpha: 0.0, duration: 0.0, delay: 0)
                        self.progressRing?.animationDidStop(.init(), finished: true)

                        if self.isInChatScreen == true {
                            
                            self.dismiss(animated: true, completion: nil)
                        }
                        self.isRequestStarted = true
                        self.isForOnGoingRequest = true
                        self.myTripStatusIdInteger = (aJsonResponse?["Trip_Info"][SR_TRIP_STATUS_ID].intValue)!
                        
                        self.isLocationUpdated = false

                        if self.myTripStatusIdInteger != 8 {
                            
                            if let data = aJsonResponse {
                                
                                let dictionary = data["Trip_Info"]["Ride_Response"].dictionaryObject!
                                
                                let  aMutableDict = dictionary as? Dictionary<String,Any>
                                
                                if let aMutableDict = aMutableDict {
                                    
                                    print("dict , \(aMutableDict)")
                                    
                                    self.myTripIdString = aMutableDict["Request_Id"] as! String
                                    
                                    if self.gServiceTag == nil {
                                        
                                        self.gServiceTag = TagServiceType()
                                        self.gServiceTag.service_type_name = aMutableDict["Service_Name"] as! String
                                        self.gServiceTag.service_type_id = aMutableDict["Service_Id"] as! String
                                    }
                                    
                                    if self.myTripIdString.characters.count != 0 {
                                        
                                        self.getAllChatList()
                                        self.myRequestLoadingButton.isHidden = false
                                        self.myRequestCancelLabel.isHidden = false
                                    }
                                    
                                    self.myCancelCharge = data["Trip_Info"]["Cancellation_Msg"].stringValue
                                    OBJ_SESSION?.isAlertShown(false)
                                    
                                    if (aMutableDict.count > 0) {
                                        
                                        self.myRideResponseMutableArray.append(aMutableDict)
                                    }
                                }
                                else {
                                    print("error")
                                }
                                
                            }
                            
                            if (self.myRideResponseMutableArray.count != 0) {
                                
                                self.setUpNavigationBarWithCancelButton()
                                
                                let aServiceType = self.gServiceTag.service_type_name.characters.count > 0 ? self.gServiceTag.service_type_name : ""
                                // To set navigation bar to present with navigation
                                self.mySubmitButton.setTitle(TWO_STRING(string1: "Request for", string2: aServiceType!), for: .normal)
                                
                                self.gMapMutableInfo.append("\(String(describing: self.myRideResponseMutableArray[0]["From_Longitude"])),\(String(describing: self.myRideResponseMutableArray[0]["From_Latitude"]))")
                                self.gMapMutableInfo.append("\(String(describing: self.myRideResponseMutableArray[0]["To_Longitude"])),\(String(describing: self.myRideResponseMutableArray[0]["To_Latitude"]))")
                                
                                self.mySearchSourceTextfield.text = self.myRideResponseMutableArray[0]["From_Location"] as? String
                                self.mySearchDistinationTextfield.text = self.myRideResponseMutableArray[0]["To_Location"] as? String
                                
                                var aLocationArray: [Any] = self.gMapMutableInfo[0].components(separatedBy: ",")
                                
                                if aLocationArray.count == 2 {
                                    
                                    self.myCurrentFavMutableDict[K_FAVORITE_LATITUDE] = aLocationArray[0]
                                    self.myCurrentFavMutableDict[K_FAVORITE_LONGITUDE] = aLocationArray[1]
                                }
                                self.setFavoriteBasedOnSelectedAddress(aMutableDict: [String : Any]())
                                self.setUpMapView()
                            }
                            
                            let dic = [NOTIFICATION_REQUEST_STATUS_KEY : result]
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_VIEW_UPADTE_BASED_ON_REQUEST_STATUS), object: nil, userInfo:(dic as Any as! [AnyHashable : Any]))
                            
                            self.hideRequestLoadingView()
                            
                            if self.myTripStatusIdInteger == SR_TRIP_REQUEST {
                                
                                SWIFT_HELPER.fadeAnimationfor(view: self.myBidBgView, alpha: 0, duration: 0, delay: 0)
                                SWIFT_HELPER.fadeAnimationfor(view: self.myBgView, alpha: 1, duration: 0, delay: 0)
                                SWIFT_HELPER.fadeAnimationfor(view: self.myActivityIndicatorView , alpha: 0, duration: 0, delay: 0)
                                SWIFT_HELPER.fadeAnimationfor(view: self.myRequestView , alpha: 0, duration: 0, delay: 0)
                                
                                self.myRequestButtonHeightConstraint.constant = 45
                                OBJ_SESSION?.setChatInfo(NSMutableArray())
                                self.isRequestStarted = true
                                self.showRequestLoadingView()
                                OBJ_SESSION?.isAlertShown(true)
                                self.addCarLocation()
                            }
                                
                            else if self.myTripStatusIdInteger == -1 {
                                
                                self.changeViewBasedOnRide()
                                OBJ_SESSION?.isAlertShown(true)
                                OBJ_SESSION?.isRequested(false)
                                OBJ_HELPER?.navigateToMenuDetailScreen()
                            }
                                
                            else if self.myTripStatusIdInteger == SR_TRIP_BEFORE_CANCEL || self.myTripStatusIdInteger == SR_TRIP_AFTER_CANCEL {
                                
                                SWIFT_HELPER.showAlertView(self, title: SCREEN_TITLE_DASHBOARD, message: (aJsonResponse?["Trip_Info"]["Trip_Status_Message"].stringValue)!, okButtonBlock: { (_ action : UIAlertAction) in
                                    
                                    self.changeViewBasedOnRide()
                                    OBJ_SESSION?.isAlertShown(true)
                                    OBJ_SESSION?.isRequested(false)
                                    OBJ_HELPER?.navigateToMenuDetailScreen()
                                    
                                })
                            }
                            else if self.myTripStatusIdInteger == SR_TRIP_ACCEPTED {
                                
                                self.myNearestTripTimer.invalidate()
                                
                                SWIFT_NAVIGATION?.setTitleWithBarButtonItems("Trip Confirmed", for: self, showLeftBarButton: IMAGE_MENU, showRightBarButton: nil)
                                OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: (aJsonResponse?["Trip_Info"]["Trip_Status_Message"].stringValue)!)
                                
                                self.mySearchView.isUserInteractionEnabled = false
                                self.mySourceFavButton.isHidden = true
                                self.myDestinationFavButton.isHidden = true
                                
                                // Change view Based On ride response
                                SWIFT_HELPER.fadeAnimationfor(view: self.myCancelView, alpha: 1, duration: 0, delay: 0)
                                SWIFT_HELPER.fadeAnimationfor(view: self.myCallButton , alpha: 1, duration: 0, delay: 0)
                                SWIFT_HELPER.fadeAnimationfor(view: self.myMessageButton , alpha: 1, duration: 0, delay: 0)
                                
                                self.changeViewBasedOnRide()
                                OBJ_SESSION?.isAlertShown(true)
                            }
                                
                            else if self.myTripStatusIdInteger == SR_TRIP_ARRIVED {
                                
                                self.myNearestTripTimer.invalidate()
                                if self.gMapMutableInfo.count != 0  {
                                    
                                    self.addLocationAnddrawRoute()
                                    self.zoomToLocation()
                                }
                                
                                self.mySearchView.isUserInteractionEnabled = false
                                self.mySourceFavButton.isHidden = true
                                self.myDestinationFavButton.isHidden = true
                                
                                SWIFT_NAVIGATION?.setTitleWithBarButtonItems("Driver Arrived", for: self, showLeftBarButton: IMAGE_MENU, showRightBarButton: nil)
                                
                                OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: (aJsonResponse?["Trip_Info"]["Trip_Status_Message"].stringValue)!)
                                
                                // Change view Based On ride response
                                SWIFT_HELPER.fadeAnimationfor(view: self.myCancelView, alpha: 1, duration: 0, delay: 0)
                                SWIFT_HELPER.fadeAnimationfor(view: self.myCallButton , alpha: 1, duration: 0, delay: 0)
                                SWIFT_HELPER.fadeAnimationfor(view: self.myMessageButton , alpha: 1, duration: 0, delay: 0)
                                
                                OBJ_SESSION?.isAlertShown(true)
                            }
                            else {
                                
                                self.myNearestTripTimer.invalidate()
                                
                                if self.gMapMutableInfo.count != 0  {
                                    
                                    self.addLocationAnddrawRoute()
                                    self.zoomToLocation()
                                }
                                
                                // Change view Based On ride response
                                SWIFT_HELPER.fadeAnimationfor(view: self.myCancelView, alpha: 0, duration: 0, delay: 0)
                                SWIFT_HELPER.fadeAnimationfor(view: self.myCallButton , alpha: 0, duration: 0, delay: 0)
                                SWIFT_HELPER.fadeAnimationfor(view: self.myMessageButton , alpha: 0, duration: 0, delay: 0)
                                
                                self.mySearchView.isUserInteractionEnabled = false
                                self.mySourceFavButton.isHidden = true
                                self.myDestinationFavButton.isHidden = true
                                
                                self.changeViewBasedOnRide()
                                
                                if self.myTripStatusIdInteger == SR_TRIP_STARTED {
                                    
                                    SWIFT_NAVIGATION?.setTitleWithBarButtonItems("Trip Started", for: self, showLeftBarButton: IMAGE_MENU, showRightBarButton: nil)
                                    
                                    OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: (aJsonResponse?["Trip_Info"]["Trip_Status_Message"].stringValue)!)
                                    
                                    OBJ_SESSION?.isAlertShown(true)
                                }
                                else {
                                    
                                    SWIFT_NAVIGATION?.setTitleWithBarButtonItems("Trip Completed", for: self, showLeftBarButton: IMAGE_MENU, showRightBarButton: nil)
                                    
                                    SWIFT_HELPER.showAlertView(self, title: APP_NAME, message: (aJsonResponse?["Trip_Info"]["Trip_Status_Message"].stringValue)!, okButtonBlock: { (_ action : UIAlertAction) in
                                        
                                        var aMutableArray = [[String : Any]]()
                                        
                                        if let data = aJsonResponse {
                                            
                                            let dictionary = data["Trip_Info"]["Trip_Details"].dictionaryObject!
                                            
                                            let  aMutableDict = dictionary as? Dictionary<String,Any>
                                            
                                            if let aMutableDict = aMutableDict {
                                                
                                                print("dict , \(aMutableDict)")
                                                aMutableArray.append(aMutableDict)
                                            }
                                        }
                                        OBJ_SESSION?.isAlertShown(true)
                                        
                                        if aMutableArray.count != 0 {
                                            
                                            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: VIEW_UPADTE_BASED_ON_REQUEST_STATUS), object: nil)
                                            
                                            let aViewController: LUInvoiceViewController? = SWIFT_STORY_BOARD.instantiateViewController(withIdentifier: "LUInvoiceViewController") as? LUInvoiceViewController
                                            aViewController?.gInfoArray = NSMutableArray()
                                            aViewController?.gInfoArray = aMutableArray as! NSMutableArray
                                            aViewController?.gTripIdString = self.myTripIdString
                                            aViewController?.gUserIdString = self.replaceOptionalValue(aString: "\((OBJ_SESSION?.getUserInfo()[0] as AnyObject!)[K_CUSTOMER_ID])")
                                            aViewController?.myProfileUrl = self.myRideResponseMutableArray[0]["Driver_Image"] as! String
                                            self.navigationController?.pushViewController(aViewController!, animated: true)
                                        }
                                    })
                                }
                            }
                        }
                        else {
                            
                        }
                    }
                    else if aJsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == K_NO_DATA_CODE || aJsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == K_NO_DATA_CODE {
                        
                        OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: aJsonResponse?[kRESPONSE][kRESPONSE_MESSAGE].stringValue)
                    }
                    else {
                        
                        OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: aJsonResponse?[kRESPONSE][kRESPONSE_MESSAGE].stringValue)
                    }
                }
                    
                else {
                    
                    if (error as AnyObject).code == NSURLErrorTimedOut {
                        
                        OBJ_HELPER?.showRetryAlert(in: self, details: ALERT_NO_INTERNET_DICT, retry: {() -> Void in
                            
                            if OBJ_HELPER?.networkRechableForSwiftClass() == true {
                                
                                OBJ_HELPER?.showLoading(in: self)
                                OBJ_HELPER?.removeRetryAlert(in: self)
                                self.getOnGoingRequest()
                            }
                        })
                    }
                    else {
                        
                    }
                }
                OBJ_HELPER?.removeLoading(in:self)
            })
            
            
        }
        catch  {
        }
    }
    
    func getNearestVehiclesList() {
        
        if gMapMutableInfo.count > 0 {
            
            let aLatitude = (gMapMutableInfo[0] as AnyObject).components(separatedBy: ",")[0]
            let aLongitude = (gMapMutableInfo[0] as AnyObject).components(separatedBy: ",")[1]
            let aToLatitude = (gMapMutableInfo[1] as AnyObject).components(separatedBy: ",")[0]
            let aToLongitude = (gMapMutableInfo[1] as AnyObject).components(separatedBy: ",")[1]
            
            do{
                try myHubProxy.invoke(SR_GET_NEAREST_VEHICLE, arguments:[aLatitude,aLongitude,aToLatitude,aToLongitude,replaceOptionalValue(aString: "\((OBJ_SESSION?.getUserInfo()[0] as AnyObject!)[K_CUSTOMER_ID])"),gServiceTag.service_type_id] as [Any]
                    , callback: { (result, error) in
                        print("Nearesterror.debugDescription")
                        print(error.debugDescription)

                        if result != nil {
                            
                           // self.isLocationUpdated = false

                            let message = String(describing: result as! String)
                            let aResponseString = self.encodeJSONResponse(response: message)
                            let aJsonResponse = try? JSON(data: aResponseString.data(using: .utf8)!)
                            
                            if  aJsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == kSUCCESS_CODE {
                                
                                if let data = aJsonResponse {
                                    
                                    let aArray = data["Service_Types"].arrayObject!
                                    let adict = aArray as? Array<Any>
                                    
                                    if let adict = adict {
                                        self.myServiceLocationTypeMutableArray = [Dictionary<String, Any>]()
                                        self.myServiceLocationTypeMutableArray = adict as! [Dictionary<String, Any>]
                                    }
                                    
                                }
                                
                                if self.myServiceLocationTypeMutableArray.count != 0  {
                                    
                                    self.addCarLocation()
                                    self.mytimeLabel.text = self.myServiceLocationTypeMutableArray[0]["Estimation_Time"] as? String
                                }
                                self.myNearestVehicleResponseString = aJsonResponse?[kRESPONSE][kRESPONSE_MESSAGE].stringValue
                            }
                                
                            else if  aJsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == k_BAD_REQUEST ||  aJsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == K_NO_DATA_CODE {
                                
                                self.setUpMapView()
                                self.addLocationAnddrawRoute()
                            }
                            else {
                                
                            }
                            
                        }
                        else {
                            
                        }
                        
                })
                
            }
            catch{
                
            }
        }
    }
    
    func getFareEstimation(){
        
        let originString = (gMapMutableInfo[0] as AnyObject).components(separatedBy: ",")[0] + "," + (gMapMutableInfo[0] as AnyObject).components(separatedBy: ",")[1]
        let destinationString = (gMapMutableInfo[1] as AnyObject).components(separatedBy: ",")[0] + "," + (gMapMutableInfo[1] as AnyObject).components(separatedBy: ",")[1]
        var aLatitude = (gMapMutableInfo[0] as AnyObject).components(separatedBy: ",")[0]
        var aLongitude = (gMapMutableInfo[0] as AnyObject).components(separatedBy: ",")[1]
        var aToLatitude = (gMapMutableInfo[1] as AnyObject).components(separatedBy: ",")[0]
        var aToLongitude = (gMapMutableInfo[1] as AnyObject).components(separatedBy: ",")[1]
        
        var aArray = [Any]()
        
        if (originString == "\("0.000000"),\("0.000000")") || (destinationString == "\("0.000000"),\("0.000000")") {
            
            if myMapLatLongMutableArray.count != 0 {
                
                aLatitude = (myMapLatLongMutableArray[0] as AnyObject).components(separatedBy: ",")[0]
                aLongitude = (myMapLatLongMutableArray[0] as AnyObject).components(separatedBy: ",")[1]
                aToLatitude = (myMapLatLongMutableArray[1] as AnyObject).components(separatedBy: ",")[0]
                aToLongitude = (myMapLatLongMutableArray[1] as AnyObject).components(separatedBy: ",")[1]
                
                aArray = [aLatitude,aLongitude,aToLatitude,aToLongitude,replaceOptionalValue(aString: "\((OBJ_SESSION?.getUserInfo()[0] as AnyObject!)[K_CUSTOMER_ID])"),gServiceTag.service_type_id]
            }
                
            else {
                
                return
            }
            
        }
            
        else {
            
            aArray = [aLatitude,aLongitude,aToLatitude,aToLongitude,replaceOptionalValue(aString: "\((OBJ_SESSION?.getUserInfo()[0] as AnyObject!)[K_CUSTOMER_ID])"),gServiceTag.service_type_id]
        }
        
        do {
            try myHubProxy.invoke(SR_GET_FARE_ESTIMATION, arguments:aArray, callback: { (result, error) in
                
                print("Fare Estimation Array (aArray)")
                print(aArray)
                
                if result != nil {
                    
                    let message = String(describing: result as! String)
                    let aResponseString = self.encodeJSONResponse(response: message)
                    let aJsonResponse = try? JSON(data: aResponseString.data(using: .utf8)!)
                    print("Fare Estimate response\(aJsonResponse)")
                    
                    if  aJsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == kSUCCESS_CODE {
                        
                        if let data = aJsonResponse {
                            
                            let aArray = data["Service_Types"].arrayObject!
                            let adict = aArray as? Array<Any>
                            print(adict)
                            if let adict = adict {
                                self.myServiceTypeMutableArray    = [Dictionary<String, Any>]()
                                self.myServiceTypeMutableArray = adict as! [Dictionary<String, Any>]
                            }
                        }
                        
                        if self.myServiceTypeMutableArray.count > 0   {
                            
                            var aString = ""
                            if   self.myServiceTypeMutableArray[0]["Is_Fixed_Fare"] as! String == "0" {
                                
                                self.myAmountLabel.text = self.myServiceTypeMutableArray[0]["Estimation_Cost"] as? String
                                self.myEstimatedfare.text = self.myServiceTypeMutableArray[0]["Estimation_Cost"] as? String
                                
                                var atempString = (self.myServiceTypeMutableArray[0]["Estimation_Cost"] as! String)
                                let range = atempString.index(after: atempString.startIndex)..<atempString.endIndex
                                atempString = atempString[range]
                                aString = atempString.components(separatedBy: "-")[0]
                            }
                            else{
                                
                                self.myAmountLabel.text = self.myServiceTypeMutableArray[0]["Estimation_Cost"] as! String + "(fixed fare)"
                                self.myEstimatedfare.text = self.myServiceTypeMutableArray[0]["Estimation_Cost"] as! String + "(fixed fare)"
                                var atempString = (self.myServiceTypeMutableArray[0]["Estimation_Cost"] as! String)
                                let range = atempString.index(after: atempString.startIndex)..<atempString.endIndex
                                atempString = atempString[range]
                                aString = atempString.components(separatedBy: "-")[1]
                                
                            }
                            self.myEstimatedValue = (aString as NSString).integerValue
                        }
                        
                    }
                    else if aJsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == k_BAD_REQUEST || aJsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == K_NO_DATA_CODE {
                        
                        OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: aJsonResponse?[kRESPONSE][kRESPONSE_MESSAGE].stringValue)
                    }
                    else {
                        
                        OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: aJsonResponse?[kRESPONSE][kRESPONSE_MESSAGE].stringValue)
                    }
                    self.hideLoadingActivityIndicator()
                }
                else {
                    
                    if (error as AnyObject).code == NSURLErrorTimedOut {
                        
                        OBJ_HELPER?.showRetryAlert(in: self, details: ALERT_NO_INTERNET_DICT, retry: {
                            
                            if OBJ_HELPER?.networkRechableForSwiftClass() == true {
                                
                                OBJ_HELPER?.showLoading(in: self)
                                OBJ_HELPER?.removeRetryAlert(in: self)
                                self.getFareEstimation()
                            }
                        })
                    }
                    else {
                        
                    }
                }
                
            })
        }
        catch {
            
        }
        
    }
    
    func requestForRide() {
        
        self.view.endEditing(true)
        isRequestStarted = true
        
        let aLatitude = (gMapMutableInfo[0] as AnyObject).components(separatedBy: ",")[0]
        let aLongitude = (gMapMutableInfo[0] as AnyObject).components(separatedBy: ",")[1]
        let aToLatitude = (gMapMutableInfo[1] as AnyObject).components(separatedBy: ",")[0]
        let aToLongitude = (gMapMutableInfo[1] as AnyObject).components(separatedBy: ",")[1]
        var aArray = [Any]()
        
        aArray = [aLatitude,aLongitude,aToLatitude,aToLongitude,replaceOptionalValue(aString: "\((OBJ_SESSION?.getUserInfo()[0] as AnyObject!)[K_CUSTOMER_ID])"),gServiceTag.service_type_id,"",myBidAmountString, myPromoCodeIdString]
        print(aArray)
        
        mySubmitButton.isUserInteractionEnabled = false
        
        do{
            try myHubProxy.invoke(SR_REQUEST_RIDE, arguments: aArray
                , callback: { (result, error) in
                    
                    if result != nil {
                        
                        
                        let message = String(describing: result as! String)
                        
                        print(message)

                        let aResponseString = self.encodeJSONResponse(response: message)
                        let aJsonResponse = try? JSON(data: aResponseString.data(using: .utf8)!)
                        self.hideRequestLoadingView()
                        
                        if  aJsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == kSUCCESS_CODE {
                            
                            let dictionary = aJsonResponse?["Ride_Response"].dictionaryObject!
                            
                            let  aMutableDict = dictionary
                            
                            if aMutableDict != nil {
                           
                                
                            }
                            else {
                           
                                if ((aMutableDict?.count) != nil)  {
                                    
                                    self.myNearestTripTimer.invalidate()
                                    self.myRideResponseMutableArray = [Dictionary<String,Any> ()]
                                    self.myRideResponseMutableArray.append(aMutableDict!)
                                    self.myCancelCharge = (aMutableDict?["Cancellation_Msg"]) as! String!
                                }
                                
                                if self.myRideResponseMutableArray.count > 0 {
                                    
                                    let aSourseString = self.replaceOptionalValue(aString:"\((self.myRideResponseMutableArray[0] as AnyObject)[SR_FROM_LATITUDE])")
                                    
                                    let aDestString = self.replaceOptionalValue(aString:"\((self.myRideResponseMutableArray[0] as AnyObject)[SR_FROM_LONGITUDE])")
                                    
                                    let aToSourseString = self.replaceOptionalValue(aString:"\((self.myRideResponseMutableArray[0] as AnyObject)[SR_TO_LATITUDE])")
                                    
                                    let aToDestString = self.replaceOptionalValue(aString:"\((self.myRideResponseMutableArray[0] as AnyObject)[SR_TO_LONGITUDE])")
                                    
                                    self.gMapMutableInfo.append(("\(aSourseString),\(aDestString)"))
                                    self.gMapMutableInfo.append(("\(aToSourseString),\(aToDestString)"))
                                    
                                    print("gMapMutableInfo , \(self.gMapMutableInfo)")
                                    
                                    // Change view Based On ride response
                                    self.changeViewBasedOnRide()
                                    
                                    // The below method are done to clear the marker & add new marker with rout.
                                    self.myMapView.clear()
                                    self.addLocationAnddrawRoute()
                                    self.addCarLocation()
                                }
                            }
                        }
                            
                        else if  aJsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == k_BAD_REQUEST ||  aJsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == K_NO_DATA_CODE {
                            
                            if aJsonResponse?[kRESPONSE][kRESPONSE_MESSAGE].stringValue == "No car is available, Please try again later." {
                                self.isRequestDeclined = true
                                self.myTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateIntegerConut), userInfo: nil, repeats: true)
                            }
                            
                            OBJ_SESSION?.isRequested(false)
                            OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: aJsonResponse?[kRESPONSE][kRESPONSE_MESSAGE].stringValue)
                            
                        }
                        else {
                            
                            OBJ_SESSION?.isRequested(false)
                            OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: aJsonResponse?[kRESPONSE][kRESPONSE_MESSAGE].stringValue)
                        }
                    }
                    else {
                        
                        if error.debugDescription.characters.count > 0 {
                            
                        }
                        else {
                            
                            OBJ_HELPER?.showNotificationSuccess(in: self, withMessage:"Sorry! Unable to request at this time. Please try again")
                        }
                    }
                    
                    self.hideRequestLoadingView()
                    self.mySubmitButton.isUserInteractionEnabled = true
            })
        }
        catch{
            
        }
        
    }
    
    
    func cancelTrip() {
        
        self.mySubmitButton.isUserInteractionEnabled = false
        
        let userID = mySignalRConnectionMutableArray.count == 0 ? (mySignalRConnectionMutableArray[0] as AnyObject)[SR_USER_ID] as Any : self.replaceOptionalValue(aString: "\((OBJ_SESSION?.getUserInfo()[0] as AnyObject!)[K_CUSTOMER_ID])")
        
        do {
            
            try myHubProxy.invoke(SR_CANCEL_TRIP, arguments: [self.myTripIdString,userID,self.myCancelIdString,SR_CUSTOMER_TYPE], callback: { (result, error) in
                
                if result != nil {
                    
                    let message = String(describing: result as! String)
                    let aResponseString = self.encodeJSONResponse(response: message)
                    let aJsonResponse = try? JSON(data: aResponseString.data(using: .utf8)!)
                    
                    if  (aJsonResponse?.count)! > 0 {
                        
                        self.isCanceled = true
                        
                        SWIFT_HELPER.showAlertView(self, title: SCREEN_TITLE_DASHBOARD, message: (aJsonResponse?[kRESPONSE][kRESPONSE_MESSAGE].stringValue)!, okButtonBlock: { (_ action : UIAlertAction) in
                            
                            if self.isForOnGoingRequest == true {
                                
                                SWIFT_NAVIGATION?.setTitleWithBarButtonItems(self.gServiceTag.service_type_name, for: self, showLeftBarButton: IMAGE_BACK, showRightBarButton: nil)
                                
                                let aServiceType = self.gServiceTag.service_type_name.characters.count > 0 ? self.gServiceTag.service_type_name : ""
                                // To set navigation bar to present with navigation
                                self.mySubmitButton.setTitle(TWO_STRING(string1: "Request for", string2: aServiceType!), for: .normal)
                                
                                var aMutableArray = NSMutableArray()
                                aMutableArray.add(self.mySearchSourceTextfield.text as Any)
                                aMutableArray.add(self.mySearchDistinationTextfield.text as Any)
                                aMutableArray.add((self.isFavSource) ? "1" : "0")
                                aMutableArray.add((self.isFavDestination) ? "1" : "0")
                                aMutableArray.add(self.gMapMutableInfo[0])
                                aMutableArray.add(self.gMapMutableInfo[1])
                                OBJ_SESSION?.setSearchInfo(aMutableArray)
                                OBJ_SESSION?.isRequested(false)
                                OBJ_HELPER?.navigateToMenuDetailScreen()
                            }
                            else {
                                
                                SWIFT_NAVIGATION?.setTitleWithBarButtonItems(self.gServiceTag.service_type_name, for: self, showLeftBarButton: IMAGE_BACK, showRightBarButton: nil)
                            }
                            
                            SWIFT_HELPER.fadeAnimationfor(view: self.myBidBgView, alpha: 0, duration: 0, delay: 0)
                            SWIFT_HELPER.fadeAnimationfor(view: self.myActivityIndicatorView, alpha: 0, duration: 0, delay: 0)
                            SWIFT_HELPER.fadeAnimationfor(view: self.myRequestView, alpha: 0, duration: 0, delay: 0)
                            SWIFT_HELPER.fadeAnimationfor(view: self.myBgView, alpha: 1, duration: 0, delay: 0)
                            
                            self.myRequestButtonHeightConstraint.constant = 45
                            self.myNearestTripTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.getNearestVehiclesList), userInfo: nil, repeats: true)
                           
                            OBJ_SESSION?.isRequested(false)
                            
                            self.mySearchView.isUserInteractionEnabled = false
                            self.myCancelIdString = ""
                            self.isRequestStarted = false
                            
                            DispatchQueue.main.asyncAfter(deadline:  .now() + 0.5, execute: {
                                
                            self.addLocationAnddrawRoute()
                            self.zoomToLocation()
                            self.getFareEstimation()
                            })
                            
                        })
                        //})
                    }
                    
                    let aServiceType = self.gServiceTag.service_type_name.characters.count > 0 ? self.gServiceTag.service_type_name : ""
                    self.mySubmitButton.stopActivityIndicator(withResetTitle: "Request for \(aServiceType!)")
                    self.view.isUserInteractionEnabled = true
                    OBJ_HELPER?.removeLoading(in: self)
                    self.hideRequestLoadingView()
                    self.mySubmitButton.isUserInteractionEnabled = true
                }
                else {
                    
                    if error.debugDescription.characters.count > 0 {
                        
                        OBJ_HELPER?.showRetryAlert(in: self, details: ALERT_NO_INTERNET_DICT, retry: {
                            
                            
                            OBJ_HELPER?.showLoading(in: self)
                            OBJ_HELPER?.removeRetryAlert(in: self)
                            self.getFareEstimation()
                            
                        })
                    }
                    else {
                        
                        OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: MESSAGE_SOMETHING_WENT_WRONG)
                    }
                    let aServiceType = self.gServiceTag.service_type_name.characters.count > 0 ? self.gServiceTag.service_type_name : ""
                    self.mySubmitButton.stopActivityIndicator(withResetTitle: "Request for \(aServiceType!)")
                    self.view.isUserInteractionEnabled = true
                    OBJ_HELPER?.removeLoading(in: self)
                    self.mySubmitButton.isUserInteractionEnabled = true
                }
            })
        }
        catch {
            
        }
    }
    
    
    func goOffline() {
        
        do {
            
            try myHubProxy.invoke("GoOffline", arguments: [replaceOptionalValue(aString: "\((OBJ_SESSION?.getUserInfo()[0] as AnyObject!)[SR_USER_ID])"),SR_CUSTOMER_TYPE], callback: { (result, error) in
                
                if result != nil {
                    
                    let message = String(describing: result as! String)
                    
                    let aResponseString = self.encodeJSONResponse(response: message)
                    let aJsonResponse = try? JSON(data: aResponseString.data(using: .utf8)!)
                    
                    print("GoOffline %@",aResponseString)
                    
                    
                    if  aJsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == kSUCCESS_CODE || aJsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == K_NO_DATA_CODE {
                        
                    }
                        
                    else {
                        
                    }
                    
                    // OBJ_SESSION?.setChatInfo(NSMutableArray())
                    //self.myHubProxyConnection.stop()
                }
                else {
                    
                    if error.debugDescription.characters.count > 0 {
                        
                        OBJ_HELPER?.showRetryAlert(in: self, details: ALERT_NO_INTERNET_DICT, retry: {() -> Void in
                            
                            if OBJ_HELPER?.networkRechableForSwiftClass() == true {
                                
                                OBJ_HELPER?.showLoading(in: self)
                                OBJ_HELPER?.removeRetryAlert(in: self)
                                self.goOffline()
                            }
                        })
                    }
                    else {
                        OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: MESSAGE_SOMETHING_WENT_WRONG)
                    }
                }
            })
        }
        catch {
            
        }
    }
    
    func changeStatusBasedOnRequest( aMessage: String) {
        
        print(aMessage)
        
        if myOnGoingLoadingView.alpha == 0 {
            
            do {

                let aResponseString : String = self.encodeJSONResponse(response: aMessage)
                let aJsonResponse = try? JSON(data: aResponseString.data(using: .utf8)!)
                isLocationUpdated = false

                if  aJsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == kSUCCESS_CODE {
                    
                    if isRequestDeclined && myRequestDeclinedInteger < 30 {
                        
                        isRequestDeclined = false
                        myTimer.invalidate()
                        myRequestDeclinedInteger = 0
                        
                        SWIFT_HELPER.showAlertView(self, title: SCREEN_TITLE_DASHBOARD, message: "We value your request and we have allocated you with a special driver at the same cost who will reach you soon. \n Thank you!", okButtonBlock: { (_ action : UIAlertAction) in
                            
                            self.mySubmitButton.isUserInteractionEnabled = true
                            self.mySubmitButton.backgroundColor = UIColor.black
                            
                            if self.myRideResponseMutableArray.count > 0 {
                                
                                self.changeViewBasedOnRide()
                            }
                            OBJ_SESSION?.isAlertShown(false)
                            
                            let dic = [NOTIFICATION_REQUEST_STATUS_KEY : aJsonResponse]
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_VIEW_UPADTE_BASED_ON_REQUEST_STATUS), object: nil, userInfo:
                                (dic as Any as! [AnyHashable : Any]))
                            
                            self.myTripStatusIdInteger = (aJsonResponse?[SR_TRIP_STATUS_ID].intValue)!
                            self.hideRequestLoadingView()
                            
                            if self.myTripStatusIdInteger == SR_TRIP_REQUEST {
                                
                                OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: aJsonResponse?[kRESPONSE][kRESPONSE_MESSAGE].stringValue)
                                self.aStatusString = (aJsonResponse?[kRESPONSE][kRESPONSE_MESSAGE].stringValue)!
                                OBJ_SESSION?.isAlertShown(true)
                            }
                            else if self.myTripStatusIdInteger == SR_TRIP_BEFORE_CANCEL || self.myTripStatusIdInteger == SR_TRIP_AFTER_CANCEL {
                                
                                self.aStatusString = "Trip cancelled"
                                self.tripStatusUpdatedToCancelled(aResponseString: aResponseString)
                            }
                            else if self.myTripStatusIdInteger == SR_TRIP_ACCEPTED {
                                
                                self.aStatusString = "Trip Confirmed"
                                self.tripStatusUpdatedToAccepted(aResponseString: aResponseString)
                            }
                                
                            else if self.myTripStatusIdInteger == SR_TRIP_ARRIVED {
                                
                                self.aStatusString = "Driver Arrived"
                                self.tripStatusUpdatedToArrived(aResponseString: aResponseString)
                            }
                            else {
                                self.tripStatusUpdatedToStartedAndCompleted(aResponseString: aResponseString)
                            }
                            
                            if self.myTripStatusIdInteger == SR_TRIP_ACCEPTED {
                                
                            }
                        })
                    }
                        
                    else {
                        
                        self.mySubmitButton.isUserInteractionEnabled = true
                        self.mySubmitButton.backgroundColor = UIColor.black
                        
                        if (myRideResponseMutableArray.count != 0) {
                            
                            changeViewBasedOnRide()
                        }
                        OBJ_SESSION?.isAlertShown(false)
                        
                        var dic = [String:Any]()
                        dic  = [NOTIFICATION_REQUEST_STATUS_KEY : aResponseString]
                        print(dic)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_VIEW_UPADTE_BASED_ON_REQUEST_STATUS), object: nil, userInfo:(dic as Any as! [AnyHashable : Any]))
                        
                        myTripStatusIdInteger = (aJsonResponse?[SR_TRIP_STATUS_ID].intValue)!
                        hideRequestLoadingView()
                        
                        if myTripStatusIdInteger == SR_TRIP_REQUEST {
                            
                            OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: aJsonResponse?[kRESPONSE][kRESPONSE_MESSAGE].stringValue)
                            aStatusString = (aJsonResponse?[kRESPONSE][kRESPONSE_MESSAGE].stringValue)!
                            OBJ_SESSION?.isAlertShown(true)
                            
                        }
                        else if myTripStatusIdInteger == SR_TRIP_BEFORE_CANCEL || myTripStatusIdInteger == SR_TRIP_AFTER_CANCEL {
                            
                            aStatusString = "Trip Cancelled"
                            tripStatusUpdatedToCancelled(aResponseString : aResponseString)
                            
                        }
                        else if myTripStatusIdInteger == SR_TRIP_ACCEPTED {
                            
                            aStatusString = "Trip Confirmed"
                            tripStatusUpdatedToAccepted(aResponseString : aResponseString)
                        }
                        else if myTripStatusIdInteger == SR_TRIP_ARRIVED {
                            
                            aStatusString = "Driver Arrived"
                            tripStatusUpdatedToArrived(aResponseString : aResponseString)
                        }
                        else {
                            tripStatusUpdatedToStartedAndCompleted(aResponseString : aResponseString)
                        }
                        
                        if myTripStatusIdInteger == SR_TRIP_ACCEPTED {
                            
                        }
                        
                    }
                }
                    
                else if  aJsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == k_BAD_REQUEST ||  aJsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == K_NO_DATA_CODE {
                    
                    OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: aJsonResponse?[kRESPONSE][kRESPONSE_MESSAGE].stringValue)
                }
                    
                else {
                    
                }
            }
            catch {
                
            }
        }
    }
    //MARK: Signal R Helper Methods
    
    func tripStatusUpdatedToCancelled(aResponseString : String){
        
        aStatusString = "Trip cancelled"
        //let aJsonResponse = try? JSON(data: aResponseString.data(using: .utf8)!)
        
        SWIFT_HELPER.showAlertView(self, title: SCREEN_TITLE_DASHBOARD, message:"Trip cancelled", okButtonBlock: { (_ action : UIAlertAction) in
            
            if self.isForOnGoingRequest == true {
                
                var aMutableArray = [Any]()
                aMutableArray.append(self.mySearchSourceTextfield.text as Any)
                aMutableArray.append(self.mySearchDistinationTextfield.text as Any)
                aMutableArray.append((self.isFavSource) ? "1" : "0")
                aMutableArray.append((self.isFavDestination) ? "1" : "0")
                aMutableArray.append(self.gMapMutableInfo[0])
                aMutableArray.append(self.gMapMutableInfo[1])
                OBJ_SESSION?.setSearchInfo(aMutableArray as! NSMutableArray)
                OBJ_SESSION?.isRequested(false)
                OBJ_HELPER?.navigateToMenuDetailScreen()
            }
                
            else {
                
                SWIFT_HELPER.fadeAnimationfor(view: self.myActivityIndicatorView, alpha: 0, duration: 0, delay: 0)
                SWIFT_HELPER.fadeAnimationfor(view: self.myBidBgView, alpha: 0, duration: 0, delay: 0)
                SWIFT_HELPER.fadeAnimationfor(view: self.myRequestView, alpha: 0, duration: 0, delay: 0)
                SWIFT_HELPER.fadeAnimationfor(view: self.myBgView, alpha: 1, duration: 0, delay: 0)
                self.myRequestButtonHeightConstraint.constant = 45
                
                OBJ_SESSION?.isRequested(false)
                
                SWIFT_NAVIGATION?.setTitleWithBarButtonItems(self.gServiceTag.service_type_name, for: self, showLeftBarButton: IMAGE_BACK, showRightBarButton: nil)
                
                let aServiceType = self.gServiceTag.service_type_name.characters.count > 0 ? self.gServiceTag.service_type_name : ""
                // To set navigation bar to present with navigation
                self.mySubmitButton.setTitle(TWO_STRING(string1: "Request for", string2: aServiceType!), for: .normal)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {() -> Void in
                  
                    self.addLocationAnddrawRoute()
                    self.zoomToLocation()
                })
            }
            
        })
    }
    
    func tripStatusUpdatedToAccepted(aResponseString : String){
        
        self.mySearchView.isUserInteractionEnabled = false
        mySourceFavButton.isHidden = true
        myDestinationFavButton.isHidden = true
        aStatusString = "Trip Confirmed"
        let aJsonResponse = try? JSON(data: aResponseString.data(using: .utf8)!)
        
        
        let dictionary = aJsonResponse?["Ride_Response"].dictionaryObject!
        
        let  aMutableDict = dictionary
        
        if let aMutableDict = aMutableDict {
            
            print("dict , \(aMutableDict)")
            
            if (aMutableDict.count > 0) {
                
                self.myRideResponseMutableArray.append(aMutableDict)
            }
            print(self.myRideResponseMutableArray)
            //myCancelCharge = aMutableDict["Cancellation_Msg"] as! String
        }
        else {
            print("error")
        }
        
        
        SWIFT_NAVIGATION?.setTitleWithBarButtonItems("Trip Confirmed", for: self, showLeftBarButton: IMAGE_MENU, showRightBarButton: nil)
        
        OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: aJsonResponse?[kRESPONSE][kRESPONSE_MESSAGE].stringValue)
        OBJ_SESSION?.isAlertShown(true)
        isDriverRoutDrawn = false
        
        if self.myRideResponseMutableArray.count > 0 {
            
            changeViewBasedOnRide()
            // Change view Based On ride request
            SWIFT_HELPER.fadeAnimationfor(view: myCancelView, alpha: 1, duration: 0, delay: 0)
            SWIFT_HELPER.fadeAnimationfor(view: myCallButton , alpha: 1, duration: 0, delay: 0)
            SWIFT_HELPER.fadeAnimationfor(view: myMessageButton , alpha: 1, duration: 0, delay: 0)
        }
        
    }
    
    func tripStatusUpdatedToArrived(aResponseString : String){
        
        mySearchView.isUserInteractionEnabled = false
        mySourceFavButton.isHidden = true
        myDestinationFavButton.isHidden = true
        myMapView.clear()
        addLocationAnddrawRoute()
        zoomToLocation()
        let aJsonResponse = try? JSON(data: aResponseString.data(using: .utf8)!)
        
        if let data = aJsonResponse {
            
            let dictionary = data["Ride_Response"].dictionaryObject!
            
            let  aMutableDict = dictionary as? Dictionary<String,Any>
            
            if let aMutableDict = aMutableDict {
                
                print("dict , \(aMutableDict)")
                
                if (aMutableDict.count > 0) {
                    
                    self.myRideResponseMutableArray = [Dictionary<String,Any>]()
                    self.myRideResponseMutableArray.append(aMutableDict)
                }
                // myCancelCharge = aMutableDict["Cancellation_Msg"] as! String
            }
            else {
                print("error")
            }
        }
        SWIFT_NAVIGATION?.setTitleWithBarButtonItems("Driver Arrived", for: self, showLeftBarButton: IMAGE_MENU, showRightBarButton: nil)
        
        OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: aJsonResponse?[kRESPONSE][kRESPONSE_MESSAGE].stringValue)
        OBJ_SESSION?.isAlertShown(true)
        
        if self.myRideResponseMutableArray.count > 0 {
            
            changeViewBasedOnRide()
        }
    }
    func tripStatusUpdatedToStartedAndCompleted(aResponseString : String){
        
        SWIFT_HELPER.fadeAnimationfor(view: myCancelView, alpha: 0, duration: 0, delay: 0)
        SWIFT_HELPER.fadeAnimationfor(view: myCallButton, alpha: 0, duration: 0, delay: 0)
        SWIFT_HELPER.fadeAnimationfor(view: myMessageButton, alpha: 0, duration: 0, delay: 0)
        
        mySearchView.isUserInteractionEnabled = false
        mySourceFavButton.isHidden = true
        myDestinationFavButton.isHidden = true
        let aJsonResponse = try? JSON(data: aResponseString.data(using: .utf8)!)
        
        if myTripStatusIdInteger == SR_TRIP_STARTED {
            
            aStatusString = "Trip Started"
            print("aJsonResponse , \(String(describing: aJsonResponse))")
            
            if let data = aJsonResponse {
                
                let dictionary = data["Ride_Response"].dictionaryObject!
                
                let  aMutableDict = dictionary as? Dictionary<String,Any>
                
                if let aMutableDict = aMutableDict {
                    
                    print("dict , \(aMutableDict)")
                    
                    if (aMutableDict.count > 0) {
                        
                        self.myRideResponseMutableArray = [Dictionary<String,Any>]()
                        self.myRideResponseMutableArray.append(aMutableDict)
                    }
                    // myCancelCharge = aMutableDict["Cancellation_Msg"] as! String
                }
                else {
                    print("error")
                }
            }
            SWIFT_NAVIGATION?.setTitleWithBarButtonItems("Trip Started", for: self, showLeftBarButton: IMAGE_MENU, showRightBarButton: nil)
            
            OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: aJsonResponse?[kRESPONSE][kRESPONSE_MESSAGE].stringValue)
            OBJ_SESSION?.isAlertShown(true)
            
            if self.myRideResponseMutableArray.count > 0 {
                
                changeViewBasedOnRide()
            }
        }
        else {
            
            aStatusString = "Trip Completed"
            
            SWIFT_NAVIGATION?.setTitleWithBarButtonItems("Trip Completed", for: self, showLeftBarButton: IMAGE_MENU, showRightBarButton: nil)
            
            navigationItem.leftBarButtonItem = nil
            let aMutableArray = aJsonResponse?["Trip_Details"].arrayObject
            
            
            SWIFT_HELPER.showAlertView(self, title: SCREEN_TITLE_DASHBOARD, message: (aJsonResponse?[kRESPONSE][kRESPONSE_MESSAGE].stringValue)!, okButtonBlock: { (_ action : UIAlertAction) in
                
                if self.myRideResponseMutableArray.count > 0 {
                    
                    self.changeViewBasedOnRide()
                }
                OBJ_SESSION?.isAlertShown(true)
                
                if (aMutableArray?.count)! > 0 {
                    
                    self.isMoveToInvoiceScreen = true
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: VIEW_UPADTE_BASED_ON_REQUEST_STATUS), object: nil)
                    
                    let aViewController: LUInvoiceViewController? = SWIFT_STORY_BOARD.instantiateViewController(withIdentifier: "LUInvoiceViewController") as? LUInvoiceViewController
                    aViewController?.gInfoArray = NSMutableArray()
                    aViewController?.gInfoArray = aMutableArray as! NSMutableArray
                    aViewController?.gTripIdString = self.myTripIdString
                    aViewController?.gUserIdString = self.replaceOptionalValue(aString: "\((OBJ_SESSION?.getUserInfo()[0] as AnyObject!)[K_CUSTOMER_ID])")
                    aViewController?.myProfileUrl = self.myRideResponseMutableArray[0]["Driver_Image"] as! String
                    self.navigationController?.pushViewController(aViewController!, animated: true)
                }
            })
        }
    }
    
    
    func getTripId( aMessage: String) {
        
        do {
            
            let aResponseString = self.encodeJSONResponse(response: aMessage)
            let aJsonResponse = try? JSON(data: aResponseString.data(using: .utf8)!)
            print("Trip_ID")
            print(aMessage)
            
            if aJsonResponse != nil {
                
                self.myTripIdString = aJsonResponse?["Trip_Id"].stringValue
                print(self.myTripIdString)
            }
            
            if self.myTripIdString.characters.count > 0
                && self.myServiceTypeMutableArray.count > 0 {
                
                getAllChatList()
                self.myRequestLoadingButton.isHidden = false
                self.myRequestCancelLabel.isHidden = false
            }
        }
        catch {
            
        }
    }
    func receiveCancelTrip( aMessage: String) {
        do{
            let aResponseString = self.encodeJSONResponse(response: aMessage)
            let aJsonResponse = try? JSON(data: aResponseString.data(using: .utf8)!)
            print(aJsonResponse!)
            
            if aJsonResponse != nil {
                
                if isInChatScreen == true {
                    
                    dismiss(animated: true, completion: nil)
                }
                
                if myTripStatusIdInteger != 2 {
                    
                    OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: aJsonResponse?[kRESPONSE][kRESPONSE_MESSAGE].stringValue)
                }
                aStatusString = (aJsonResponse?[kRESPONSE][kRESPONSE_MESSAGE].stringValue)!
            }
            
            SWIFT_HELPER.fadeAnimationfor(view: myBidBgView, alpha: 0, duration: 0, delay: 0)
            SWIFT_HELPER.fadeAnimationfor(view: myActivityIndicatorView, alpha: 0, duration: 0, delay: 0)
            SWIFT_HELPER.fadeAnimationfor(view: myRequestView, alpha: 0, duration: 0, delay: 0)
            SWIFT_HELPER.fadeAnimationfor(view: myBgView, alpha: 1, duration: 0, delay: 0)
            myRequestButtonHeightConstraint.constant = 45
            mySearchView.isUserInteractionEnabled = true
            
                SWIFT_HELPER.fadeAnimationfor(view: self.myRequestView, alpha: 0, duration: 0, delay: 0)
                Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.getNearestVehiclesList), userInfo: nil, repeats: true)
                
                self.getAddressFromLocation()
                self.zoomToLocation()
                self.getFareEstimation()
            
            SWIFT_NAVIGATION?.setTitleWithBarButtonItems(gServiceTag.service_type_name, for: self, showLeftBarButton: IMAGE_BACK, showRightBarButton: nil)
            
            let aServiceType = gServiceTag.service_type_name.characters.count > 0 ? gServiceTag.service_type_name : ""
            // To set navigation bar to present with navigation
            mySubmitButton.setTitle(TWO_STRING(string1: "Request for", string2: aServiceType!), for: .normal)
            
            OBJ_SESSION?.isRequested(false)
            myCancelIdString = ""
            isRequestStarted = false

        } catch{
            
        }
    }
    
    func receiveChatMessage(aMessage: String) {
        
        let aResponseString = self.encodeJSONResponse(response: aMessage)
        let aJsonResponse = try? JSON(data: aResponseString.data(using: .utf8)!)
        
        print("receive chat message %@",aResponseString)
        
        if  aJsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == kSUCCESS_CODE {
            
            if let data = aJsonResponse {
                
                let aArray = data["Chat_Info"].arrayObject!
                
                let  aNewArray = aArray as? Array<Any>
                
                if let aNewArray = aNewArray {
                    
                    if ((aNewArray[0] as AnyObject)["Type"]  as! String) == "D" {
                        
                        OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: "You have a new message")
                        self.getAllChatList()
                    }
                }
                else {
                    
                    print("error")
                }
            }
        }
            
        else if aJsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == K_NO_DATA_CODE || aJsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == K_NO_DATA_CODE {
            
            OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: aJsonResponse?[kRESPONSE][kRESPONSE_MESSAGE].stringValue)
        }
        else {
            
            OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: aJsonResponse?[kRESPONSE][kRESPONSE_MESSAGE].stringValue)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_VIEW_UPADTE_BASED_ON_CHAT_STATUS), object: nil, userInfo: NSDictionary.init(object: aMessage, forKey: NOTIFICATION_CHAT_STATUS_KEY as NSCopying) as? [AnyHashable : Any])
        
    }
    
    func getAllChatList() {
        
        do {
            
            try myHubProxy.invoke(SR_GET_ALL_CHAT_MESSAGE, arguments: [myTripIdString], callback: { (result, error) in
                
                if result != nil {
                    
                    let message = String(describing: result as! String)
                    
                    let aResponseString = self.encodeJSONResponse(response: message)
                    let aJsonResponse = try? JSON(data: aResponseString.data(using: .utf8)!)
                    
                    if  aJsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == kSUCCESS_CODE {
                        
                        if let data = aJsonResponse {
                            
                            let aArray = data["Chat_Info"].arrayObject!
                            
                            let  aNewArray = aArray as? Array<Any>
                            
                            if let aNewArray = aNewArray {
                                var aChatInfoMutableArray = NSMutableArray()
                                aChatInfoMutableArray = aNewArray as! NSMutableArray
                                OBJ_SESSION?.setChatInfo(aChatInfoMutableArray )
                                
                            }
                            else {
                                print("error")
                            }
                        }
                    }
                    else if aJsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == K_NO_DATA_CODE || aJsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == k_BAD_REQUEST {
                        
                        if !((OBJ_SESSION?.getChatInfo().count) != nil) {
                            
                            let aChatInfoMutableArray = NSMutableArray()
                            OBJ_SESSION?.setChatInfo(aChatInfoMutableArray)
                        }
                    }
                    else {
                        
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
    
    func getDriverLocation( aMessage: String ) {
        
        if myTripStatusIdInteger == SR_TRIP_ACCEPTED {
            
            let message = String(describing: aMessage )
            
            let aResponseString = self.encodeJSONResponse(response: message)
            let aJsonResponse = try? JSON(data: aResponseString.data(using: .utf8)!)
            if  aJsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == kSUCCESS_CODE {
                
                let aInfoMutableDict = aJsonResponse?["Driver_Info"][0].dictionaryObject
                
                let aString = String(describing: aInfoMutableDict?[K_FAVORITE_LATITUDE]) + String(describing: aInfoMutableDict?[K_FAVORITE_LONGITUDE])
                
                self.myDriverInfoMutableArray = [Any]()
                self.myDriverInfoMutableArray.append(aString)
                
                if (self.myDriverInfoMutableArray.count > 0) {
                    
                    self.addLocationAnddrawRouteBetweenDriverAndCustomer()
                    
                    if (!self.isDriverRoutDrawn) {
                        
                        self.zoomToLocationFromDriverLocation()
                    }
                }
            } else if aJsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == K_NO_DATA_CODE || aJsonResponse?[kRESPONSE][kRESPONSE_CODE].intValue == k_BAD_REQUEST {
                
                OBJ_HELPER?.showNotificationSuccess(in: self, withMessage: aJsonResponse?[kRESPONSE][kRESPONSE_MESSAGE].stringValue)
            }
            else{
                
            }
            
        }
    }
    
    //MARK: Tap Gesture -
    
    func setUpTapActionForView() {
        
        let aShareGesture = UITapGestureRecognizer(target: self, action: #selector(self.shareButtonTapped))
        aShareGesture.numberOfTapsRequired = 1
        myShareView.isUserInteractionEnabled = true
        myShareView.addGestureRecognizer(aShareGesture)
        
        let aNotificationGesture = UITapGestureRecognizer(target: self, action: #selector(self.notificationButtonTapped))
        aNotificationGesture.numberOfTapsRequired = 1
        myNotificationView.isUserInteractionEnabled = true
        myNotificationView.addGestureRecognizer(aNotificationGesture)
        
        let aCancelGesture = UITapGestureRecognizer(target: self, action: #selector(self.cancelButtonTapped))
        aCancelGesture.numberOfTapsRequired = 1
        myCancelView.isUserInteractionEnabled = true
        myCancelView.addGestureRecognizer(aCancelGesture)
    }
    
    //MARK: Helper Methods
    
    func shareButtonTapped() {
        
        let aViewController = SWIFT_STORY_BOARD.instantiateViewController(withIdentifier: "LUShareViewController") as? LUShareViewController
        let aNavigationController = UINavigationController(rootViewController: aViewController!)
        self.navigationController?.present(aNavigationController, animated: true, completion: nil)
    }
    
    func notificationButtonTapped() {
        
        // StrCustomerId , StrFamilyIDs -(family id's with comma separated), StrFromLatitude, StrFromlongitude, StrTripId
        
        let aLatitude = (gMapMutableInfo[0] as AnyObject).components(separatedBy: ",")[0]
        let aLongitude = (gMapMutableInfo[0] as AnyObject).components(separatedBy: ",")[1]
        let aViewController = LUFamilyAndFriendsViewController(nibName: "LUFamilyAndFriendsViewController", bundle: nil)
        aViewController.isForFamilyFriendsScreen = false
        aViewController.gInfoArray =   [self.replaceOptionalValue(aString: "\((OBJ_SESSION?.getUserInfo()[0] as AnyObject!)[K_CUSTOMER_ID])"), aLatitude,aLongitude,self.replaceOptionalValue(aString: myTripIdString)]
        let aNavigationController = UINavigationController(rootViewController: aViewController)
        self.navigationController?.present(aNavigationController, animated: true, completion: nil)
    }
    
    func cancelButtonTapped() {
        
        if myCancelCharge.characters.count == 0 {
            
            myCancelCharge = "You may charged Cancellation fee of $10.0"
        }
        
        myTripStatusIdInteger = SR_TRIP_BEFORE_CANCEL
        
        SWIFT_HELPER.showAlertViewWithButtonTitle(self, title: SCREEN_TITLE_DASHBOARD, message: myCancelCharge, okButtonBlock: { (_ okAction: UIAlertAction) in
            
            OBJ_HELPER?.showLoading(in: self)
            self.cancelTrip()
        }, cancelButtonBlock: { (_ cancelAction: UIAlertAction) in
            
        }, isLeftAlign: false)
        
    }
    
    //MARK - Helper -
    
    //MARK -Acitivity Indicator
    
    func showLoadingActivityIndicator() {
        
        view.bringSubview(toFront: myActivityIndicatorView)
        SWIFT_HELPER.fadeAnimationfor(view: myActivityIndicatorView, alpha: 1.0, duration: 0, delay: 0)
    }
    
    func hideLoadingActivityIndicator() {
        
        SWIFT_HELPER.fadeAnimationfor(view: myActivityIndicatorView, alpha: 0.0, duration: 0, delay: 0)
    }
    
    func zoomToLocation() {
        
        // Set Zoom Level
        var aSourseCoord = CLLocationCoordinate2D()
        var aDestCoord = CLLocationCoordinate2D()
        
        var aSourceLatitude: String
        var aSourceLongitude: String
        
        var aDestinationLatitude: String
        var aDestinationLongitude: String
        
        print(gMapMutableInfo)
        
        if gMapMutableInfo.count > 0 {
            
            aSourceLatitude  = (gMapMutableInfo[0]).components(separatedBy: ",")[0] as String
            aSourceLongitude = (gMapMutableInfo[0]).components(separatedBy: ",")[1] as String
            
            aSourseCoord.latitude = Double(aSourceLatitude)!
            aSourseCoord.longitude = Double(aSourceLongitude)!
            
            aDestinationLatitude  = (gMapMutableInfo[1]).components(separatedBy: ",")[0] as String
            aDestinationLongitude = (gMapMutableInfo[1]).components(separatedBy: ",")[1] as String
            
            aDestCoord.latitude = Double(aDestinationLatitude)!
            aDestCoord.longitude = Double(aDestinationLongitude)!
            
            
            myMapLatLongMutableArray.append(aSourceLatitude+aSourceLongitude)
            myMapLatLongMutableArray.append(aDestinationLatitude+aDestinationLongitude)
        }
        let bounds = GMSCoordinateBounds(coordinate: aSourseCoord, coordinate: aDestCoord)
        let aCamera: GMSCameraPosition? = myMapView.camera(for: bounds, insets: UIEdgeInsetsMake(160, 100, 160, 100))
        myMapView.camera = aCamera!
        myMapView.animate(to: aCamera!)
    }
    
    func zoomToLocationFromDriverLocation() {
        
        // Set Zoom Level
        var aSourseCoord = CLLocationCoordinate2D()
        var aDestCoord = CLLocationCoordinate2D()
        aSourseCoord.latitude = CDouble(myDriverRoutInfoMutableArray[0].components(separatedBy: ",")[0])!
        aSourseCoord.longitude = CDouble(myDriverRoutInfoMutableArray[0].components(separatedBy: ",")[1])!
        aDestCoord.latitude = CDouble(myDriverRoutInfoMutableArray[1].components(separatedBy: ",")[0])!
        aDestCoord.longitude = CDouble(myDriverRoutInfoMutableArray[1].components(separatedBy: ",")[1])!
        
        let bounds = GMSCoordinateBounds(coordinate: aSourseCoord, coordinate: aDestCoord)
        let aCamera: GMSCameraPosition? = myMapView.camera(for: bounds, insets: UIEdgeInsetsMake(160, 100, 160, 100))
        myMapView.camera = aCamera!
        myMapView.animate(to: aCamera!)
    }
    
    func getAddressFromLocation() {
        
        var alatitude : String = ""
        var alongitud : String = ""
        
        if gMapMutableInfo.count > 0 {
            
            if self.mySearchTypeEnum == .SEARCH_TYPE_SOURCE {
                
                alatitude  = (gMapMutableInfo[0]).components(separatedBy: ",")[0] as String
                alongitud = (gMapMutableInfo[0]).components(separatedBy: ",")[1] as String
            }else {
                
                alatitude  = (gMapMutableInfo[1]).components(separatedBy: ",")[0] as String
                alongitud = (gMapMutableInfo[1]).components(separatedBy: ",")[1] as String
            }
        }
        var newLocation = CLLocationCoordinate2D()
        newLocation.latitude = Double(alatitude)!
        newLocation.longitude = Double(alongitud)!
        
        if self.gettingAddressFromLatLng == false {
            
            if OBJ_HELPER?.networkRechableForSwiftClass() == false {
                
                OBJ_HELPER?.showRetryAlert(in: self, details: ALERT_NO_INTERNET_DICT, retry: {
                    
                    self.getAddressFromLocation()
                })
                return
            }
        }
        
        var aString = String(newLocation.latitude) + "," + String(newLocation.longitude)
        gettingAddressFromLatLng = true
        
        if self.mySearchTypeEnum == .SEARCH_TYPE_SOURCE {
            
            if self.isForFavLocation == false {
                
                self.mySearchSourceTextfield.text = ""
            }
            
            self.mySearchSourceTextfield.placeholder = "Finding location..."
        }
        else {
            
            if self.isForFavLocation == false {
                
                self.mySearchDistinationTextfield.text = ""
            }
            
            self.mySearchDistinationTextfield.placeholder = "Finding location..."
        }
        
        self.geocoder.reverseGeocodeCoordinate(newLocation) { (aResponse, error) in
            
            var aSucess : Bool = false
            
            if  error == nil {
                
                let aAddress : GMSAddress? = (aResponse?.firstResult())
                var aMDictionary = [String : Any]()
                
                aMDictionary[K_FAVORITE_LATITUDE] = String(describing: aResponse?.firstResult()?.coordinate.latitude)
                aMDictionary[K_FAVORITE_LONGITUDE] = String(describing: aResponse?.firstResult()?.coordinate.longitude)
                aMDictionary[K_FAVORITE_ADDRESS] = aAddress?.lines?[0]
                aMDictionary[K_FAVORITE_DISPLAY_NAME] = ""
                aMDictionary[K_FAVORITE_PRIMARY_LOCATION] = ""
                aMDictionary[K_FAVORITE_ID] = ""
                
                if aAddress != nil {
                    
                    aSucess = true
                    // Set text in textfield based on the search
                    if self.mySearchTypeEnum == .SEARCH_TYPE_SOURCE {
                        
                        self.myFavSourseMutableDictionary = aMDictionary
                        
                        self.myFavSourseMutableDictionary[K_FAVORITE_LATITUDE] = String(alatitude)
                        self.myFavSourseMutableDictionary[K_FAVORITE_LONGITUDE] = String(alongitud)
                        
                        print("myFavSourseMutableDictionary -- \(self.myFavSourseMutableDictionary)")

                        
                        if self.isFavChanged == true {

                            self.setFavoriteBasedOnSelectedAddress(aMutableDict: self.myFavSourseMutableDictionary)
                        }
                        self.mySearchSourceTextfield.placeholder = "Search location..."
                    }
                    
                    else if self.mySearchTypeEnum == .SEARCH_TYPE_DESTINATION {
                    
                        self.myFavDestMutableDictionary = aMDictionary
                        
                        self.myFavDestMutableDictionary[K_FAVORITE_LATITUDE] = String(alatitude)
                        self.myFavDestMutableDictionary[K_FAVORITE_LONGITUDE] = String(alongitud)
                        
                        print("myFavDestMutableDictionary -- \(self.myFavDestMutableDictionary)")

                        if self.isFavChanged == true {
                            
                            self.setFavoriteBasedOnSelectedAddress(aMutableDict: self.myFavDestMutableDictionary)
                        }
                        self.mySearchDistinationTextfield.placeholder = "Search location..."

                    }
                    if self.mySearchTypeEnum == .SEARCH_TYPE_SOURCE {
                        
                        if self.myMapLocationMutableArray.count > 0 {
                            
                            self.myMapLocationMutableArray[0] = aString
                        }
                        else {
                            
                            self.myMapLocationMutableArray.append(aString)
                        }
                        
                        if (self.isForFavLocation == false) {
                            
                            self.myAddressString = aAddress?.lines?[0];
                            self.mySearchSourceTextfield.text = self.myAddressString
                            
                            if self.myAddressString.characters.count > 0 {
                                
                                if self.mySearchMutableInfo.count > 0 {
                                    
                                    self.mySearchMutableInfo[0] = self.myAddressString
                                }
                                else {
                                    
                                    self.mySearchMutableInfo.append(self.myAddressString)
                                }
                            }
                        }
                    } else if self.mySearchTypeEnum == .SEARCH_TYPE_DESTINATION {
                        
                        if self.myMapLocationMutableArray.count > 0 {
                            
                            if self.myMapLocationMutableArray.count > 1 {
                                
                                self.myMapLocationMutableArray[1] = aString
                            }
                            else {
                                
                                self.myMapLocationMutableArray.append(aString)
                            }
                        }
                        else {
                            
                            self.myMapLocationMutableArray.append("")
                            self.myMapLocationMutableArray.append(aString)
                        }
                        
                        if !self.isForFavLocation{
                            
                            self.myAddressString = aAddress?.lines?[0];
                            self.mySearchDistinationTextfield.text = self.myAddressString;
                            
                            if self.myAddressString.characters.count > 0 {
                                
                                if (self.mySearchMutableInfo.count > 0) {
                                    
                                    if ( self.mySearchMutableInfo.count > 1) {
                                        
                                        self.mySearchMutableInfo[1] = self.myAddressString
                                    }
                                    else{
                                        
                                        self.mySearchMutableInfo.append(self.myAddressString)
                                    }
                                }
                                else {
                                    
                                    self.mySearchMutableInfo[1] = self.myAddressString
                                }
                            }
                        }
                    }
                    if (self.myServiceTypeMutableArray.count > 0) {
                        
                        self.mySubmitButton.isUserInteractionEnabled = true;
                        self.mySubmitButton.backgroundColor = UIColor.black
                    }
                    
                    self.myMapInfoArray = self.myMapLocationMutableArray as! [String]
                }
                if self.isForFavLocation {
                    
                    self.isForFavLocation = true
                }
            }
            
            if aSucess == false {
                // Unable to get user locality so display error
                self.myAddressString = "Move the map to try again"
            }else {
                
                self.myLocationCoordinate = newLocation
            }
            self.gettingAddressFromLatLng = false
        }
        self.hideLoadingActivityIndicator()
        
        DispatchQueue.main.asyncAfter(deadline:  .now() + 0.5, execute: {
          
            if self.gMapMutableInfo.count > 0 {
            
                self.addLocationAnddrawRoute()
            }
        })
    }
    
    // Remove Pin Annotation
    func removePinAnnotation() {
        
        myMapView.clear()
    }
    
    // Hide Keyboard
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func addCarLocation(){
        
        var alatitude : String!
        var alongitude : String!
        var aCarInfo = [Any]()
        myMapView.clear()
        addLocationAnddrawRoute()
        
        if self.myServiceLocationTypeMutableArray.count != 0 {
            
            if let carDetails = (self.myServiceLocationTypeMutableArray[0]["Carslocations"]) as? [Dictionary<String,Any>] {
                
                aCarInfo = carDetails
            }
        }
        
        for i in 0..<aCarInfo.count {
            
            // This is set based on web service in werb service they return the lat as long & long as lat
            alatitude = (aCarInfo[i] as! [String:AnyObject])[SR_CAR_LOCATION_LONGITUDE] as! String
            alongitude = (aCarInfo[i] as! [String:AnyObject])[SR_CAR_LOCATION_LATITUDE] as! String
            var aCoordination2D = CLLocationCoordinate2D()
            aCoordination2D.latitude = Double(alatitude)!
            aCoordination2D.longitude = Double(alongitude)!
        }
    }
    
    func addLocationAnddrawRoute() {
        
        removePinAnnotation()
        
        var alatitude = ""
        var alongitude = ""
        
        for i in 0..<gMapMutableInfo.count {
            
            alatitude = (gMapMutableInfo[i] as AnyObject).components(separatedBy: ",")[0]
            alongitude = (gMapMutableInfo[i] as AnyObject).components(separatedBy: ",")[1]
            
            var aCoordination2D = CLLocationCoordinate2D()
            aCoordination2D.latitude = CDouble(alatitude)!
            aCoordination2D.longitude = CDouble(alongitude)!
            
            // Add User Marker
            UIView.animate(withDuration: 1.0, delay: 2.0, options: .curveEaseIn, animations: {() -> Void in
                
                let aUserMarker = GMSMarker()
                aUserMarker.title = ""
                aUserMarker.position = aCoordination2D
                aUserMarker.map = self.myMapView
                aUserMarker.appearAnimation = .pop
                aUserMarker.icon =  i==0 ? UIImage(named: IMAGE_FROM_MARKER) :  UIImage(named: IMAGE_TO_MARKER)
            }, completion: nil)
        }
        
        if myRoutePolyLine != nil {
            // Remove existing Route
            myRoutePolyLine.map = nil
        }
        
        
        fetchPolylinewithCompletionHandler(completionHandler: {(_ aGMSPolyline: GMSPolyline) -> Void in
            
            // To draw a Route
            self.myRoutePolyLine = aGMSPolyline
            self.myMapView.isHidden = false
            self.myRoutePolyLine?.strokeColor = UIColor.red
            self.myRoutePolyLine?.strokeWidth = 2.0
            self.myRoutePolyLine?.map = self.myMapView
            
        }, failedBlock: {(_ error: Error?) -> Void in
            
        })
        myMapView.reloadInputViews()
    }
    
    func addLocationAnddrawRouteBetweenDriverAndCustomer() {
        
        removePinAnnotation()
        
        myDriverRoutInfoMutableArray = [String]()
        
        if  gMapMutableInfo.count > 0 && myDriverInfoMutableArray.count > 0{
            
            myDriverRoutInfoMutableArray .append(gMapMutableInfo[0])
            myDriverRoutInfoMutableArray .append(myDriverInfoMutableArray[0] as! String)
        }
        var aLatitude = ""
        var aLogitude = ""
        
        for i in 0..<myDriverRoutInfoMutableArray.count {
            
            if i == 0 {
                
                aLatitude = (myDriverRoutInfoMutableArray[0] as AnyObject).components(separatedBy: ",")[0]
                aLogitude = (myDriverRoutInfoMutableArray[0] as AnyObject).components(separatedBy: ",")[1]
            }
            else {
                
                aLatitude  = (String(myLocationCoordinate.latitude) as NSString) as String
                aLogitude = (String(myLocationCoordinate.longitude) as NSString) as String
            }
            
            var aCooraCoordinaton2D = CLLocationCoordinate2D()
            
            aCooraCoordinaton2D.latitude = Double(aLatitude)!
            aCooraCoordinaton2D.longitude = Double(aLogitude)!
            
            // Add User Marker
            
            UIView.animate(withDuration: 1.0, delay: 2.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                
                let aUserMarker = GMSMarker()
                aUserMarker.title = ""
                aUserMarker.position = aCooraCoordinaton2D
                aUserMarker.map = self.myMapView
                aUserMarker.appearAnimation = GMSMarkerAnimation.pop
                aUserMarker.icon = (i == 0) ?  #imageLiteral(resourceName: "icon_from_marker") : #imageLiteral(resourceName: "icon_to_marker")
                
            }, completion: nil)
        }
        
        if myDriverRoutInfoMutableArray.count != 0 {
            
            if myRoutePolyLine != nil {
                // Remove existing Route
                myRoutePolyLine?.map = nil
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                
                self.fetchPolylineFromDriverLocationWithCompletionHandler(completionHandler: {(_ aGMSPolyline: GMSPolyline) -> Void in
                    
                    // To draw a Route
                    self.myRoutePolyLine = aGMSPolyline
                    self.myMapView.isHidden = false
                    self.myRoutePolyLine?.strokeColor = UIColor.red
                    self.myRoutePolyLine?.strokeWidth = 2.0
                    self.myRoutePolyLine?.map = self.myMapView
                    OBJ_HELPER?.fadeAnimation(for: self.myMapView, alpha: 1)
                    
                }, failurBlock: {(_ error: Error?) -> Void in
                    
                })
            })
            
            
            self.myMapView.reloadInputViews()
        }
    }
    
    
    func image(_ originalImage: UIImage, scaledTo size: CGSize) -> UIImage {
        //avoid redundant drawing
        if originalImage.size.equalTo(size) {
            return originalImage
        }
        //create drawing context
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        //draw
        originalImage.draw(in: CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(size.width), height: CGFloat(size.height)))
        //capture resultant image
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //return image
        return image!
    }
    
    
    func changeViewBasedOnRide() {
        
        SWIFT_HELPER.fadeAnimationfor(view: myBgView, alpha: 0, duration: 0, delay: 0)
        SWIFT_HELPER.fadeAnimationfor(view: myActivityIndicatorView, alpha: 0, duration: 0, delay: 0)
        SWIFT_HELPER.fadeAnimationfor(view: myRequestView, alpha: 1, duration: 0, delay: 0)
        myRequestButtonHeightConstraint.constant = 0
        hideRequestLoadingView()
        print(myRideResponseMutableArray)
        OBJ_HELPER?.setURLProfileImageFor(myProfileImageView, url: myRideResponseMutableArray[0]["Driver_Image"] as! String, placeHolderImage: IMAGE_NO_PROFILE)
        myDriverNameLabel.text = myRideResponseMutableArray[0] ["Driver_Name"] as? String
        myRatingLabel.text = myRideResponseMutableArray[0] ["Driver_rating"] as? String
        myMobileNumberString = myRideResponseMutableArray[0] ["Mobile_Number"] as? String
    }
    
    
    func replaceOptionalValue(aString: String) -> String {
        // To remove Optional(Optional(  AND ))
        
        let aNewString =  String(describing: aString).replacingOccurrences(of: DOUBLE_OPTIONAL_REMOVE_STRING, with: "").replacingOccurrences(of: REMOVE_BRACKET, with: "")
        return aNewString
    }
    
    func replaceSingleOptionalValue(aString: String) -> String {
        // To remove Optional(Optional(  AND ))
        
        let aNewString =  String(describing: aString).replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ")", with: "")
        return aNewString
    }
    
    func receiveDriverLocation(aMessage : String){
        
    }
    
    
    func showRequestLoadingView() {
        
        //        self.myTripStatusIdInteger = SR_TRIP_BEFORE_CANCEL
        view.bringSubview(toFront: myRequestLoadingView)
        myRequestLoadingView.isHidden = false;
        SWIFT_HELPER.fadeAnimationfor(view: myRequestLoadingView, alpha: 1, duration: 0, delay: 0)
        self.myNVLoadingView.alpha = CGFloat(Float(1))
        loader = NVActivityIndicatorView(frame: myNVLoadingView.frame, type: NVActivityIndicatorType.ballSpinFadeLoader, color: OBJ_HELPER?.getColorFromHexaDecimal(COLOR_APP_PRIMARY), padding: 20)
        self.myRequestLoadingView.addSubview(loader)
        loader.startAnimating()
        
        OBJ_SESSION?.setRequestTime(Date())
        OBJ_SESSION?.setIntegerValue(Int(self.myDifferenceInterval))
        self.myTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:  #selector(self.updateCountdown), userInfo: nil, repeats: true)
    }
    
    func hideRequestLoadingView() {
        
        aInterval = 0;
        myTimer.invalidate()
        self.myTimerLabel.text = String("00:00")
        self.loader.stopAnimating()
        
        OBJ_HELPER?.fadeAnimation(for: self.myNVLoadingView, alpha: 0)
        OBJ_HELPER?.fadeAnimation(for: self.myRequestLoadingView, alpha: 0)
    }

    
    func updateCountdown() {

        aInterval = aInterval + 1
        let atime = timeString(time: TimeInterval(aInterval)) as String!
        self.myTimerLabel.text = atime!
    }
    
    func timeString(time:TimeInterval) -> String {
        
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
       
        return String(format:"%02i:%02i", minutes,seconds)
    }
    
    func refreshScreenBasedOnStatus() {
        
        if myTripStatusIdInteger > SR_TRIP_ACCEPTED && isMoveToInvoiceScreen == false {
            
            self.getOnGoingRequest()
        }
    }
    
    func changeViewBasedOnFav(){
        
        self.setFavoriteBasedOnSelectedAddress(aMutableDict: [String : Any]())
    }
    
    func updateIntegerConut() {
        
        self.myRequestDeclinedInteger = self.myRequestDeclinedInteger + 1;
    }
    
    // To encode JSON Response
    func encodeJSONResponse(response: String) -> String{
        
        let jsonResponseString = response .replacingOccurrences(of: "'\"'", with: "")
        return jsonResponseString
    }
    
    //MARK: To change Favorite status
    
    func addOrDeletebasedOnTheButtonStatus(aBoolValue: Bool) {
        
        let aMutableDict : NSMutableDictionary = [:]
        
        switch self.mySearchTypeEnum {
            
        case .SEARCH_TYPE_SOURCE:
            
            aMutableDict[K_FAVORITE_LATITUDE] =  (gMapMutableInfo[0] as AnyObject).components(separatedBy: ",")[0]
            aMutableDict[K_FAVORITE_LONGITUDE] = (gMapMutableInfo[0] as AnyObject).components(separatedBy: ",")[1]
            aMutableDict[K_FAVORITE_ADDRESS] = mySearchSourceTextfield.text;
            
        default:
            
            aMutableDict[K_FAVORITE_LATITUDE] =  (gMapMutableInfo[1] as AnyObject).components(separatedBy: ",")[0]
            aMutableDict[K_FAVORITE_LONGITUDE] = (gMapMutableInfo[1] as AnyObject).components(separatedBy: ",")[1]
            aMutableDict[K_FAVORITE_ADDRESS] = mySearchDistinationTextfield.text;
        }
        
        // To add  the location as favorite
        
        let aViewController =  storyboard?.instantiateViewController(withIdentifier: "LUFavouritePopViewController") as! LUFavouritePopViewController!
        aViewController?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        aViewController?.isForPromoCode = false
        aViewController?.isFromSwiftScreen = true
        aViewController?.gDelegate = self
        aViewController?.gMutableDictionary = aMutableDict
        
        /*   aViewController?.callBackBlock = {(_ isCallBack:Bool, aMutabelArray: NSMutableArray) -> Void in
         
         
         } as! (Bool, NSMutableArray?) -> Void*/
        
        let aNavigationController = UINavigationController(rootViewController: aViewController!)
        self.navigationController?.present(aNavigationController, animated: true, completion: { _ in })
        
    }
    
    func setFavoriteBasedOnSelectedAddress(aMutableDict: [String : Any]) {
        
        var aMainMutableArray = [Any]()
        aMainMutableArray = (OBJ_COREDATAMANAGER?.getFavouriteListInfo())!
        
        print("aMainMutableArray--\(aMainMutableArray)")
        print("aMainMutableArray count--\(aMainMutableArray.count)")

        let aMutableArray = aMainMutableArray as? Array<Any>
       
        print("aMutableArray--\(String(describing: aMutableArray))")

        if let aMutableArray = aMutableArray {
           
            print("aNewMutableArray--\(aMutableArray)")
            var isFavorite = false

            for i in 0...aMutableArray.count - 1 {
                
                let aTag: TagFavouriteType = (aMutableArray[i] as AnyObject) as! TagFavouriteType
                print("TagFavouriteType--\(aTag)")
                
                var aLatitude: String  = "\(String(describing: aTag.favourite_latitude))"
                var aLongitude: String  = "\(String(describing:  aTag.favourite_longitude))"
                
                var aCurrentLatitude: String = "\(String(describing: myCurrentFavMutableDict[K_FAVORITE_LATITUDE]))"
                var aCurrentLongitude: String = "\(String(describing: myCurrentFavMutableDict[K_FAVORITE_LONGITUDE]))"
                
                
                if aCurrentLatitude.characters.count < 8 {
                    
                    aCurrentLatitude = (OBJ_HELPER?.setZeroAfterValue(aCurrentLatitude, numberOfZero: 8 - aCurrentLatitude.characters.count))!
                }
                
                if aCurrentLongitude.characters.count < 8 {
                    
                    aCurrentLongitude = (OBJ_HELPER?.setZeroAfterValue(aCurrentLongitude, numberOfZero: 8 - aCurrentLongitude.characters.count))!
                }
                
                
                switch self.mySearchTypeEnum {
                    
                case .SEARCH_TYPE_SOURCE:
                    
                    if myCurrentFavMutableDict.count == 0 {
                        
                        aCurrentLatitude = "\(String(describing: myFavSourseMutableDictionary[K_FAVORITE_LATITUDE]))"
                        aCurrentLongitude = "\(String(describing: myFavSourseMutableDictionary[K_FAVORITE_LATITUDE]))"
                    }
                default:
                    
                    if myCurrentFavMutableDict.count == 0 {
                        
                        aCurrentLatitude = "\(String(describing: myFavDestMutableDictionary[K_FAVORITE_LATITUDE]))"
                        aCurrentLongitude = "\(String(describing: myFavDestMutableDictionary[K_FAVORITE_LATITUDE]))"
                    }
                }
                
                aCurrentLatitude = replaceSingleOptionalValue(aString: aCurrentLatitude)
                aCurrentLongitude = replaceSingleOptionalValue(aString: aCurrentLongitude)
                aLatitude = replaceSingleOptionalValue(aString: aLatitude)
                aLongitude = replaceSingleOptionalValue(aString: aLongitude)
                
                print("aCurrentLatitude\(aCurrentLatitude)")
                print("aCurrentLongitude\(aCurrentLongitude)")
                print("aLatitude\(aLatitude)")
                print("aLongitude\(aLongitude)")
                
                if aMutableDict.count == 0 {
                    
                    for  _ in 0...gMapMutableInfo.count {
                        
                        let alatitudeIndex = aCurrentLatitude.index(aCurrentLatitude.startIndex, offsetBy: 9)
                        let alongitudeIndex = aCurrentLongitude.index(aCurrentLongitude.startIndex, offsetBy: 9)
                        
                        let aNewCurrentLatitude: String = (aCurrentLatitude.substring(to:alatitudeIndex) as String)
                        let aNewCurrentLongitude: String = (aCurrentLongitude.substring(to:alongitudeIndex) as String)
                        
                        aLatitude = aLatitude.substring(to: aLatitude.index(before: aLatitude.endIndex))
                        aLongitude = aLongitude.substring(to: aLongitude.index(before: aLongitude.endIndex))
                        
                        if aNewCurrentLatitude == aLatitude && aNewCurrentLongitude ==  aLongitude {
                            
                            isFavorite = true
                            
                            switch self.mySearchTypeEnum {
                                
                            case .SEARCH_TYPE_SOURCE:
                                
                                mySourceFavButton.isSelected = true
                                isFavSource = true
                                myFavSourseMutableDictionary[K_FAVORITE_ID] = aTag.favourite_type_id
                                gfavoriteIdString = aTag.favourite_type_id
                                myFavoritePrimaryLocation = aTag.favourite_primary_location
                            default:
                                
                                myDestinationFavButton.isSelected = true
                                isFavDestination = true
                                myFavDestMutableDictionary[K_FAVORITE_ID] = aTag.favourite_type_id
                                gFavoriteDestinationIdString = aTag.favourite_type_id
                                myFavoritePrimaryLocation = aTag.favourite_primary_location
                            }
                        }
                        else {
                            
                            if isFavorite == false {
                                
                                switch self.mySearchTypeEnum {
                                    
                                case .SEARCH_TYPE_SOURCE:
                                    
                                    mySourceFavButton.isSelected = false
                                    isFavSource = false
                                default:
                                    
                                    myDestinationFavButton.isSelected = false
                                    isFavDestination = false
                                }
                            }
                        }
                    }
                }
                else {
                    
                    let alatitudeIndex = aCurrentLatitude.index(aCurrentLatitude.startIndex, offsetBy: 9)
                    let alongitudeIndex = aCurrentLongitude.index(aCurrentLongitude.startIndex, offsetBy: 9)
                    
                    let aNewCurrentLatitude: String = (aCurrentLatitude.substring(to:alatitudeIndex) as String)
                    let aNewCurrentLongitude: String = (aCurrentLongitude.substring(to:alongitudeIndex) as String)
                    
                    aLatitude = aLatitude.substring(to: aLatitude.index(before: aLatitude.endIndex))
                    aLongitude = aLongitude.substring(to: aLongitude.index(before: aLongitude.endIndex))
                    
                    print("acurruetlat --- \(aNewCurrentLatitude)")
                    print("acurruetlong --- \(aNewCurrentLongitude)")
                    print("anewLatitude\(aLatitude)")
                    print("anewLongitude\(aLongitude)")

                    
                    if aNewCurrentLatitude == aLatitude && aNewCurrentLongitude ==  aLongitude {
                        
                        isFavorite = true
                        
                        switch self.mySearchTypeEnum {
                            
                        case .SEARCH_TYPE_SOURCE:
                            
                            mySourceFavButton.isSelected = true
                            isFavSource = true
                            myFavSourseMutableDictionary[K_FAVORITE_ID] = aTag.favourite_type_id
                            gfavoriteIdString = aTag.favourite_type_id
                            myFavoritePrimaryLocation = aTag.favourite_primary_location
                        
                        default:
                            
                            myDestinationFavButton.isSelected = true
                            isFavDestination = true
                            myFavDestMutableDictionary[K_FAVORITE_ID] = aTag.favourite_type_id
                            gFavoriteDestinationIdString = aTag.favourite_type_id
                            myFavoritePrimaryLocation = aTag.favourite_primary_location
                        }
                        
                        
                    }
                    else {
                        
                        if isFavorite == false {
                            
                            switch self.mySearchTypeEnum {
                                
                            case .SEARCH_TYPE_SOURCE:
                                
                                mySourceFavButton.isSelected = false
                                isFavSource = false
                            default:
                                
                                myDestinationFavButton.isSelected = false
                                isFavDestination = false
                            }
                        }
                    }
                }
            }
        }
    }
}
