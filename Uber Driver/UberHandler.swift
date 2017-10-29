//
//  UberHandler.swift
//  Uber Driver
//
//  Created by Jiarong He on 2017-10-26.
//  Copyright © 2017 Jiarong He. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol UberController: class {
    
    func acceptUber(lat: Double, long: Double);
    func riderCanceledUber();
    func uberCanceled();
    func updateRidersLocation(lat: Double, long: Double);
}

class UberHandler{
    
    private static let _instance = UberHandler();
    
    
    weak var delegate: UberController?;
    
    
    var rider = "";
    var driver = "";
    var driver_id = "";
    
    static var Instance: UberHandler{
        return _instance;
    }
    
    func observeMessagesForDriver(){
        
        // 1. Rider send request
        DBProvider.Instance.requestRef.observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                
                if let latitude = data[Constants.LATITUDE] as? Double{
                    
                    if let longitude = data[Constants.LONGITUDE] as? Double{
                        
                        // delegate call "DriverVC" class to implement func
                        self.delegate?.acceptUber(lat: latitude, long: longitude);
                    }
                }
                
                if let name = data[Constants.NAME] as? String {
                    
                    self.rider = name;
                }
                
            }
        }
        
        
        // 2. Rider cancel request
        DBProvider.Instance.requestRef.observe(DataEventType.childRemoved) { (snapshot: DataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                
                if let name = data[Constants.NAME] as? String {
                    
                    if name == self.rider{
                        self.rider = "";
                        self.delegate?.riderCanceledUber();
                    }
                }
                
            }
        }
        
        
        // 3. Driver accept request
        DBProvider.Instance.requestAcceptedRef.observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                
                if let name = data[Constants.NAME] as? String {
                    
                    if name == self.driver{
                        self.driver_id = snapshot.key;
                    }
                }
                
            }
        }
        
        
        // 4. Driver cancel request
        DBProvider.Instance.requestAcceptedRef.observe(DataEventType.childRemoved) { (snapshot: DataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                
                if let name = data[Constants.NAME] as? String {
                    
                    if name == self.driver{
                        self.delegate?.uberCanceled();
                    }
                }
                
            }
        }
        
        
        // 5. Rider updating location
        DBProvider.Instance.requestAcceptedRef.observe(DataEventType.childChanged) { (snapshot: DataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                
                if let lat = data[Constants.LATITUDE] as? Double{
                    
                    if let long = data[Constants.LONGITUDE] as? Double{
                        
                        self.delegate?.updateRidersLocation(lat: lat, long: long);
                    }
                }
                
            }
        }
        
        
    }
    
    
    func uberAccepted(lat: Double, long: Double){
        
        let data: Dictionary<String, Any> = [Constants.NAME: driver, Constants.LATITUDE: lat, Constants.LONGITUDE: long];
        
        DBProvider.Instance.requestAcceptedRef.childByAutoId().setValue(data);
    }
    
    
    func cancelUberForDriver(){
        
        DBProvider.Instance.requestAcceptedRef.child(driver_id).removeValue();
    }
    
    
    func updateDriverLocation(lat: Double, long: Double){
        
        DBProvider.Instance.requestAcceptedRef.child(driver_id).updateChildValues([Constants.LATITUDE: lat, Constants.LONGITUDE: long]);
    }
    
    
    
} // class























