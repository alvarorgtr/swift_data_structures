//
//  FibonacciHeapTests.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 28/4/17.
//  Copyright © 2017 DeltaApps. All rights reserved.
//

import XCTest
@testable import DataStructures

class FibonacciHeapTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /* func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    */
	
	func testLittleLittleThings() {
		var heap = FibonacciHeap<Int>()
		
		heap.insert(4)
		heap.insert(32)
		heap.insert(25)
		heap.insert(1)
		
		var heap2 = FibonacciHeap<Int>()
		
		heap2.insert(6)
		heap2.insert(24)
		heap2.insert(2)
		heap2.insert(33)
		
		var heap3 = heap.union(heap2)
		heap3.extractMinimum()
		heap3.extractMinimum()
		heap3.extractMinimum()
		heap3.insert(42)
		heap3.insert(1)
		heap3.insert(10)
		heap3.insert(31)
		heap3.extractMinimum()
		heap3.insert(11)
		heap3.extractMinimum()
		heap3.extractMinimum()
	}
}
