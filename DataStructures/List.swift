//
//  List.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 30/6/16.
//  Copyright © 2016 DeltaApps. All rights reserved.
//

import Foundation

public struct List<Element>: Sequence, ExpressibleByArrayLiteral {
	public typealias Iterator = AnyIterator<Element>
	fileprivate typealias Node = ListNode<Element>
	
	fileprivate var head: Node?
	fileprivate var tail: Node?
	
	public fileprivate(set) var count: Int = 0
	
	public var isEmpty: Bool {
		return head == nil
	}
	
	public init() {
		
	}
	
	public init<S: Sequence>(_ s: S) where S.Iterator.Element == Element {
		for element in s {
			append(element)
		}
	}
	
	public init(arrayLiteral elements: Element...) {
		self.init(elements)
	}
	
	public init(count: Int, repeatedValue: Element) {
		for _ in 0..<count {
			prepend(repeatedValue)
		}
	}
	
	
	public mutating func prepend(_ value: Element) {
		let newHead = Node(value: value, next: head)
		if let head = head {
			head.previous = newHead
		} else {
			tail = newHead
		}
		head = newHead
		
		count += 1
	}
	
	@discardableResult public mutating func deleteFirst() -> Element {
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
			fatalError("Cannot delete in an empty list")
		}
	}
	
	public func first() -> Element? {
		return head?.value
	}
	
	
	public mutating func append(_ value: Element) {
		let newTail = Node(value: value, previous: tail)
		if let tail = tail {
			tail.next = newTail
		} else {
			head = newTail
		}
		tail = newTail
		
		count += 1
	}
	
	@discardableResult public mutating func deleteLast() -> Element {
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
			fatalError("Cannot delete in an empty list")
		}
	}
	
	public func last() -> Element? {
		return tail?.value
	}
	
	
	public func makeIterator() -> List.Iterator {
		return AnyIterator(ListIterator<Element>(node: head))
	}
	
	public func makeReverseIterator() -> List.Iterator {
		return AnyIterator(ReverseListIterator<Element>(node: tail))
	}
	
	public func reverse() -> [List.Iterator.Element] {
		let it = makeReverseIterator()
		var result = [Element]()
		
		while let element = it.next() {
			result.append(element)
		}
		
		return result
	}
}

extension List: CustomStringConvertible {
	public var description: String {
		var desc = "["
		let iterator = makeIterator()
		
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
			let leftIterator = lhs.makeIterator()
			let rightIterator = rhs.makeIterator()
			
			while let l = leftIterator.next(), let r = rightIterator.next() {
				result = result && (l == r)
			}
			
			return result
		}
	}
}

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

private struct ListIterator<Element>: IteratorProtocol {
	fileprivate var node: ListNode<Element>?
	
	fileprivate init(node: ListNode<Element>?) {
		self.node = node
	}
	
	fileprivate mutating func next() -> Element? {
		let value = node?.value
		node = node?.next
		return value
	}
}

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
}
