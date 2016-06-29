//
//  ForwardListTests.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 29/6/16.
//  Copyright © 2016 DeltaApps. All rights reserved.
//

import XCTest
@testable import DataStructures

class SinglyLinkedListTests: XCTestCase {
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testCreation() {
		var list = SinglyLinkedList<Int>()
		list.pushFront(2)
		XCTAssertEqual(list.count, 1, "Correct element count")
	}
	
	func testPushAndPop() {
		var list = SinglyLinkedList<Int>()
		list.pushFront(3)
		list.pushFront(2)
		list.pushFront(1)
		list.pushFront(0)
		
		for i in 0...3 {
			XCTAssertEqual(list.popFront(), i, "The \(i)th popped element must be \(i)")
		}
		
		XCTAssertEqual(list.count, 0, "The list must be empty at the end")
	}
	
	func testIteration() {
		var list = SinglyLinkedList<Int>()
		list.pushFront(3)
		list.pushFront(2)
		list.pushFront(1)
		list.pushFront(0)
		var count = 0
		
		for i in list {
			XCTAssertEqual(i, count, "The \(count)th popped element must be \(count) (while iterating)")
			count += 1
		}
	}
	
	func testEmptiness() {
		var list = SinglyLinkedList<Int>()
		list.pushFront(2)
		list.pushFront(-1)
		
		XCTAssert(!list.isEmpty, "The list shouldn't be empty")
		
		list.popFront()
		list.pushFront(23)
		list.popFront()
		list.popFront()

		XCTAssert(list.isEmpty, "The list should be empty")
		XCTAssertEqual(list.count, 0, "Also the list should have no elements")
	}
}
