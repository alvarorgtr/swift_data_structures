//
//  SinglyLinkedList.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 29/6/16.
//  Copyright © 2016 DeltaApps. All rights reserved.
//

import Foundation

public struct SinglyLinkedList<Element>: SequenceType, ArrayLiteralConvertible {
	public typealias Generator = SinglyLinkedListGenerator<Element>
	
	private var head: Node<Element>?
	
	public private(set) var count: Int = 0
	
	public var isEmpty: Bool {
		return head == nil
	}
	
	public init() {
		
	}
	
	public init<S: SequenceType where S.Generator.Element == Element>(_ s: S) {
		var generator = s.generate()
		var node: Node<Element>?
		
		if let first = generator.next() {
			head = Node(value: first, next: nil)
			node = head
		}
		
		while let next = generator.next() {
			node!.next = Node(value: next, next: nil)
			node = node!.next
		}
	}
	
	public init(arrayLiteral elements: Element...) {
		for element in elements.reverse() {
			pushFront(element)
		}
	}
	
	public init(count: Int, repeatedValue: Element) {
		for _ in 0..<count {
			pushFront(repeatedValue)
		}
	}
	
	
	public mutating func pushFront(value: Element) {
		head = Node(value: value, next: head)
		count += 1
	}
	
	public mutating func popFront() -> Element {
		if let h = head {
			head = h.next
			count -= 1
			return h.value
		} else {
			fatalError("Cannot pop an empty list")
		}
	}
	
	public func front() -> Element? {
		return head?.value
	}
	
	
	public func generate() -> SinglyLinkedList.Generator {
		return SinglyLinkedListGenerator<Element>(node: head)
	}
}


private class Node<Element> {
	private var next: Node<Element>?
	private var value: Element
	
	private init(value: Element, next: Node<Element>? = nil) {
		self.value = value
		self.next = next
	}
}

public struct SinglyLinkedListGenerator<Element>: GeneratorType {
		private var node: Node<Element>?
	
	private init(node: Node<Element>?) {
		self.node = node
	}
	
	public mutating func next() -> Element? {
		let value = node?.value
		node = node?.next
		return value
	}
}