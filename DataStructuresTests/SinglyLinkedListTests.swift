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
		list.prepend(2)
		XCTAssertEqual(list.count, 1, "Correct element count")
	}
	
	func testPushAndPop() {
		var list = SinglyLinkedList<Int>()
		list.prepend(3)
		list.prepend(2)
		list.prepend(1)
		list.prepend(0)
		
		for i in 0...3 {
			XCTAssertEqual(list.deleteFirst(), i, "The \(i)th popped element must be \(i)")
		}
		
		XCTAssertEqual(list.count, 0, "The list must be empty at the end")
	}
	
	func testIteration() {
		var list = SinglyLinkedList<Int>()
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
	
	func testEmptiness() {
		var list = SinglyLinkedList<Int>()
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
		let list: SinglyLinkedList<Int> = [0, 1, 2, 3]
		var count = 0
		
		for i in list {
			XCTAssertEqual(i, count, "The \(count)th element must be \(count)")
			count += 1
		}
	}
	
	func testCustomStringConvertible() {
		let list: SinglyLinkedList<Int> = [0, 1, 2, 3]
		XCTAssertEqual(list.description, "[0, 1, 2, 3]")
	}
	
	func testRepeatedValueInit() {
		let list = SinglyLinkedList<Int>(count: 10, repeatedValue: 2)
		
		XCTAssertEqual(list.count, 10, "There should be 10 values")
		XCTAssertEqual(list.first, 2, "The first value should be 2")
	}
	
	func testOtherSequenceInit() {
		let otherList: SinglyLinkedList<Int> = [0, 1, 2, 3]
		let list = SinglyLinkedList<Int>(otherList)
		var count = 0
		
		for i in list {
			XCTAssertEqual(i, count, "The \(count)th element must be \(count)")
			count += 1
		}
		XCTAssertEqual(list.count, otherList.count, "The counts should be equal")
		
		count = 0
		let list2 = SinglyLinkedList<Int>(0...3)
		for i in list2 {
			XCTAssertEqual(i, count, "The \(count)th element must be \(count)")
			count += 1
		}
		XCTAssertEqual(list2.count, 4, "The counts should be equal")
	}
	
	func testCopyBehaviour() {
		var list: SinglyLinkedList<Int> = [0, 1, 2, 3]
		let copy = list
		
		list.deleteFirst()
		
		XCTAssertEqual(list.description, "[1, 2, 3]", "The first element should have disappeared")
		XCTAssertEqual(list.count, 3)
		XCTAssertEqual(copy.description, "[0, 1, 2, 3]", "The copy should not have changed")
		XCTAssertEqual(copy.count, 4)
	}
	
	func testEqualOperator() {
		let list: SinglyLinkedList<Int> = [0, 1, 2, 3]
		XCTAssert(list == list, "Equality should be transitive")
		XCTAssert(list == SinglyLinkedList<Int>([0, 1, 2, 3]), "The list should be equal to another list with the same elements")
	}
}
