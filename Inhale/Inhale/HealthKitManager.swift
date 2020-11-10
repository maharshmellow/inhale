//
//  HealthKitManager.swift
//  Inhale
//
//  Created by Maharsh Patel on 2020-11-06.
//

import Foundation
import HealthKit


class HealthKitManager {
    var healthStore: HKHealthStore?
    private let writeType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!

    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    func isHealthKitAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    func getAuthorization() {
        healthStore!.requestAuthorization(toShare: Set([writeType]), read: nil, completion: { (userWasShownPermissionSheet, error) in
            if userWasShownPermissionSheet {
                print("Shown sheet")
                
                if self.haveAuthorization() {
                    print("Have Authorization")
                } else {
                    print("Don't have Authorization")
                }
                
            } else {
                // the sheet wasn't shown
                print("Not shown sheet")
            }
        })
    }
    
    func haveAuthorization() -> Bool {
        if isHealthKitAvailable() && healthStore!.authorizationStatus(for: writeType) == .sharingAuthorized {
            return true
        }
        return false
    }
    
    func saveMindfulSession(startTime: Date, endTime: Date) -> Void {
        guard UserDefaults.standard.bool(forKey: "save_healthkit") && self.haveAuthorization() else {
            return
        }
        
        let mindfulSample = HKCategorySample(type: writeType, value: HKCategoryValue.notApplicable.rawValue, start: startTime, end: endTime)
        healthStore!.save(mindfulSample) { (success, error) in
            if error != nil {
                print("Error \(error!)")
            } else {
                print("Saved \(startTime) \(endTime)")
            }
        }
    }
}
