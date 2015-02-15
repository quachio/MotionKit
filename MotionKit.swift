//
//  MotionKit.swift
//  Messiah
//
//  Created by Haroon on 14/02/2015.
//  Copyright (c) 2015 MotionKit. All rights reserved.
//

import Foundation
import CoreMotion

//_______________________________________________________________________________________________________________
// this helps retrieve values from the sensors.
@objc protocol MotionKitDelegate {
    optional func retrieveAccelerometerValues (x: Double, y:Double, z:Double, absoluteValue: Double)
    optional func retrieveGyroscopeValues     (x: Double, y:Double, z:Double, absoluteValue: Double)
    optional func retrieveDeviceMotionValues  (x: Double, y:Double, z:Double, absoluteValue: Double)
    optional func retrieveMagnetometerValues  (x: Double, y:Double, z:Double, absoluteValue: Double)
}


class MotionKit {
    
    let manager = CMMotionManager()
    var delegate: MotionKitDelegate?
    
    /*
    *  init:void:
    *
    *  Discussion:
    *			Initialises the MotionKit class and throw a Log with a timestamp.
    */
    init(){
        NSLog("MotionKit has been initialised successfully")
    }
    
    /*
    *  getAccelerometerValues:interval:values:
    *
    *  Discussion:
    *			Starts accelerometer updates, providing data to the given handler through the given queue.
    *			Note that when the updates are stopped, all operations in the
    *			given NSOperationQueue will be cancelled. You can access the retrieved values either by a
    *           Trailing Closure or through a Delgate.
    */
    func getAccelerometerValues (interval: NSTimeInterval = 0.1, values: ((x: Double, y: Double, z: Double) -> ())? ){
        
        var valX: Double!
        var valY: Double!
        var valZ: Double!
        if manager.accelerometerAvailable {
            manager.accelerometerUpdateInterval = interval
            manager.startAccelerometerUpdatesToQueue(NSOperationQueue()) {
                (data: CMAccelerometerData!, error: NSError!) in
                
                if let isError = error {
                    NSLog("Error: %@", isError)
                }
                valX = data.acceleration.x
                valY = data.acceleration.y
                valZ = data.acceleration.z
                
                if values != nil{
                    values!(x: valX,y: valY,z: valZ)
                }
                var absoluteVal = sqrt(valX * valX + valY * valY + valZ * valZ)
                self.delegate?.retrieveAccelerometerValues!(valX, y: valY, z: valZ, absoluteValue: absoluteVal)
            }
            
        } else {
            NSLog("The Accelerometer is not available")
        }
    }
    
    /*
    *  getGyroValues:interval:values:
    *
    *  Discussion:
    *			Starts gyro updates, providing data to the given handler through the given queue.
    *			Note that when the updates are stopped, all operations in the
    *			given NSOperationQueue will be cancelled. You can access the retrieved values either by a
    *           Trailing Closure or through a Delegate.
    */
    func getGyroValues (interval: NSTimeInterval = 0.1, values: ((x: Double, y: Double, z:Double) -> ())? ) {
        
        var valX: Double!
        var valY: Double!
        var valZ: Double!
        if manager.gyroAvailable{
            manager.gyroUpdateInterval = interval
            manager.startGyroUpdatesToQueue(NSOperationQueue()) {
                (data: CMGyroData!, error: NSError!) in
                
                if let isError = error{
                    NSLog("Error: %@", isError)
                }
                valX = data.rotationRate.x
                valY = data.rotationRate.y
                valZ = data.rotationRate.z
                
                if values != nil{
                    values!(x: valX, y: valY, z: valZ)
                }
                var absoluteVal = sqrt(valX * valX + valY * valY + valZ * valZ)
                self.delegate?.retrieveGyroscopeValues!(valX, y: valY, z: valZ, absoluteValue: absoluteVal)
            }
            
        } else {
            NSLog("The Gyroscope is not available")
        }
    }
    
    /*
    *  getDeviceMotionValues:interval:values:
    *
    *  Discussion:
    *			Starts device motion updates, providing data to the given handler through the given queue.
    *			Uses the default reference frame for the device. Examine CMMotionManager's
    *			attitudeReferenceFrame to determine this. You can access the retrieved values either by a
    *           Trailing Closure or through a Delegate.
    */
    func getDeviceMotionValues (interval: NSTimeInterval = 0.1, values: ((x:Double, y:Double, z:Double) -> ())? ) {
        
        var valX: Double!
        var valY: Double!
        var valZ: Double!
        if manager.deviceMotionAvailable{
            manager.deviceMotionUpdateInterval = interval
            manager.startDeviceMotionUpdatesToQueue(NSOperationQueue()){
                (data: CMDeviceMotion!, error: NSError!) in
                
                if let isError = error{
                    NSLog("Error: %@", isError)
                }
                valX = data.gravity.x
                valY = data.gravity.y
                valZ = data.gravity.z
                
                if values != nil{
                    values!(x: valX, y: valY, z: valZ)
                }
                
                var absoluteVal = sqrt(valX * valX + valY * valY + valZ * valZ)
                self.delegate?.retrieveDeviceMotionValues!(valX, y: valY, z: valZ, absoluteValue: absoluteVal)
            }
            
        } else {
            NSLog("Device Motion is not available")
        }
    }
    
    /*
    *  getMagnetometerValues:interval:values:
    *
    *  Discussion:
    *      Starts magnetometer updates, providing data to the given handler through the given queue.
    *      You can access the retrieved values either by a Trailing Closure or through a Delegate.
    */
    @availability(iOS, introduced=5.0)
    func getMagnetometerValues (interval: NSTimeInterval = 0.1, values: ((x: Double, y:Double, z:Double) -> ())? ){
        
        var valX: Double!
        var valY: Double!
        var valZ: Double!
        if manager.magnetometerAvailable {
            manager.magnetometerUpdateInterval = interval
            manager.startMagnetometerUpdatesToQueue(NSOperationQueue()){
                (data: CMMagnetometerData!, error: NSError!) in
                
                if let isError = error{
                    NSLog("Error: %@", isError)
                }
                valX = data.magneticField.x
                valY = data.magneticField.y
                valZ = data.magneticField.z
                
                if values != nil{
                    values!(x: valX, y: valY, z: valZ)
                }
                var absoluteVal = sqrt(valX * valX + valY * valY + valZ * valZ)
                self.delegate?.retrieveMagnetometerValues!(valX, y: valY, z: valZ, absoluteValue: absoluteVal)
            }
            
        } else {
            NSLog("Magnetometer is not available")
        }
    }
    
    // MARK :- Stop getting updates and kill the instance of the manager
    
    /*
    *  stopAccelerometerUpdates
    *
    *  Discussion:
    *			Stop accelerometer updates.
    */
    func stopAccelerometerUpdates(){
        self.manager.stopAccelerometerUpdates()
    }
    
    /*
    *  stopGyroUpdates
    *
    *  Discussion:
    *			Stops gyro updates.
    */
    func stopGyroUpdates(){
        self.manager.stopGyroUpdates()
    }
    
    /*
    *  stopDeviceMotionUpdates
    *
    *  Discussion:
    *			Stops device motion updates.
    */
    func stopDeviceMotionUpdates() {
        self.manager.stopDeviceMotionUpdates()
    }
    
    /*
    *  stopMagnetometerUpdates
    *
    *  Discussion:
    *      Stops magnetometer updates.
    */
    @availability(iOS, introduced=5.0)
    func stopmagnetometerUpdates() {
        self.manager.stopMagnetometerUpdates()
    }
    
}