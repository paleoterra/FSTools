//
//  XPEarthFix.swift
//  FSTools
//
//  Created by Thomas Moore on 6/27/16.
//  Copyright © 2016 Thomas Moore. All rights reserved.
//

import Foundation

public func parseXPEarthFix(url: URL) throws -> [XPFix] {
    var resultArray = [XPFix]()
    do {
        let contents = try String.init(contentsOf: url)
        var lines = contents.components(separatedBy: CharacterSet.newlines)
        lines = lines.filter( { $0.characters.count > 0 })
        if lines.count < 4 {
            throw XPFixParseError.unknownFormat
        }
        for (index,line) in lines.enumerated() {
            switch index {
            case 0:
                if line != "A" && line != "I" {
                    throw XPFixParseError.improperFileProducer
                }
            case 1:
                let components = line.components(separatedBy: CharacterSet.whitespaces)
                if components[0] != "600" {
                    throw XPFixParseError.incompatibleVersion
                }

            default:
                if let newFix = XPFix.init(string: line) {
                    resultArray.append(newFix)
                }
            }
        }
    }
    catch {
        throw error
    }
    return resultArray
}

public struct XPFix: XPFixProtocol {
    public let latitude: Double
    public let longitude: Double
    public let id: String
    
    public init?(string: String) {
        let strippedString = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        var components = strippedString.components(separatedBy: CharacterSet.whitespaces)
        components = components.filter( { $0.characters.count > 0 })
        if components.count != 3 {
            return nil
        }
        if let aValue = Double(components[0]) {
            latitude = aValue
        }
        else {
            latitude = 0.0
        }
        if let aValue = Double(components[1]) {
            longitude = aValue
        }
        else {
            longitude = 0.0
        }
        id = components[2]
    }
    
    public init(latitude: Double, longitude: Double, id: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.id = id
    }
}

public protocol XPFixProtocol {
    var latitude: Double { get }
    var longitude: Double { get }
    var id: String { get }
}

public enum XPFixParseError: ErrorProtocol {
    case improperFileProducer
    case incompatibleVersion
    case unknownFormat
    case improperWeighpointFormat
}
