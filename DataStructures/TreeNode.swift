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
	
	var children: [Self?] { get set }
	weak var parent: Self? { get }

	/** - complexity: O(log n) when balanced (default implementation)
	*/
	var depth: Int { get }
	
	/** - complexity: O(log n) when balanced (default implementation)
	*/
	var height: Int { get }
	
	var minimum: Self { get }
	var maximum: Self { get }
}

extension TreeNode {
	var depth: Int {
		if let parent = parent {
			return parent.depth + 1
		} else {
			return 0
		}
	}
	
	var height: Int {
		return children.map { (node) -> Int in return node?.height ?? -1 }.max() ?? -1 + 1
	}
}
