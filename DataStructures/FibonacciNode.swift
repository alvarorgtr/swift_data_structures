//
//  FibonacciNode.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 28/4/17.
//  Copyright © 2017 DeltaApps. All rights reserved.
//

import Foundation

internal class FibonacciNode<Element: Equatable, Priority> {
	typealias Node = FibonacciNode<Element, Priority>
	
	var key: Element
	var priority: Priority
	var parent: Node?
	var child: Node?
	var left: Node!
	var right: Node!
	var degree: Int
	var marked: Bool
	
	required init(key: Element, priority: Priority, parent: Node? = nil, child: Node? = nil, left: Node? = nil, right: Node? = nil, degree: Int = 0) {
		self.key = key
		self.priority = priority
		self.parent = parent
		self.child = child
		self.degree = degree
		self.marked = false
		self.left = left ?? self
		self.right = right ?? self
	}
}

extension FibonacciNode: CustomDebugStringConvertible {
	var debugDescription: String {
		var string = "([\(key), \(priority)]"
		
		if let child = child {
			string += ":"
			var node = child
			string += " \(node.debugDescription)"
			node = node.right
			
			while node !== child {
				string += " \(node.debugDescription)"
				node = node.right
			}
		}
		
		string += ")"
		return string
	}
}
