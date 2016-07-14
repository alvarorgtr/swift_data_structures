//
//  List.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 30/6/16.
//  Copyright © 2016 DeltaApps. All rights reserved.
//

import Foundation

public struct List<Element>: SequenceType, ArrayLiteralConvertible {
	public typealias Generator = AnyGenerator<Element>
	private typealias Node = ListNode<Element>
	
	private var head: Node?
	private var tail: Node?
	
	public private(set) var count: Int = 0
	
	public var isEmpty: Bool {
		return head == nil
	}
	
	public init() {
		
	}
	
	public init<S: SequenceType where S.Generator.Element == Element>(_ s: S) {
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
	
	
	public mutating func prepend(value: Element) {
		let newHead = Node(value: value, next: head)
		if let head = head {
			head.previous = newHead
		} else {
			tail = newHead
		}
		head = newHead
		
		count += 1
	}
	
	public mutating func deleteFirst() -> Element {
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
	
	
	public mutating func append(value: Element) {
		let newTail = Node(value: value, previous: tail)
		if let tail = tail {
			tail.next = newTail
		} else {
			head = newTail
		}
		tail = newTail
		
		count += 1
	}
	
	public mutating func deleteLast() -> Element {
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
	
	
	public func generate() -> List.Generator {
		return AnyGenerator(ListGenerator<Element>(node: head))
	}
	
	public func generateReverse() -> List.Generator {
		return AnyGenerator(ReverseListGenerator<Element>(node: tail))
	}
	
	public func reverse() -> [List.Generator.Element] {
		let gen = generateReverse()
		var result = [Element]()
		
		while let element = gen.next() {
			result.append(element)
		}
		
		return result
	}
}

extension List: CustomStringConvertible {
	public var description: String {
		var desc = "["
		let generator = generate()
		
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

public func ==<T: Equatable>(lhs: List<T>, rhs: List<T>) -> Bool {
	if lhs.count != rhs.count {
		return false
	} else {
		if lhs.count == 0 || lhs.head === rhs.head {
			return true
		} else {
			var result = true
			let leftGenerator = lhs.generate()
			let rightGenerator = rhs.generate()
			
			while let l = leftGenerator.next(), r = rightGenerator.next() {
				result = result && (l == r)
			}
			
			return result
		}
	}
}

private class ListNode<Element> {
	private var next: ListNode<Element>?
	private weak var previous: ListNode<Element>?
	private var value: Element
	
	private init(value: Element, previous: ListNode<Element>? = nil, next: ListNode<Element>? = nil) {
		self.value = value
		self.next = next
		self.previous = previous
	}
}

private struct ListGenerator<Element>: GeneratorType {
	private var node: ListNode<Element>?
	
	private init(node: ListNode<Element>?) {
		self.node = node
	}
	
	private mutating func next() -> Element? {
		let value = node?.value
		node = node?.next
		return value
	}
}

private struct ReverseListGenerator<Element>: GeneratorType {
	private var node: ListNode<Element>?
	
	private init(node: ListNode<Element>?) {
		self.node = node
	}
	
	private mutating func next() -> Element? {
		let value = node?.value
		node = node?.previous
		return value
	}
}