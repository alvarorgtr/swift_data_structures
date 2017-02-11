//
//  TreeIterator.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 11/2/17.
//  Copyright © 2017 DeltaApps. All rights reserved.
//

import Foundation

public protocol TreeIterator: IteratorProtocol {
	associatedtype Index: TreeIndex
	associatedtype Element = (Index.Node.Key, Index.Node.Value)
	
	var index: Index { get set }
}

public extension TreeIterator where Element == (Index.Node.Key, Index.Node.Value), Index.Node: BinaryTreeNode {
	mutating func next() -> Self.Element? {
		if let node = index.node {
			index = index.next
			return node.keyValue
		}
		
		return nil
	}
}
