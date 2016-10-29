//
//  ListIterator.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 29/10/16.
//  Copyright © 2016 DeltaApps. All rights reserved.
//

import Foundation

public struct ListIterator<T>: IteratorProtocol {
	public typealias Element = T
	
	internal var node: ListNode<T>?
	
	internal init(node: ListNode<T>?) {
		self.node = node
	}
	
	public mutating func next() -> T? {
		let value = node?.value
		node = node?.next
		return value
	}
}
