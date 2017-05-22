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
	
	private var pNumbers: [Int] = []
    
	var numbers: [Int] {
		if pNumbers.count == 0 {
			if let path = Bundle(for: FibonacciHeapTests.self).path(forResource: "random3000", ofType: "txt") {
				do {
					let contents = try String(contentsOfFile: path)
					pNumbers = contents.components(separatedBy: CharacterSet.newlines).dropLast().map({ Int($0)! })
				} catch {
					fatalError("File could not be loaded for FibonacciHeap testing")
				}
			}
		}
		
		return pNumbers
	}
	
	func testCreation() {
		let heap = FibonacciHeap<Int, Int>()
		XCTAssertEqual(heap.count, 0, "The count should be 0")
		
		let heap2 = FibonacciHeap<Int, Int>(comparator: { $0 > $1 })
		XCTAssertEqual(heap2.count, 0, "The count should be 0")
		
		let heap3 = FibonacciHeap<Float, String>(comparator: { $0.characters.count < $1.characters.count })
		XCTAssertEqual(heap3.count, 0, "The count should be 0")
	}
	
	func testBasicInsertion() {
		let heap = FibonacciHeap<String, Int>()
		insertAndAssert((0...200).reversed(), on: heap)
		
		let heap2 = FibonacciHeap<String, Int>(comparator: { $0 > $1 })
		insertAndAssert(stride(from: -500, to: 500, by: 5), on: heap2)
		
		let heap3 = FibonacciHeap<String, Double>()
		insertAndAssert((0...100).map({ pow(2, -0.2 * Double($0)) }), on: heap3)
	}
	
	private func insertAndAssert<P: Comparable, S: Sequence>(_ values: S, on heap: FibonacciHeap<String, P>) where S.Iterator.Element == P {
		var min: P?
		var minLabel: String?
		
		for (index, priority) in values.enumerated() {
			heap.insert("\(priority)", with: priority)
			XCTAssertEqual(heap.count, index + 1, "The count is not correct")
			
			if min == nil || heap.less(priority, min!) {
				min = priority
				minLabel = "\(priority)"
			}
			
			if let minimum = heap.minimum {
				XCTAssertEqual(minimum, minLabel, "The minimum is not correct")
			} else {
				XCTFail("There should be a minimum")
			}
		}
	}
	
	func testInsertAndRemove() {
		let heap = FibonacciHeap<Int, Int>()
		insertAndRemoveAsserting((0...200).reversed(), on: heap)
		
		let heap2 = FibonacciHeap<Int, Int>(comparator: { $0 > $1 })
		self.insertAndRemoveAsserting(stride(from: -500, to: 500, by: 5), on: heap2)
		
		let heap3 = FibonacciHeap<Double, Double>()
		insertAndRemoveAsserting((0...100).map({ pow(2, -0.2 * Double($0)) }), on: heap3)
	}
	
	private func insertAndRemoveAsserting<T: Hashable, S: Sequence>(_ values: S, on heap: FibonacciHeap<T, T>) where S.Iterator.Element == T {
		for elem in values {
			heap.insert(elem, with: elem)
		}
		
		var lastExtracted: T?
		if !heap.isEmpty {
			lastExtracted = heap.extractMinimum()
		}
		for _ in 0..<heap.count {
			if let extracted = heap.extractMinimum() {
				XCTAssertTrue(heap.less(lastExtracted!, extracted), "We can't have extracted something smaller")
				lastExtracted = extracted
			}
		}
	}
	
	func testBigRandomData() {
		let heap = FibonacciHeap<Int, Int>()
		self.insertAndRemoveAsserting(numbers, on: heap)
		
		let heap2 = FibonacciHeap<Int, Int>(comparator: { $0 > $1 })
		self.insertAndRemoveAsserting(numbers, on: heap2)
	}
	
	func testUnion() {
		let heap1 = FibonacciHeap<Int, Int>()
		let heap2 = FibonacciHeap<Int, Int>()
		
		for i in 0..<numbers.count {
			if i % 2 == 0 {
				heap1.insert(i, with: i)
			} else {
				heap2.insert(i, with: i)
			}
		}
		
		let union = heap1.union(heap2)
		XCTAssertEqual(union.count, numbers.count, "The union count is wrong")
		
		var lastExtracted: Int?
		if !union.isEmpty {
			lastExtracted = union.extractMinimum()
		}
		for _ in 0..<union.count {
			if let extracted = union.extractMinimum() {
				XCTAssertTrue(union.less(lastExtracted!, extracted), "We can't have extracted something smaller")
				lastExtracted = extracted
			}
		}
	}
	
	func testDecreasePriority() {
		let heap = FibonacciHeap<Int, Int>()
		for elem in numbers {
			heap.insert(elem, with: elem)
		}
		
		// Force reorder
		let min = heap.extractMinimum()!
		heap.insert(min, with: min)
		
		for (i, number) in numbers.reversed().enumerated() {
			heap.decreasePriority(of: number, to: heap.priority(of: number)! - 100)
			
			if i % 100 == 0 {
				// Force reorder
				let (min, priority) = heap.extractMinimumAndPriority()!
				heap.insert(min, with: priority)
			}
		}
		
		var lastPriority: Int?
		lastPriority = heap.extractMinimumAndPriority()!.1
		
		for _ in 0..<heap.count {
			if let priority = heap.extractMinimumAndPriority()?.1 {
				XCTAssertTrue(heap.less(lastPriority!, priority), "We can't have extracted something smaller")
				lastPriority = priority
			}
		}
	}
}
