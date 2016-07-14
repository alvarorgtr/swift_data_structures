//
//  ListTests.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 29/6/16.
//  Copyright © 2016 DeltaApps. All rights reserved.
//

import XCTest
@testable import DataStructures

class DoublyLinkedListTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testCreation() {
		var list = List<Int>()
		list.prepend(2)
		XCTAssertEqual(list.count, 1, "Correct element count")
	}
	
	func testPrepend() {
		var list = List<Int>()
		list.prepend(3)
		list.prepend(2)
		list.prepend(1)
		list.prepend(0)
		
		for i in 0...3 {
			XCTAssertEqual(list.deleteFirst(), i, "The \(i)th popped element must be \(i)")
		}
		
		XCTAssertEqual(list.count, 0, "The list must be empty at the end")
	}
	
	func testAppend() {
		var list = List<Int>()
		list.append(3)
		list.append(2)
		list.append(1)
		list.append(0)
		
		for i in 0...3 {
			XCTAssertEqual(list.deleteLast(), i, "The \(i)th popped element must be \(i)")
		}
		
		XCTAssertEqual(list.count, 0, "The list must be empty at the end")
	}
	
	func testCustomStringConvertible() {
		var list = List<Int>()
		
		XCTAssertEqual(list.description, "[]", "An empty list's description should be \"[]\"")
		
		list.prepend(3)
		list.prepend(2)
		list.prepend(1)
		list.prepend(0)
		
		XCTAssertEqual(list.description, "[0, 1, 2, 3]", "The list should be of the form \"[0, 1, 2, 3]\"")
	}
	
	func testAppendAndPrepend() {
		var list = List<Int>()
		list.append(0)
		list.append(1)
		list.prepend(-1)
		list.deleteLast()
		list.deleteFirst()
		
		XCTAssertEqual(list.description, "[0]", "The list should be of the form \"[0]\"")
		
		list.prepend(-2)
		list.append(2)
		list.deleteLast()
		list.deleteLast()
		list.append(3)
		
		XCTAssertEqual(list.description, "[-2, 3]", "The list should be of the form \"[-2, 3]\"")
	}
	
	func testIteration() {
		var list = List<Int>()
		list.prepend(3)
		list.prepend(2)
		list.prepend(1)
		list.prepend(0)
		var count = 0
		
		for i in list {
			XCTAssertEqual(i, count, "The \(count)th element must be \(count) (while iterating)")
			count += 1
		}
	}
	
	func testReverseIteration() {
		var list = List<Int>()
		list.prepend(0)
		list.prepend(1)
		list.prepend(2)
		list.prepend(3)
		
		var count = 0
		
		for element in list.generateReverse() {
			XCTAssertEqual(element, count, "The \(count)th element must be \(count) (while iterating)")
			count += 1
		}
	}
	
	func testReverseFunction() {
		var list = List<Int>()
		list.prepend(0)
		list.prepend(1)
		list.prepend(2)
		list.prepend(3)
		
		var count = 0
		
		for element in list.reverse() {
			XCTAssertEqual(element, count, "The \(count)th element must be \(count) (while iterating)")
			count += 1
		}
	}
	
	func testEmptiness() {
		var list = List<Int>()
		list.prepend(2)
		list.prepend(-1)
		
		XCTAssert(!list.isEmpty, "The list shouldn't be empty")
		
		list.deleteFirst()
		list.prepend(23)
		list.deleteFirst()
		list.deleteFirst()
		
		XCTAssert(list.isEmpty, "The list should be empty")
		XCTAssertEqual(list.count, 0, "Also the list should have no elements")
	}
	
	func testArrayLiteralConvertible() {
		let list: List<Int> = [0, 1, 2, 3]
		var count = 0
		
		for i in list {
			XCTAssertEqual(i, count, "The \(count)th element must be \(count)")
			count += 1
		}
	}
	
	func testRepeatedValueInit() {
		let list = List<Int>(count: 10, repeatedValue: 2)
		
		XCTAssertEqual(list.count, 10, "There should be 10 values")
		XCTAssertEqual(list.first(), 2, "The first value should be 2")
		XCTAssertEqual(list.last(), 2, "The last value should be 2")
	}
	
	func testOtherSequenceInit() {
		let otherList: List<Int> = [0, 1, 2, 3]
		let list = List<Int>(otherList)
		var count = 0
		
		for i in list {
			XCTAssertEqual(i, count, "The \(count)th element must be \(count)")
			count += 1
		}
		XCTAssertEqual(list.count, otherList.count, "The counts should be equal")
		
		count = 0
		let list2 = List<Int>(0...3)
		for i in list2 {
			XCTAssertEqual(i, count, "The \(count)th element must be \(count)")
			count += 1
		}
		XCTAssertEqual(list2.count, 4, "The counts should be equal")
	}
	
	func testPoppingEmptyList() {
		var list = List<Int>()
		expectFatalError {
			list.deleteFirst()
		}
		
		expectFatalError {
			list.deleteLast()
		}
	}
	
	func testCopyBehaviour() {
		var list: List<Int> = [0, 1, 2, 3]
		let copy = list
		
		list.deleteFirst()
		
		XCTAssertEqual(list.description, "[1, 2, 3]", "The first element should have disappeared")
		XCTAssertEqual(list.count, 3)
		XCTAssertEqual(copy.description, "[0, 1, 2, 3]", "The copy should not have changed")
		XCTAssertEqual(copy.count, 4)
	}
	
	func testEqualOperator() {
		let list: List<Int> = [0, 1, 2, 3]
		XCTAssert(list == list, "Equality should be transitive")
		XCTAssert(list == List<Int>([0, 1, 2, 3]), "The list should be equal to another list with the same elements")
	}
}
