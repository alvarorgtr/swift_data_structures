//
//  FibonacciNode.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 28/4/17.
//  Copyright © 2017 DeltaApps. All rights reserved.
//

import Foundation

internal class FibonacciNode<Element: Equatable> {
	typealias Node = FibonacciNode<Element>
	
	var key: Element
	var parent: Node?
	var child: Node?
	var left: Node!
	var right: Node!
	var degree: Int
	var marked: Bool
	
	required init(key: Element, parent: Node? = nil, child: Node? = nil, left: Node? = nil, right: Node? = nil, degree: Int = 0) {
		self.key = key
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
		var string = "(\(key)"
		
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
