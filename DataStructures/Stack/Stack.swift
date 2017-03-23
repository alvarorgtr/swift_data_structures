//
//  Stack.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 24/8/16.
//  Copyright © 2016 DeltaApps. All rights reserved.
//

import Foundation

public struct Stack<Element>: ExpressibleByArrayLiteral {	
	private var storage: SinglyLinkedList<Element>
	
	public var count: Int {
		return storage.count
	}
	
	public var isEmpty: Bool {
		return storage.isEmpty
	}
	
	// MARK: Initializers
	
	public init() {
		storage = []
	}
	
	public init<S: Sequence>(_ s: S) where S.Iterator.Element == Element {
		storage = SinglyLinkedList<Element>(s)
	}
	
	public init(arrayLiteral elements: Element...) {
		storage = SinglyLinkedList<Element>(elements)
	}
	
	public init(count: Int, repeatedValue: Element) {
		storage = SinglyLinkedList<Element>(count: count, repeatedValue: repeatedValue)
	}
	
	// MARK: Accessors
	
	public mutating func push(_ element: Element) {
		storage.prepend(element)
	}
	
	@discardableResult
	public mutating func pop() -> Element? {
		if !storage.isEmpty {
			return storage.deleteFirst()
		}
		
		return nil
	}
	
	public var top: Element? {
		return storage.first
	}
}
