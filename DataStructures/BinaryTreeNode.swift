//
//  BinaryTreeNode.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 11/2/17.
//  Copyright © 2017 DeltaApps. All rights reserved.
//

import Foundation

public protocol BinaryTreeNode: TreeNode {
	var leftChild: Self? { get set }
	var rightChild: Self? { get set }
	
	var key: Key { get set }
	var value: Value { get set }
	var keyValue: (Key, Value) { get }
	
	var next: Self? { get }
	var previous: Self? { get }
	
	init(key: Key, value: Value)
}

/**
A tree node with a single key-value pair and at most 2 children. 
*/
extension BinaryTreeNode {
	/** An array of the form `[leftChild, rightChild]`. It's preferred to use the corresponding accessors.
	- precondition: On set, the new value must be an array of size 2.
	*/
	var children: [Self?] {
		get {
			return [leftChild, rightChild]
		}
		
		set {
			precondition(newValue.count == 2)
			leftChild = newValue[0]
			rightChild = newValue[1]
		}
	}
	
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
}
