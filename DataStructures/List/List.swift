//
//  List.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 30/6/16.
//  Copyright © 2016 DeltaApps. All rights reserved.
//

import Foundation

public struct List<Element> {
	fileprivate typealias Node = ListNode<Element>
	
	fileprivate var head: Node?
	fileprivate var tail: Node?
	
	public fileprivate(set) var count: Int = 0
	
	public var isEmpty: Bool {
		return head == nil
	}
	
	// MARK: Initializers
	public init() {
		
	}
	
	public init<S: Sequence>(_ s: S) where S.Iterator.Element == Element {
		for element in s {
			appendLast(element)
		}
	}
	
	public init(count: Int, repeatedValue: Element) {
		for _ in 0..<count {
			appendLast(repeatedValue)
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
}

extension List: Sequence {
	public typealias Iterator = ListIterator<Element>
	public typealias Index = ListIndex<Element>
	
	public func makeIterator() -> List.Iterator {
		return ListIterator<Element>(node: head)
	}
}

extension List: BidirectionalCollection {
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
}

extension List: ExpressibleByArrayLiteral {
	public init(arrayLiteral elements: Element...) {
		self.init(elements)
	}
}

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
