//
//  FibonacciHeap.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 28/4/17.
//  Copyright © 2017 DeltaApps. All rights reserved.
//

// TODO: Repeating elements?

import Foundation

public class FibonacciHeap<Element: Hashable> {
	fileprivate typealias Node = FibonacciNode<Element>
	
	let less: (Element, Element) -> Bool
	public fileprivate(set) var count: Int = 0
	
	fileprivate var min: Node?
	fileprivate var handler: [Element: Node] = [:]
	
	
	/// Initializes the heap providing a comparator.
	///
	/// - Parameter comparator: a closure which returns true if the first element is smaller than the second element (for a minimum heap), and false otherwise.
	/// - Complexity: O(1)
	public required init(comparator: @escaping (Element, Element) -> Bool) {
		self.less = comparator
	}
	
	
	/// Inserts an element into the heap.
	///
	/// - Parameter element: the element to be inserted.
	/// - Complexity: O(1)
	public func insert(_ element: Element) {
		let node = Node(key: element)
		handler[element] = node
		self.insert(node: node)
	}
	
	private func insert(node: Node) {
		if let min = min {
			node.left = min.left
			node.right = min
			node.left.right = node
			min.left = node
			
			if less(node.key, min.key) {
				self.min = node
			}
		} else {
			min = node
		}
		
		count += 1
	}
	
	
	/// Returns the smallest element in the queue (with the given order)
	public var minimum: Element? {
		return min?.key
	}
	
	
	/// Performs the union of self with another heap.
	///
	/// - Precondition: The two priority queues must share the ordering function.
	/// - Warning: Both heaps (self and the argument) will now be empty.
	///
	/// - Parameter heap2: the second heap.
	/// - Returns: the result of the union.
	public func union(_ heap2: FibonacciHeap<Element>) -> FibonacciHeap<Element> {
		let heap = FibonacciHeap<Element>(comparator: less)

		guard let min1 = self.min else {
			heap.min = heap2.min
			heap.count = heap2.count
			heap2.min = nil
			heap2.count = 0
			return heap
		}
		
		guard let min2 = heap2.min else {
			heap.min = self.min
			heap.count = self.count
			self.min = nil
			self.count = 0
			return heap
		}
		
		heap.min = min1
		self.min = nil
		heap2.min = nil
		heap.count = self.count + heap2.count
		self.count = 0
		heap2.count = 0
		
		min1.right.left = min2.left
		min2.left.right = min1.right
		min1.right = min2
		min2.left = min1
		
		if less(min2.key, min1.key) {
			heap.min = min2
		}
		
		return heap
	}
	
	
	/// Extracts and returns the minimum of the heap.
	///
	/// - Returns: The minimum
	@discardableResult
	public func extractMinimum() -> Element? {
		if let min = min {
			/* if let child = min.child {
				child.left.right = min.right
				min.right.left = child.left
				child.left = min.left
				min.left.right = child
			} else {
				min.left.right = min.right
				min.right.left = min.left
			}
			
			var child: Node = min.left.right
			while child !== min.right {
				child.parent = nil
				child = child.right
			} */
			
			// Add every child to root list
			if let child = min.child {
				var node = child.right!
				var next: Node?
				addToRootList(child)
				child.parent = nil
			
				while node !== child {
					next = node.right
					addToRootList(node)
					node.parent = nil
					node = next!
				}
			}
			
			// Remove min
			min.left.right = min.right
			min.right.left = min.left
			
			if min === min.right {
				self.min = nil
			} else {
				self.min = min.right
				consolidate()
			}
			
			handler[min.key] = nil
			count -= 1
			return min.key
		}
		
		return nil
	}
	
	private func addToRootList(_ node: Node) {
		precondition(min != nil)
		node.right = min!.right
		min!.right.left = node
		min!.right = node
		node.left = min!
	}
	
	private func consolidate() {
		var a = Array<Node?>(repeating: nil, count: count)
		let root: Node = min!.right
		
		var queue: Queue<Node> = [root]
		var node = root.right!
		while node !== root {
			queue.push(node)
			node = node.right
		}
		
		// TODO: como haya que consolidar root el bucle se pasa de frenada
		while let node = queue.pop() {
			if node.parent != nil {		// We don't consider the nodes which have already been consolidated
				continue
			}
			
			var x = node
			var d = node.degree
			
			while a[d] != nil {
				var y = a[d]!
				if less(y.key, x.key) {
					let aux = x
					x = y
					y = aux
				}
				
				link(node: y, to: x)
				a[d] = nil
				d += 1
			}
			
			a[d] = x
		}
		
		min = nil
		var head: Node?
		
		for elem in a {
			if let elem = elem {
				if head == nil {
					head = elem
					elem.left = elem
					elem.right = elem
				} else {
					elem.left = head!.left
					elem.right = head
					head!.left.right = elem
					head!.left = elem
				}
				
				if min == nil || less(elem.key, min!.key) {
					min = elem
				}
			}
		}
	}
	
	private func link(node y: Node, to x: Node) {
		y.left.right = y.right
		y.right.left = y.left
		
		if let child = x.child {
			x.child = y
			y.parent = x
			y.left = child
			y.right = child.right
			y.left.right = y
			y.right.left = y
		} else {
			x.child = y
			y.parent = x
			y.left = y
			y.right = y
		}
		
		x.degree += 1
	}
}

extension FibonacciHeap: CustomDebugStringConvertible {
	public var debugDescription: String {
		var string = "FibonacciHeap<count: \(count), contents:"
		if let min = min {
			var node = min
			string += " \(node.debugDescription)"
			node = node.right
			
			while node !== min {
				string += " \(node.debugDescription)"
				node = node.right
			}
		} else {
			string += "nil"
		}
		string += ">"
		return string
	}
}

public extension FibonacciHeap where Element: Comparable {
	public convenience init() {
		self.init(comparator: { return $0 < $1 })
	}
}
