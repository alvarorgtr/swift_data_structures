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
		XCTAssertTrue(charTree.count == 3, "Wrong creation")
		XCTAssertEqual(charTree.startNode?.key, "A", "Wrong start node")
		XCTAssertEqual(charTree.endNode?.key, "E", "Wrong end node")
		
		for i in "ABCDE".characters {
			XCTAssertEqual(String(i), charTree[i], "Key <\(i)> value is not '\(i)'")
		}
		
		XCTAssertAVLTree(charTree)
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
