//
//  XPEarthFixTest.swift
//  FSTools
//
//  Created by Thomas Moore on 6/27/16.
//  Copyright © 2016 Thomas Moore. All rights reserved.
//

import XCTest
@testable import FSTools

class XPEarthFixTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }


    func testXPFixStructWithStrings() {
        let testStrings = [" 36.117167 -088.245167 00004"," 46.189999  002.089444 GUERE"," 41.691667  067.201944 RITAL","-22.000000  110.000000 WONSA","99"]
        if let testFix = XPFix.init(string:testStrings[0]) {
            XCTAssert(testFix.latitude == 36.117167,"fix latitude should be 36.117167, but is \(testFix.latitude)")
            XCTAssert(testFix.longitude == -88.245167,"fix longitude should be -88.245167, but is \(testFix.longitude)")
            XCTAssert(testFix.id == "00004","fix id should be 00004, but is \(testFix.id)")
        }
        if let testFix = XPFix.init(string:testStrings[1]) {
            XCTAssert(testFix.latitude == 46.189999,"fix latitude should be 46.189999, but is \(testFix.latitude)")
            XCTAssert(testFix.longitude == 2.089444,"fix longitude should be 002.089444, but is \(testFix.longitude)")
            XCTAssert(testFix.id == "GUERE","fix id should be GUERE, but is \(testFix.id)")
        }
        if let testFix = XPFix.init(string:testStrings[2]) {
            XCTAssert(testFix.latitude == 41.691667,"fix latitude should be 41.691667, but is \(testFix.latitude)")
            XCTAssert(testFix.longitude == 67.201944,"fix longitude should be 67.201944, but is \(testFix.longitude)")
            XCTAssert(testFix.id == "RITAL","fix id should be RITAL, but is \(testFix.id)")
        }
        if let testFix = XPFix.init(string:testStrings[3]) {
            XCTAssert(testFix.latitude == -22.000000,"fix latitude should be -22.000000, but is \(testFix.latitude)")
            XCTAssert(testFix.longitude == 110.000000,"fix longitude should be 110.000000, but is \(testFix.longitude)")
            XCTAssert(testFix.id == "WONSA","fix id should be WONSA, but is \(testFix.id)")
        }
        if let _ = XPFix.init(string:testStrings[4]) {
            XCTFail("Should not have returned a struct")
        }

    }
    
    func testLoadSampleFixFile() {
        guard let theURL = Bundle(for: self.dynamicType).urlForResource("earth_fix_example", withExtension: "dat") else {
            XCTFail("Bad URL")
            return
        }
        do {
            let result = try parseXPEarthFix(url: theURL)
            let ids = ["00004","00005","00006","00007","00009","0000E"]
            for (index, anId) in ids.enumerated() {
                XCTAssert(result[index].id == anId,"Id should be \(anId) but is \(result[index].id)")
            }


            
            
            
        }
        catch {
            XCTFail("\(error)")
        }
    }

}
