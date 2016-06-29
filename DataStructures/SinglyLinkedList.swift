//
//  SinglyLinkedList.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 29/6/16.
//  Copyright © 2016 DeltaApps. All rights reserved.
//

import Foundation

public struct SinglyLinkedList<T>: SequenceType {
	public typealias Generator = SinglyLinkedListGenerator<T>
	
	private var head: Node<T>?
	
	public private(set) var count: Int = 0
	
	public var isEmpty: Bool {
		return head == nil
	}
	
	public init() {
		
	}
	
	public mutating func pushFront(value: T) {
		head = Node(value: value, next: head)
		count += 1
	}
	
	public mutating func popFront() -> T {
		if let h = head {
			head = h.next
			count -= 1
			return h.value
		} else {
			fatalError("Cannot pop an empty list")
		}
	}
	
	public func front() -> T? {
		return head?.value
	}
	
	public func generate() -> SinglyLinkedList.Generator {
		return SinglyLinkedListGenerator<T>(node: head)
	}
}

private class Node<T> {
	private var next: Node<T>?
	private var value: T
	
	private init(value: T, next: Node<T>? = nil) {
		self.value = value
		self.next = next
	}
}

public struct SinglyLinkedListGenerator<T>: GeneratorType {
	public typealias Element = T
	
	private var node: Node<T>?
	
	private init(node: Node<T>?) {
		self.node = node
	}
	
	public mutating func next() -> SinglyLinkedListGenerator.Element? {
		let value = node?.value
		node = node?.next
		return value
	}
}