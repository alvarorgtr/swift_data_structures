//
//  TreeCollection.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 27/12/16.
//  Copyright © 2016 DeltaApps. All rights reserved.
//

import Foundation

public protocol TreeMapCollection: BidirectionalCollection, DictionaryCollection {
	associatedtype Iterator: TreeIterator

	associatedtype Index = Self.Iterator.Index
	associatedtype Node = Self.Iterator.Index.Node
	associatedtype Element = (Self.Iterator.Index.Node.Key, Self.Iterator.Index.Node.Value)
	associatedtype Key = Self.Iterator.Index.Node.Key
	associatedtype Value = Self.Iterator.Index.Node.Value
	
	var root: Node? { get }
	
	var startNode: Node { get }
	var endNode: Node { get }
	
	var height: Int { get }
}

public extension TreeMapCollection where Node: TreeNode {
	var height: Int {
		get {
			return root?.height ?? -1
		}
	}
}
