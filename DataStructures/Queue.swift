//
//  Stack.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 24/8/16.
//  Copyright © 2017 DeltaApps. All rights reserved.
//

import Foundation

public struct Queue<Element>: ExpressibleByArrayLiteral {	
	private var storage: List<Element>
	
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
		storage = List<Element>(s)
	}
	
	public init(arrayLiteral elements: Element...) {
		storage = List<Element>(elements)
	}
	
	public init(count: Int, repeatedValue: Element) {
		storage = List<Element>(count: count, repeatedValue: repeatedValue)
	}
	
	// MARK: Accessors
	
	public mutating func push(_ element: Element) {
		storage.appendFirst(element)
	}
	
	@discardableResult
	public mutating func pop() -> Element? {
		if !storage.isEmpty {
			return storage.removeLast()
		}
		
		return nil
	}
	
	public var top: Element? {
		return storage.last
	}
}
