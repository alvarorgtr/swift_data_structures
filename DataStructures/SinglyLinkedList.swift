//
//  SinglyLinkedList.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 29/6/16.
//  Copyright © 2016 DeltaApps. All rights reserved.
//

import Foundation

/**
An implementation of a linked list whose nodes only have a
pointer to the next node.
*/
public struct SinglyLinkedList<Element>: Sequence, ExpressibleByArrayLiteral {
	public typealias Iterator = AnyIterator<Element>
	fileprivate typealias Node = SinglyLinkedListNode<Element>
	
	fileprivate var head: Node?
	
	/// The number of elements currently on the list.
	public fileprivate(set) var count: Int = 0
	
	/// True if the list is empty, false otherwise.
	public var isEmpty: Bool {
		return head == nil
	}
	
	
	// MARK: Initializers
	/**
	Creates an empty singly linked list.
	*/
	public init() {
		
	}
	
	/**
	Creates a list with the elements on the provided sequence.
	
	- parameter s: the sequence the elements will be drawn from.
	
	- complexity: O(n) where n is the number of elements in the sequence.
	*/
	public init<S: Sequence>(_ s: S) where S.Iterator.Element == Element {
		var generator = s.makeIterator()
		var node: Node?
		
		if let first = generator.next() {
			head = Node(value: first, next: nil)
			node = head
			count = 1
		}
		
		while let next = generator.next() {
			node!.next = Node(value: next, next: nil)
			node = node!.next
			count += 1
		}
	}
	
	public init(arrayLiteral elements: Element...) {
		for element in elements.reversed() {
			prepend(element)
		}
	}
	
	/**
	Creates a list with the provided element repeated.
	
	- parameter count:         the number of repetitions.
	- parameter repeatedValue: the value to be repeated.
	*/
	public init(count: Int, repeatedValue: Element) {
		for _ in 0..<count {
			prepend(repeatedValue)
		}
	}
	
	
	// MARK: Accessors and mutators
	/**
	Adds an element to the head of the list.
	
	- parameter value: the element to be added.
	
	- complexity: O(1)
	*/
	public mutating func prepend(_ value: Element) {
		head = Node(value: value, next: head)
		count += 1
	}
	
	/**
	Delete the element on the head of the list.
	
	- returns: the element which was deleted.
	
	- complexity: O(1)
	*/
	public mutating func deleteFirst() -> Element {
		if let h = head {
			head = h.next
			count -= 1
			return h.value
		} else {
			fatalError("Cannot delete in an empty list")
		}
	}
	
	/**
	Obtain the first element on the list (the head).
	
	- returns: the element.
	
	- complexity: O(1)
	*/
	public func first() -> Element? {
		return head?.value
	}
	
	
	// MARK: Iteration
	public func makeIterator() -> SinglyLinkedList.Iterator {
		return AnyIterator(SinglyLinkedListGenerator<Element>(node: head))
	}
}

extension SinglyLinkedList: CustomStringConvertible {
	public var description: String {
		var desc = "["
		let generator = makeIterator()
		
		if let first = generator.next() {
			desc += String(first)
		}
		
		while let element = generator.next() {
			desc += ", " + String(element)
		}
		desc += "]"
		return desc
	}
}

public func ==<T: Equatable>(lhs: SinglyLinkedList<T>, rhs: SinglyLinkedList<T>) -> Bool {
	if lhs.count != rhs.count {
		return false
	} else {
		if lhs.count == 0 || lhs.head === rhs.head {
			return true
		} else {
			var result = true
			let leftGenerator = lhs.makeIterator()
			let rightGenerator = rhs.makeIterator()
			
			while let l = leftGenerator.next(), let r = rightGenerator.next() {
				result = result && (l == r)
			}
			
			return result
		}
	}
}

private class SinglyLinkedListNode<Element> {
	fileprivate var next: SinglyLinkedListNode<Element>?
	fileprivate var value: Element
	
	fileprivate init(value: Element, next: SinglyLinkedListNode<Element>? = nil) {
		self.value = value
		self.next = next
	}
}

private struct SinglyLinkedListGenerator<Element>: IteratorProtocol {
	fileprivate var node: SinglyLinkedListNode<Element>?
	
	fileprivate init(node: SinglyLinkedListNode<Element>?) {
		self.node = node
	}
	
	fileprivate mutating func next() -> Element? {
		let value = node?.value
		node = node?.next
		return value
	}
}
