//
//  SwiftHttpManager.swift
//  Levare
//
//  Created by Arun Prasad.S, ANGLER - EIT on 05/06/17.
//  Copyright © 2017 AngMac137. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class SwiftHttpManager: NSObject {
    
    class var sharedObject: SwiftHttpManager {
        
        let sharedInstance: SwiftHttpManager = { SwiftHttpManager()}()
        return sharedInstance
    }
    

    func deleteFavoriteType(aParameter: String, favoritePrimaryLocation aFavoritePrimaryLocation: String, completionBlock completion:  @escaping( _ responseObject: JSON) -> Void, failureBlock failure: @escaping( _ error: Error) -> Void) {
        
        let aCaseString = "\(SWIFT_WEB_SERVICE_STRING(string1:SWIFT_WEB_SERVICE_URL, string2: CASE_DELETE_FAVORITE_LIST))"
        var aParamString = "\(aParameter.replacingOccurrences(of: "[", with: "{"))"
        aParamString = "\(aParamString.replacingOccurrences(of: "]", with: "}"))"
        print("aparam \(aParamString)")
        
        let urlString = aCaseString
        var parameters : [String: Any] = [:]
        parameters["StrJson"] = "\(aParamString)" as AnyObject
        
        print("parameters \(parameters)")

        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
           
            case .success(_):
               
                if response.result.value != nil {
                    
                    print(response.result.value!)
                }
            
                break
                
            case .failure(_):
                
                print(response.result.error!)
                break
                
            }
        }
        /*
         
         NSDictionary *responseDict = responseObject;
         NSMutableArray *aMutableArray = [responseDict  valueForKey:@"Favourites_Types"];
         NSMutableArray *aListMutableArray = [NSMutableArray new];
         
         NSLog(@"responseDict ---- %@",responseDict);
         
         if (aMutableArray .count) {
         
         for (NSDictionary *aDictionary in aMutableArray) {
         
         NSMutableDictionary *aMutableDictionary  = [NSMutableDictionary new];
         
         aMutableDictionary = [aDictionary mutableCopy];
         
         if ([[aDictionary valueForKey:@"PrimaryLocation"] isEqualToString:@"1"])
         aMutableDictionary[@"favourite_filter"] = @"0";
         else if ([[aDictionary valueForKey:@"PrimaryLocation"] isEqualToString:@"2"])
         aMutableDictionary[@"favourite_filter"] = @"1";
         else
         aMutableDictionary[@"favourite_filter"] = @"2";
         
         [aListMutableArray addObject:aMutableDictionary];
         }
         
         [SESSION setFavoriteInfoList:aListMutableArray];
         }
         else {
         
         
         [SESSION setFavoriteInfoList:[NSMutableArray new]];
         }
         
         [COREDATAMANAGER deleteAllEntities:TABEL_FAVOURITE_TYPE];
         
         
         BOOL isHomePresent = false, isOfficePresent = false;
         
         for (NSDictionary *aDictionary in aMutableArray) {
         
         [COREDATAMANAGER addFavouriteListInfo:aDictionary];
         
         
         if ([aDictionary[@"PrimaryLocation"] isEqualToString:@"1"]) {
         
         isHomePresent = YES;
         }
         else if ([aDictionary[@"PrimaryLocation"] isEqualToString:@"2"]) {
         
         isOfficePresent = YES;
         }
         
         }
         
         if (!isHomePresent) {
         
         [HELPER addFavoriteList:1];
         }
         
         if (!isOfficePresent) {
         
         [HELPER addFavoriteList:2];
         }
         
         
         
         
         guard let requestUrl = URL(string:urlString) else { return }
         var request = URLRequest(url:requestUrl)
         request.httpBody = try! JSONSerialization.data(withJSONObject: postDictionary, options: [])
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.addValue("application/json", forHTTPHeaderField: "Accept")
         
         let task = URLSession.shared.dataTask(with: request) {
         (data, response, error) in
         
         if error != nil {
         
         failure(error!)
         
         } else {
         
         do {
         
         let aJsonResponse = try? JSON(data: data!)
         
         completion(aJsonResponse!)
         
         } catch {
         
         
         }
         }
         
         }
         task.resume()
         } */
    }
}
