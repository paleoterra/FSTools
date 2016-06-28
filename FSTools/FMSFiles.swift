//
//  FMSFiles.swift
//  FSTools
//
//  Created by Thomas Moore on 6/26/16.
//  Copyright © 2016 Thomas Moore. All rights reserved.
//

import Foundation


public func FMSParse(url: URL) throws -> [FMSWeighpoint] {
    var resultArray = [FMSWeighpoint]()
    do {
        let contents = try String.init(contentsOf: url)
        let lines = contents.components(separatedBy: CharacterSet.newlines)
        
        if lines.count < 4 {
            throw FMSParseError.unknownFormat
        }
        for (index,line) in lines.enumerated() {
            switch index {
            case 0:
                if line != "A" && line != "I" {
                    throw FMSParseError.improperFileProducer
                }
            case 1:
                let components = line.components(separatedBy: CharacterSet.whitespaces)
                if components[0] != "3" {
                    throw FMSParseError.incompatibleVersion
                }
                
                if components[1].caseInsensitiveCompare("version") != .orderedSame {
                    throw FMSParseError.incompatibleVersion
                }
            case 2:
                if line != "1" {
                    throw FMSParseError.incompatibleVersion
                }
            case 3:
                ()
            default:
                let components = line.components(separatedBy: CharacterSet.whitespaces)
                if components.count == 5 {
                    if components[0] != "0" {
                        if let aWP = FMSWeighpoint.init(array: components) {
                            resultArray.append(aWP)
                            
                        }
                        
                    }
                }
            }
        }
    }
    catch {
        throw error
    }
    return resultArray
}

public func FMSCreateFile(url: URL, weighpoints: [FMSWeighpointProtocol]) {
    let fileManager = FileManager.default()
    guard let path = url.path else {
        return
    }
    do {
        if fileManager.fileExists(atPath: path) {
            try fileManager.removeItem(at: url)
        }
        fileManager.createFile(atPath: path, contents: nil, attributes: nil)
        guard let fileHandle = FileHandle.init(forWritingAtPath: path) else {
            return
        }
        let header = "I\n3 version\n1\n\(weighpoints.count)\n"
        fileHandle.write(header.data(using: String.Encoding.utf8)!)
        for anItem in weighpoints {
            let point = "\(anItem.FMSString)\n"
            fileHandle.write(point.data(using: String.Encoding.utf8)!)
        }
        fileHandle.closeFile()
        
    }
    catch {
        print(error)
    }
    
}

public enum FMSWeighpointType: Int {
    case airport = 1
    case NDB = 2
    case VOR = 3
    case fix = 11
    case position = 28
}

public struct FMSWeighpoint: FMSWeighpointProtocol {
    public let type: FMSWeighpointType
    public let id: String
    public let altitude: Int
    public let latitude: Double
    public let longitude: Double
    
    public init?(array: [String]) {
        if array.count == 5 {
            type = FMSWeighpointType(rawValue: Int(array[0])!)!
            id = array[1]
            if let temp = Double(array[2]){
               altitude = Int(temp)
            }
            else {
                return nil
            }
            if let temp = Double(array[3]){
                latitude = temp
            }
            else {
                return nil
            }
            if let temp = Double(array[4]){
                longitude = temp
            }
            else {
                return nil
            }

        }
        else {
            return nil
        }
    }
    
    public init(type: FMSWeighpointType, id: String?, altitude: Int, latitude: Double, longitude: Double) {
        self.type = type
        if let newID = id {
            self.id = newID
        }
        else {
            let formatter = NumberFormatter.init()
            formatter.positivePrefix = "+"
            formatter.numberStyle = .decimal
            formatter.minimumIntegerDigits = 2
            formatter.maximumFractionDigits = 3
            formatter.minimumFractionDigits = 3
            
            let tempLat = formatter.string(from: latitude)
            formatter.minimumIntegerDigits = 3
            let tempLon = formatter.string(from: longitude)
            if let tLat = tempLat, let tLon = tempLon {
                self.id = "\(tLat)_\(tLon)"
            }
            else {
                self.id = "----"
            }
            

        }
        
        self.altitude = altitude
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public var FMSString: String {
        get {
            return String(format:"%i %@ %.6f %.6f %.6f",type.rawValue,id,Double(altitude),latitude,longitude)
        }
    }
}

public enum FMSParseError: ErrorProtocol {
    case improperFileProducer
    case incompatibleVersion
    case unknownFormat
    case improperWeighpointFormat
}

public protocol FMSWeighpointProtocol {
    var type: FMSWeighpointType { get }
    var id: String { get }
    var altitude: Int { get }
    var longitude: Double { get }
    var latitude: Double { get }
    var FMSString: String { get }
}
