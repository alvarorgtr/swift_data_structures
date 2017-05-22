//
//  FibonacciHeap.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 28/4/17.
//  Copyright © 2017 DeltaApps. All rights reserved.
//

import Foundation

final public class FibonacciHeap<Element: Hashable, Priority> {
	fileprivate typealias Node = FibonacciNode<Element, Priority>
	
	let less: (Priority, Priority) -> Bool
	public fileprivate(set) var count: Int = 0
	
	public var isEmpty: Bool {
		return count == 0
	}
	
	fileprivate var min: Node?
	fileprivate var handler: [Element: Node] = [:]
	
	
	/// Initializes the heap providing a comparator.
	///
	/// - Parameter comparator: a closure which returns true if the first element is smaller than the second element (for a minimum heap), and false otherwise.
	/// - Complexity: O(1)
	public required init(comparator: @escaping (Priority, Priority) -> Bool) {
		self.less = comparator
	}
	
	
	public func contains(_ element: Element) -> Bool {
		return handler[element] != nil
	}
	
	public func priority(of element: Element) -> Priority? {
		return handler[element]?.priority
	}
	
	
	/// Inserts an element into the heap.
	///
	/// - Parameter element: the element to be inserted.
	/// - Complexity: O(1)
	public func insert(_ element: Element, with priority: Priority) {
		let node = Node(key: element, priority: priority)
		handler[element] = node
		self.insert(node: node)
	}
	
	private func insert(node: Node) {
		if let min = min {
			add(node, after: min)
			
			if less(node.priority, min.priority) {
				self.min = node
			}
		} else {
			min = node
		}
		
		count += 1
	}
	
	
	/// Returns the smallest element in the heap (with the given order).
	public var minimum: Element? {
		return min?.key
	}
	
	/// Returns the priority of the smallest element in the heap.
	public var minimumPriority: Priority? {
		return min?.priority
	}
	
	
	/// Performs the union of self with another heap.
	///
	/// - Precondition: The two priority queues must share the ordering function.
	/// - Warning: Both heaps (self and the argument) will now be empty.
	///
	/// - Parameter heap2: the second heap.
	/// - Returns: the result of the union.
	public func union(_ heap2: FibonacciHeap<Element, Priority>) -> FibonacciHeap<Element, Priority> {
		let heap = FibonacciHeap<Element, Priority>(comparator: less)

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
		
		add(from: min2, to: min2.left, after: min1)
		
		if less(min2.priority, min1.priority) {
			heap.min = min2
		}
		
		heap.handler = self.handler
		for (key, value) in heap2.handler {
			heap.handler[key] = value
		}
		self.handler = [:]
		heap2.handler = [:]
		
		return heap
	}
	
	/// Extracts and returns the minimum of the heap.
	///
	/// - Returns: The minimum
	@discardableResult
	public func extractMinimum() -> Element? {
		return extractMinimumAndPriority()?.0
	}
	
	/// Extracts and returns the minimum of the heap.
	///
	/// - Returns: A tuple formed by the minimum and the priority.
	@discardableResult
	public func extractMinimumAndPriority() -> (Element, Priority)? {
		if let min = min {
			// Add every child to root list
			if let child = min.child {
				add(from: child, to: child.left, after: min)
				
				var node: Node = min
				while node != child.right {
					node = node.right
					node.parent = nil
				}
			}
			
			// Remove min
			min.left.right = min.right
			min.right.left = min.left
			
			if min == min.right {
				self.min = nil
			} else {
				self.min = min.right
				consolidate()
			}
			
			handler[min.key] = nil
			count -= 1
			return (min.key, min.priority)
		}
		
		return nil
	}
	
	private func consolidate() {
		var a = Array<Node?>()
		let root: Node = min!.right
		
		var queue: Queue<Node> = [root]
		var node = root.right!
		while node != root {
			queue.push(node)
			node = node.right
		}

		while let node = queue.pop() {
			var x = node
			var d = node.degree
			
			// We fill the array to make sure we have enough place to fit all
			while a.count <= d {
				a.append(nil)
			}
			
			while a[d] != nil {
				var y = a[d]!
				if less(y.priority, x.priority) {
					let aux = x
					x = y
					y = aux
				}
				
				link(node: y, to: x)
				a[d] = nil
				d += 1
				
				// We fill the array to make sure we have enough place to fit all
				if d >= a.count {
					a.append(nil)
				}
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
					add(elem, after: head!)
				}
				
				if min == nil || less(elem.priority, min!.priority) {
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
		
		y.marked = false
	}
	
	
	/// Decreases the priority of the given element.
	///
	/// - Parameters:
	///   - element: The element whose priority is to be decreased.
	///   - priority: The new priority. Must be smaller than the previous one.
	public func decreasePriority(of element: Element, to priority: Priority) {
		if let node = handler[element] {
			decreasePriority(of: node, to: priority)
		} else {
			fatalError("No such node")
		}
	}
	
	private func decreasePriority(of x: Node, to priority: Priority) {
		precondition(less(priority, x.priority), "The new priority must be smaller than the previous one")
		
		x.priority = priority
		
		if let y = x.parent, less(x.priority, y.priority) {
			cut(x, y)
			cascadingCut(y)
		}
		
		if less(x.priority, min!.priority) {
			min = x
		}
	}
	
	private func cut(_ x: Node, _ y: Node) {
		if x.left != x {
			x.left.right = x.right
			x.right.left = x.left
			y.child = x.left
		} else {
			y.child = nil
		}
		
		y.degree -= 1
		
		x.left = min!
		x.right = min!.right
		min!.right.left = x
		min!.right = x
		
		x.parent = nil
		
		x.marked = false
	}
	
	private func cascadingCut(_ y: Node) {
		if let z = y.parent {
			if !y.marked {
				y.marked = true
			} else {
				cut(y, z)
				cascadingCut(z)
			}
		}
	}
	
	
	/// Deletes the given element.
	///
	/// - Parameter element: The element to delete.
	public func delete(_ element: Element) {
		if let node = handler[element] {
			delete(node: node)
		}
	}
	
	private func delete(node x: Node) {
		// Make the node the smallest
		// This code mimics the behaviour of decreasePriority but assumes x < y is true for any y
		if let y = x.parent {
			cut(x, y)
			cascadingCut(y)
		}
		
		min = x
		
		// Now that it's the smallest we can safely delete it.
		extractMinimum()
	}
}


// Private node manipulation methods
extension FibonacciHeap {
	fileprivate func add(_ node: Node, after left: Node) {
		add(from: node, to: node, after: left)
	}
	
	fileprivate func add(from: Node, to: Node, after left: Node) {
		let right: Node = left.right
		from.left = left
		to.right = right
		left.right = from
		right.left = to
	}
	
	fileprivate func remove(_ node: Node) {
		let left: Node = node.left
		let right: Node = node.right
		
		if let parent = node.parent {
			parent.child = (node != left) ? left : nil
		}
		
		left.right = right
		right.left = left
	}
}


// Use the default operator < when the priority is comparable
public extension FibonacciHeap where Priority: Comparable {
	/// Initializes the heap with the standard order if the Priority is Comparable.
	///
	/// - Parameter minimum: true if it's a minimum heap, false otherwise.
	public convenience init(minimum: Bool = true) {
		let comparator: (Priority, Priority) -> Bool = minimum ? { return $0 < $1 } : { return $0 > $1 }
		self.init(comparator: comparator)
	}
}


// Use the default priority when inserting if the element is priorizable
public extension FibonacciHeap where Element: Priorizable, Element.Priority == Priority {
	public func insert(_ element: Element) {
		insert(element, with: element.priority)
	}
}


// Debug string description
extension FibonacciHeap: CustomDebugStringConvertible {
	public var debugDescription: String {
		var string = "FibonacciHeap<count: \(count), contents:"
		if let min = min {
			var node = min
			string += " \(node.debugDescription)"
			node = node.right
			
			while node != min {
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
