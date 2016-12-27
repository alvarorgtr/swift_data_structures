//
//  TreeNode.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 27/12/16.
//  Copyright © 2016 DeltaApps. All rights reserved.
//

import Foundation

public protocol TreeNode: class {
	associatedtype Key: Comparable
	associatedtype Value
	
	var leftChild: Self? { get set }
	var rightChild: Self? { get set }
	weak var parent: Self? { get }
	
	var key: Key { get set }
	var value: Value { get set }
	var keyValue: (Key, Value) { get }
	
	var next: Self? { get }
	var previous: Self? { get }
	
	/// - complexity: O(log n) when balanced.
	var depth: Int { get }
	
	/// - complexity: O(1) (stored)
	var height: Int { get }
	
	var minimum: Self { get }
	var maximum: Self { get }
	
	init(key: Key, value: Value)
}

extension TreeNode {
	var keyValue: (Key, Value) {
		return (key, value)
	}
	
	var next: Self? {
		get {
			var newNode: Self?
			
			if let right = rightChild {
				newNode = right.minimum
			} else {
				var child = self
				
				while let parent = child.parent {
					if key < parent.key {
						newNode = parent
						break
					}
					
					child = parent
				}
			}
			
			return newNode
		}
	}
	
	var previous: Self? {
		get {
			var newNode: Self?
			
			if let left = leftChild {
				newNode = left.maximum
			} else {
				var child = self
				
				while let parent = child.parent {
					if key > parent.key {
						newNode = parent
						break
					}
					
					child = parent
				}
			}
			
			return newNode
		}
	}
	
	var minimum: Self {
		get {
			if let left = leftChild {
				return left.minimum
			} else {
				return self
			}
		}
	}
	
	var maximum: Self {
		get {
			if let right = rightChild {
				return right.maximum
			} else {
				return self
			}
		}
	}
	
	var depth: Int {
		if let parent = parent {
			return parent.depth + 1
		} else {
			return 0
		}
	}
}
