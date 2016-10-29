//
//  ListIndex.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 29/10/16.
//  Copyright © 2016 DeltaApps. All rights reserved.
//

import Foundation

public class ListIndex<Element>: Comparable {
	internal var node: ListNode<Element>?
	
	internal init(node: ListNode<Element>?) {
		self.node = node
	}
	
	public func successor() -> ListIndex<Element> {
		return ListIndex<Element>(node: node?.next)
	}
	
	public func predecessor() -> ListIndex<Element> {
		return ListIndex<Element>(node: node?.previous)
	}
}

public func ==<T>(lhs: ListIndex<T>, rhs: ListIndex<T>) -> Bool {
	return lhs.node === rhs.node
}

public func <<T>(lhs: ListIndex<T>, rhs: ListIndex<T>) -> Bool {
	if lhs.node === rhs.node {
		return false
	}
	
	if lhs.node == nil {
		return false
	}
	
	if rhs.node == nil {
		return true
	}
	
	var result = false
	var next = lhs.successor()
	
	while next.node != nil && !result {
		if next.node === rhs.node {
			result = true
		}
		
		next = next.successor()
	}
	
	return result
}
