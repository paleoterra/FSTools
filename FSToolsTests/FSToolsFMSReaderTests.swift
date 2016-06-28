//
//  FSToolsTests.swift
//  FSToolsTests
//
//  Created by Thomas Moore on 6/26/16.
//  Copyright © 2016 Thomas Moore. All rights reserved.
//

import XCTest
@testable import FSTools

class FSToolsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWeHaveAValidFMSForTestFMS() {
        guard let theURL = Bundle(for: self.dynamicType).urlForResource("test", withExtension: "fms") else {
            XCTFail("Bad URL")
            return
        }
        do {
            let _ = try FMSParse(url: theURL)
        }
        catch {
            XCTFail("\(error)")
        }
        
    }
    
    func testNumberOfExpectedWeightPointsForTestFMS() {
        guard let theURL = Bundle(for: self.dynamicType).urlForResource("test", withExtension: "fms") else {
            XCTFail("Bad URL")
            return
        }
        do {
            let resultArray = try FMSParse(url: theURL)
            XCTAssert(resultArray.count == 14,"resultArray should be 14, is \(resultArray.count)")
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testBuildFMSBasicStructureFromArray() {
        let testArray = ["11", "ALQUE", "0.000000", "41.5641111", "-88.1146667"]
        guard let testStructure = FMSWeighpoint(array: testArray) else {
            XCTFail("Did not properly init structure")
            return
        }
        XCTAssert(testStructure.type == .fix, "Type should be a fix, but is \(testStructure.type)" )
        XCTAssert(testStructure.id == "ALQUE", "ID should be a ALQUE, but is \(testStructure.id)" )
        XCTAssert(testStructure.altitude == 0, "altitude should be a 0.0, but is \(testStructure.altitude)" )
        XCTAssert(testStructure.latitude == 41.5641111, "latitude should be a 41.5641111, but is \(testStructure.latitude)" )
        XCTAssert(testStructure.longitude == -88.1146667, "longitude should be a -88.1146667, but is \(testStructure.longitude)" )
    }
    
    func testExpectedWeighpoint00ForTestFMS() {
        guard let theURL = Bundle(for: self.dynamicType).urlForResource("test", withExtension: "fms") else {
            XCTFail("Bad URL")
            return
        }
        do {
            let resultArray = try FMSParse(url: theURL)
            
            XCTAssert(resultArray[0].type == .airport, "Type should be a airport, but is \(resultArray[0].type)" )
            XCTAssert(resultArray[0].id == "KSTL", "ID should be a KSTL, but is \(resultArray[0].id)" )
            XCTAssert(resultArray[0].altitude == 0, "altitude should be a 0.0, but is \(resultArray[0].altitude)" )
            XCTAssert(resultArray[0].latitude == 38.7486972, "latitude should be a 38.7486972, but is \(resultArray[0].latitude)" )
            XCTAssert(resultArray[0].longitude == -90.3700289, "longitude should be a -90.3700289, but is \(resultArray[0].longitude)" )
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testExpectedWeighpoint04ForTestFMS() {
        guard let theURL = Bundle(for: self.dynamicType).urlForResource("test", withExtension: "fms") else {
            XCTFail("Bad URL")
            return
        }
        do {
            let resultArray = try FMSParse(url: theURL)
            //3 SPI 0.000000 39.8397222 -89.6777222
            XCTAssert(resultArray[4].type == .VOR, "Type should be a VOR, but is \(resultArray[0].type)" )
            XCTAssert(resultArray[4].id == "SPI", "ID should be a SPI, but is \(resultArray[0].id)" )
            XCTAssert(resultArray[4].altitude == 0, "altitude should be a 0.0, but is \(resultArray[0].altitude)" )
            XCTAssert(resultArray[4].latitude == 39.8397222, "latitude should be a 39.8397222, but is \(resultArray[0].latitude)" )
            XCTAssert(resultArray[4].longitude == -89.6777222, "longitude should be a -89.6777222, but is \(resultArray[0].longitude)" )
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testFMSWeighpointAutomaticIDStringPlusMinus() {
        let wpt = FMSWeighpoint.init(type: .airport,id: nil, altitude: 0, latitude: 38.7486972, longitude: -90.3700289)
        XCTAssert(wpt.id == "+38.749_-090.370","\(wpt.id) should be +38.749_-090.370")
    }
    
    func testFMSWeighpointAutomaticIDStringPlusPlus() {
        let wpt = FMSWeighpoint.init(type: .airport,id: nil, altitude: 0, latitude: 38.7486972, longitude: 90.3700289)
        XCTAssert(wpt.id == "+38.749_+090.370","\(wpt.id) should be +38.749_+090.370")
    }
    
    func testFMSWeighpointAutomaticIDStringMinusMinus() {
        let wpt = FMSWeighpoint.init(type: .airport,id: nil, altitude: 0, latitude: -38.7486972, longitude: -90.3700289)
        XCTAssert(wpt.id == "-38.749_-090.370","\(wpt.id) should be -38.749_-090.370")
    }
    
    
    func testFMSWriteToURL() {
        let theURL = URL.init(fileURLWithPath: "/tmp/test.fms")
        var weighpoints = [FMSWeighpointProtocol]()
        weighpoints.append(FMSWeighpoint.init(type: .airport,id: "KSTL", altitude: 0, latitude: 38.7486972, longitude: -90.3700289))
        weighpoints.append(FMSWeighpoint.init(type: .fix,id: "FUNKE", altitude: 0, latitude: 38.7275833, longitude: -90.2598889))
        weighpoints.append(FMSWeighpoint.init(type: .fix,id: "BEART", altitude: 0, latitude: 38.7597222, longitude: -90.2109167))
        weighpoints.append(FMSWeighpoint.init(type: .fix,id: "NATCA", altitude: 0, latitude: 39.3346667, longitude: -89.9980000))
        weighpoints.append(FMSWeighpoint.init(type: .VOR,id: "SPI", altitude: 0, latitude: 39.8397222, longitude: -89.6777222))
        
        weighpoints.append(FMSWeighpoint.init(type: .fix,id: "PHEEB", altitude: 0, latitude: 40.2641111, longitude: -89.2733333))
        weighpoints.append(FMSWeighpoint.init(type: .fix,id: "POOGY", altitude: 0, latitude: 40.3981667, longitude: -89.1436667))
        weighpoints.append(FMSWeighpoint.init(type: .fix,id: "NANEE", altitude: 0, latitude: 40.8674444, longitude: -88.8404444))
        weighpoints.append(FMSWeighpoint.init(type: .fix,id: "MMEGG", altitude: 0, latitude: 41.1707500, longitude: -88.6424167))
        weighpoints.append(FMSWeighpoint.init(type: .fix,id: "ENDEE", altitude: 0, latitude: 41.3740556, longitude: -88.5089722))
        weighpoints.append(FMSWeighpoint.init(type: .fix,id: "STKNY", altitude: 0, latitude: 41.5067778, longitude: -88.2904444))
        weighpoints.append(FMSWeighpoint.init(type: .fix,id: "ALQUE", altitude: 0, latitude: 41.5641111, longitude: -88.1146667))
        weighpoints.append(FMSWeighpoint.init(type: .fix,id: "BANER", altitude: 0, latitude: 41.6106111, longitude: -87.9720556))
        
        weighpoints.append(FMSWeighpoint.init(type: .airport,id: "KMDW", altitude: 0, latitude: 41.7859722, longitude: -87.7524167))
        
        FMSCreateFile(url: theURL, weighpoints: weighpoints)
        
        do {
            let resultArray = try FMSParse(url: theURL)
            //3 SPI 0.000000 39.8397222 -89.6777222
            XCTAssert(resultArray[4].type == .VOR, "Type should be a VOR, but is \(resultArray[40].type)" )
            XCTAssert(resultArray[4].id == "SPI", "ID should be a SPI, but is \(resultArray[4].id)" )
            XCTAssert(resultArray[4].altitude == 0, "altitude should be a 0.0, but is \(resultArray[4].altitude)" )
            XCTAssert(resultArray[4].latitude == 39.839722, "latitude should be a 39.8397222, but is \(resultArray[4].latitude)" )
            XCTAssert(resultArray[4].longitude == -89.677722, "longitude should be a -89.6777222, but is \(resultArray[4].longitude)" )
        }
        catch {
            XCTFail("\(error)")
        }


    }
    
}
