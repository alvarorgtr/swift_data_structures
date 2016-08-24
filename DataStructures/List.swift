//
//  List.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 30/6/16.
//  Copyright © 2016 DeltaApps. All rights reserved.
//

import Foundation

public struct List<Element>: RandomAccessCollection, ExpressibleByArrayLiteral {
	public typealias Iterator = ListIterator<Element>
	public typealias Index = ListIndex<Element>
	fileprivate typealias Node = ListNode<Element>
	
	fileprivate var head: Node?
	fileprivate var tail: Node?
	
	public fileprivate(set) var count: Int = 0
	
	public var isEmpty: Bool {
		return head == nil
	}
	
	// MARK: Index requirements
	public var startIndex: Index {
		return Index(node: head)
	}
	
	public var endIndex: Index {
		return Index(node: nil)
	}
	
	public func index(after i: Index) -> Index {
		return i.successor()
	}
	
	public func index(before i: Index) -> Index {
		if i.node == nil {
			return Index(node: tail)
		} else {
			return i.predecessor()
		}
	}
	
	// MARK: Initializers
	public init() {
		
	}
	
	public init<S: Sequence>(_ s: S) where S.Iterator.Element == Element {
		for element in s {
			appendLast(element)
		}
	}
	
	public init(arrayLiteral elements: Element...) {
		self.init(elements)
	}
	
	public init(count: Int, repeatedValue: Element) {
		for _ in 0..<count {
			appendLast(repeatedValue)
		}
	}
	
	// MARK: Subscripting	
	public subscript(position: Index) -> Element {
		set {
			changeNode(newValue: newValue, position: position)
		}
		
		get {
			guard let node = position.node else {
				fatalError("List index out of bounds")
			}
			
			return node.value
		}
	}
	
	private func changeNode(newValue: Element, position: Index) {
		if position.node != nil {
			position.node!.value = newValue
		} else {
			fatalError("List index out of bounds")
		}
	}
	
	// MARK: Mutators & accessors
	public mutating func appendFirst(_ value: Element) {
		let newHead = Node(value: value, next: head)
		if let head = head {
			head.previous = newHead
		} else {
			tail = newHead
		}
		head = newHead
		
		count += 1
	}

	public mutating func appendLast(_ value: Element) {
		let newTail = Node(value: value, previous: tail)
		if let tail = tail {
			tail.next = newTail
		} else {
			head = newTail
		}
		tail = newTail
		
		count += 1
	}
	
	@discardableResult public mutating func removeFirst() -> Element {
		if let oldHead = head {
			if let next = oldHead.next {
				next.previous = nil
			} else {
				tail = nil
			}
			
			head = oldHead.next
			count -= 1
			
			return oldHead.value
		} else {
			fatalError("Cannot remove elements from an empty list")
		}
	}
	
	@discardableResult public mutating func removeLast() -> Element {
		if let oldTail = tail {
			if let previous = oldTail.previous {
				previous.next = nil
			} else {
				head = nil
			}
			
			tail = oldTail.previous
			count -= 1
			
			return oldTail.value
		} else {
			fatalError("Cannot remove elements from an empty list")
		}
	}
	
	// MARK: Iteration
	public func makeIterator() -> List.Iterator {
		return ListIterator<Element>(node: head)
	}
}

// MARK: - List extensions
extension List: CustomStringConvertible {
	public var description: String {
		var desc = "["
		var iterator = makeIterator()
		
		if let first = iterator.next() {
			desc += String(describing: first)
		}
		
		while let element = iterator.next() {
			desc += ", " + String(describing: element)
		}
		desc += "]"
		return desc
	}
}

public func ==<T: Equatable>(lhs: List<T>, rhs: List<T>) -> Bool {
	if lhs.count != rhs.count {
		return false
	} else {
		if lhs.count == 0 || lhs.head === rhs.head {
			return true
		} else {
			var result = true
			var leftIterator = lhs.makeIterator()
			var rightIterator = rhs.makeIterator()
			
			while let l = leftIterator.next(), let r = rightIterator.next() {
				result = result && (l == r)
			}
			
			return result
		}
	}
}

// MARK: - Node
private class ListNode<Element> {
	fileprivate var next: ListNode<Element>?
	fileprivate weak var previous: ListNode<Element>?
	fileprivate var value: Element
	
	fileprivate init(value: Element, previous: ListNode<Element>? = nil, next: ListNode<Element>? = nil) {
		self.value = value
		self.next = next
		self.previous = previous
	}
}

// MARK: - Index
public class ListIndex<Element>: Comparable {
	fileprivate var node: ListNode<Element>?
	
	fileprivate init(node: ListNode<Element>?) {
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

// MARK: - Iterators
public struct ListIterator<T>: IteratorProtocol {
	public typealias Element = T

	fileprivate var node: ListNode<T>?
	
	fileprivate init(node: ListNode<T>?) {
		self.node = node
	}
	
	public mutating func next() -> T? {
		let value = node?.value
		node = node?.next
		return value
	}
}

/*
private struct ReverseListIterator<Element>: IteratorProtocol {
	fileprivate var node: ListNode<Element>?
	
	fileprivate init(node: ListNode<Element>?) {
		self.node = node
	}
	
	fileprivate mutating func next() -> Element? {
		let value = node?.value
		node = node?.previous
		return value
	}
}*/
