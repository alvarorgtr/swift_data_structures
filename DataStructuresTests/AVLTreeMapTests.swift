//
//  AVLTreeMapTests.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 29/10/16.
//  Copyright © 2016 DeltaApps. All rights reserved.
//

import XCTest
@testable import DataStructures

class AVLTreeMapTests: XCTestCase {
	var bigDict: [Int: String] = [:]
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
		
		for i in 1..<128 {
			bigDict[i] = "num\(i)"
		}
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testCreation() {
		let smallTree = AVLTreeMap<Int, String>(dictionary: [1: "One", 2: "Two", 3: "Three"])
		XCTAssertTrue(smallTree.count == 3 && smallTree.height == 1, "Wrong creation")
		XCTAssertEqual(smallTree.startNode?.key, 1, "Wrong start node")
		XCTAssertEqual(smallTree.endNode?.key, 3, "Wrong end node")
		XCTAssertEqual(smallTree[2], "Two", "The second value is wrong")
		XCTAssertAVLTree(smallTree)
		
		let bigTree = AVLTreeMap<Int, String>(dictionary: bigDict)
		XCTAssertTrue(bigTree.count == 127, "Wrong creation")
		XCTAssertEqual(bigTree.startNode?.key, 1, "Wrong start node")
		XCTAssertEqual(bigTree.endNode?.key, 127, "Wrong end node")
		
		for i in 1..<128 {
			XCTAssertEqual(bigTree[i], "num\(i)", "There is a wrong key value pair")
		}
		
		XCTAssertAVLTree(bigTree)
	}
	
	func testDictionaryLiteralConvertible() {
		let tree: AVLTreeMap<Int, String> = [1: "One", 2: "Two", 3: "Three"]
		XCTAssertTrue(tree.count == 3 && tree.height == 1, "Wrong creation")
		XCTAssertEqual(tree.startNode?.key, 1, "Wrong start node")
		XCTAssertEqual(tree.endNode?.key, 3, "Wrong end node")
		XCTAssertEqual(tree[2], "Two", "The second value is wrong")
		XCTAssertAVLTree(tree)
		
		let charTree: AVLTreeMap<Character, String> = ["A": "A", "B": "B", "C": "C", "D": "D", "E": "E"]
		XCTAssertTrue(charTree.count == 5, "Wrong creation")
		XCTAssertEqual(charTree.startNode?.key, "A", "Wrong start node")
		XCTAssertEqual(charTree.endNode?.key, "E", "Wrong end node")
		
		for i in "ABCDE".characters {
			XCTAssertEqual(String(i), charTree[i], "Key <\(i)> value is not '\(i)'")
		}
		
		XCTAssertAVLTree(charTree)
	}
	
	func testInsertion() {
		var tree = AVLTreeMap<Int, String>()
		
		// Insert
		for i in 16..<40 {
			tree[i] = "num\(i)"
			XCTAssertAVLTree(tree)
		}
		
		for i in 1..<8 {
			tree[i] = "num\(i)"
			XCTAssertAVLTree(tree)
		}
		
		for i in 50..<64 {
			tree[i] = "num\(i)"
			XCTAssertAVLTree(tree)
		}
		
		for i in 8..<16 {
			tree[i] = "num\(i)"
			XCTAssertAVLTree(tree)
		}
		
		for i in 40..<50 {
			tree[i] = "num\(i)"
			XCTAssertAVLTree(tree)
		}
		
		// Check everything is inserted
		for i in 1..<64 {
			XCTAssertEqual("num\(i)", tree[i], "Value for \(i) is not 'num\(i)'")
		}
		
		XCTAssertTrue(tree.count == 63)
		XCTAssertEqual(tree.startNode?.key, 1, "Wrong start node")
		XCTAssertEqual(tree.endNode?.key, 63, "Wrong end node")
	}
	
	func testUnorderedInsertion() {
		var tree = AVLTreeMap<Int, String>()
		let randoms = [44, 32, 57, 76, 15,  5, 72, 20, 54,  7, 65, 23, 93, 97, 61, 27, 69, 62, 96, 33, 91, 94, 87, 55, 51, 86, 10, 66, 46, 58, 34, 73, 45, 22, 53, 47, 14, 75, 41,  8, 71, 43, 63, 16,  1,  6, 59, 68, 24, 42, 18,  2, 30, 99, 49, 13, 89, 92, 88, 25,  9, 60, 77,  3, 95, 56, 67, 37, 82, 39, 19, 85, 83,  4, 38, 48, 31, 50, 80, 79, 40, 12, 52, 26, 17, 78, 84, 29, 21, 11, 81, 90, 70, 98,100, 36, 64, 28, 35, 74]
		
		for i in randoms {
			tree[i] = "num\(i)"
			XCTAssertAVLTree(tree)
		}
		
		for i in 1...100 {
			XCTAssertEqual("num\(i)", tree[i], "Value for \(i) is not 'num\(i)'")
		}
		
		XCTAssertTrue(tree.count == randoms.count, "Incorrect number of elements")
		XCTAssertEqual(tree.startNode?.key, 1, "Wrong start node")
		XCTAssertEqual(tree.endNode?.key, 100, "Wrong end node")
		
		
		var another = AVLTreeMap<Int, String>()
		let anotherRands = [94,  1, 12, 83, 49,  9,100, 10, 82, 63, 24, 72, 78, 74, 20, 89, 61, 80, 46, 93, 56, 92, 95, 14,  5, 88, 67, 19, 26, 45, 27, 34, 39, 81, 64, 47, 51, 90, 42, 75, 76, 28, 59,  3, 29, 48, 36, 79, 60, 52, 66, 86, 15, 33, 17, 43,  6, 40, 85, 11, 53, 71, 21, 16, 25, 18, 98, 31,  4, 23, 58, 41, 68, 91, 32,  7, 73, 13, 57, 69, 38, 62, 96, 55, 84, 65, 54, 35, 37, 30, 97,  8,  2, 50, 22, 70, 44, 87, 77, 99]
		
		for i in anotherRands {
			another[i] = "num\(i)"
			XCTAssertAVLTree(another)
		}
		
		for i in 1...100 {
			XCTAssertEqual("num\(i)", another[i], "Value for \(i) is not 'num\(i)'")
		}
		
		XCTAssertTrue(another.count == anotherRands.count, "Incorrect number of elements")
		XCTAssertEqual(another.startNode?.key, 1, "Wrong start node")
		XCTAssertEqual(another.endNode?.key, 100, "Wrong end node")
	}
	
	func testIteration() {
		let bigTree = AVLTreeMap<Int, String>(dictionary: bigDict)
		var previousKey = 0
		var count = 0
		
		for (key, _) in bigTree {
			XCTAssertTrue(key == previousKey + 1, "After key \(previousKey) comes key \(key)")
			previousKey = key
			count += 1
		}
		
		XCTAssertTrue(count == bigTree.count, "Iterates over more elements than the supposed number of elements inside the tree")
		
		var tree1 = AVLTreeMap<Int, String>(dictionary: bigDict)
		let randoms1 = [44, 32, 57, 76, 15,  5, 72, 20, 54,  7, 65, 23, 93, 97, 61, 27, 69, 62, 96, 33, 91, 94, 87, 55, 51, 86, 10, 66, 46, 58, 34, 73, 45, 22, 53, 47, 14, 75, 41,  8, 71, 43, 63, 16,  1,  6, 59, 68, 24, 42, 18,  2, 30, 99, 49, 13, 89, 92, 88, 25,  9, 60, 77,  3, 95, 56, 67, 37, 82, 39, 19, 85, 83,  4, 38, 48, 31, 50, 80, 79, 40, 12, 52, 26, 17, 78, 84, 29, 21, 11, 81, 90, 70, 98,100, 36, 64, 28, 35, 74]
		
		for i in randoms1 {
			tree1[i] = "num\(i)"
		}
		
		previousKey = 0
		
		for (key, _) in tree1 {
			XCTAssertTrue(key == previousKey + 1, "After key \(previousKey) comes key \(key)")
			previousKey = key
		}
		
		XCTAssertTrue(count == tree1.count, "Iterates over more elements than the supposed number of elements inside the tree")
	}
	
	func testReverseIteration() {
		
	}
	
	func testEqualityReflexivity() {
		let bigTree = AVLTreeMap<Int, String>(dictionary: bigDict)
		XCTAssertTrue(bigTree == bigTree, "Equals is not reflexive")
	}
	
	func testEquality() {
		// We generate two trees from different unordered arrays
		// The trees are different but contain the same items
		// And should be equal
		var tree1 = AVLTreeMap<Int, String>()
		let randoms1 = [44, 32, 57, 76, 15,  5, 72, 20, 54,  7, 65, 23, 93, 97, 61, 27, 69, 62, 96, 33, 91, 94, 87, 55, 51, 86, 10, 66, 46, 58, 34, 73, 45, 22, 53, 47, 14, 75, 41,  8, 71, 43, 63, 16,  1,  6, 59, 68, 24, 42, 18,  2, 30, 99, 49, 13, 89, 92, 88, 25,  9, 60, 77,  3, 95, 56, 67, 37, 82, 39, 19, 85, 83,  4, 38, 48, 31, 50, 80, 79, 40, 12, 52, 26, 17, 78, 84, 29, 21, 11, 81, 90, 70, 98,100, 36, 64, 28, 35, 74]
		
		for i in randoms1 {
			tree1[i] = "num\(i)"
		}
		
		var tree2 = AVLTreeMap<Int, String>()
		let randoms2 = [94,  1, 12, 83, 49,  9,100, 10, 82, 63, 24, 72, 78, 74, 20, 89, 61, 80, 46, 93, 56, 92, 95, 14,  5, 88, 67, 19, 26, 45, 27, 34, 39, 81, 64, 47, 51, 90, 42, 75, 76, 28, 59,  3, 29, 48, 36, 79, 60, 52, 66, 86, 15, 33, 17, 43,  6, 40, 85, 11, 53, 71, 21, 16, 25, 18, 98, 31,  4, 23, 58, 41, 68, 91, 32,  7, 73, 13, 57, 69, 38, 62, 96, 55, 84, 65, 54, 35, 37, 30, 97,  8,  2, 50, 22, 70, 44, 87, 77, 99]
		
		for i in randoms2 {
			tree2[i] = "num\(i)"
		}
		
		tree1.log()
		tree2.log()
		XCTAssertTrue(tree1 == tree2, "Two equal trees compare different")
	}
}

extension AVLTreeMap {
	var isBinarySearchTree: Bool {
		return root?.isBinarySearchTree ?? true
	}
	
	var isHeightBalanced: Bool {
		return root?.isHeightBalanced ?? true
	}
}


extension AVLTreeNode {
	var isBinarySearchTree: Bool {
		get {
			if let leftChild = leftChild, leftChild.key >= key {
				return false
			}
			
			if let rightChild = rightChild, rightChild.key <= key {
				return false
			}
			
			return (leftChild?.isBinarySearchTree ?? true) && (rightChild?.isBinarySearchTree ?? true)
		}
	}
	
	var isHeightBalanced: Bool {
		get {
			let leftHeight = leftChild?.height ?? -1
			let rightHeight = rightChild?.height ?? -1
			
			if abs(rightHeight - leftHeight) > 1 {
				return false
			}
			
			return (leftChild?.isHeightBalanced ?? true) && (rightChild?.isHeightBalanced ?? true)
		}
	}
}




/// Asserts that a AVLTreeMap is indeed an AVL tree, that is, checks if it is a binary search
/// tree and if it is height-balanced.
///
/// - parameter tree:    The tree to be checked.
/// - parameter message: An optional description of the failure.
/// - parameter file:    The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
/// - parameter line:    The line number on which failure occurred. Defaults to the line number on which this function was called.
private func XCTAssertAVLTree<Key: Comparable, Value>(_ tree: AVLTreeMap<Key, Value>, _ message: String? = nil, file: StaticString = #file, line: UInt = #line) {
	XCTAssertTrue(tree.isBinarySearchTree, message ?? "The tree is not a BST", file: file, line: line)
	XCTAssertTrue(tree.isHeightBalanced, message ?? "The tree is not height-balanced", file: file, line: line)
}
