//
//  TreeIndex.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 27/12/16.
//  Copyright © 2016 DeltaApps. All rights reserved.
//

import Foundation

public protocol TreeIndex: Strideable {
	associatedtype Node: TreeNode
	associatedtype Stride: SignedInteger = Int
	
	var node: Node? { get set }
	var previousNode: Node? { get set }
	
	var next: Self { get }
	var previous: Self { get }
	
	init(_ node: Node?, previous: Node?)
}

extension TreeIndex where Node: BinaryTreeNode {
	/// - complexity: Amortized O(1)
	internal func next() -> Self {
		precondition(node != nil)
		return Self(node?.next, previous: node)
	}
	
	/// - complexity: Amortized O(1)
	internal func previous() -> Self {
		precondition(previousNode != nil)
		return Self(node?.previous, previous: node)
	}
	
	static func ==(lhs: Self, rhs: Self) -> Bool {
		return lhs.node === rhs.node
	}
	
	static func <(lhs: Self, rhs: Self) -> Bool {
		if let lkey = lhs.node?.key, let rkey = rhs.node?.key {
			return lkey < rkey
		} else {
			return lhs.node != nil
		}
	}
	
	public func distance(to other: Self) -> Stride {
		var count: Stride = 0
		var startIndex: Self
		var endIndex: Self
		
		if let selfKey = node?.key, let otherKey = other.node?.key {
			if selfKey > otherKey {
				startIndex = other
				endIndex = self
			} else {
				startIndex = self
				endIndex = other
			}
		} else if node == nil {
			// This is the last one
			startIndex = other
			endIndex = self
		} else {	// Other is nil
			startIndex = self
			endIndex = other
		}
		
		while startIndex != endIndex {
			// If startIndex.node == nil => endIndex is too
			count = count.advanced(by: 1)
			startIndex = startIndex.next
		}
		
		return count
	}
}

extension TreeIndex where Stride == Int {
	public func advanced(by n: Stride) -> Self {
		var index: Self = self
		for _ in 0..<n {
			index = index.next
		}
		return self
	}
}
