import Foundation 

public final class AVLTreeIndex<Key: Comparable, Value> {
	internal typealias Node = AVLTreeNode<Key, Value>
	internal typealias Index = AVLTreeIndex<Key, Value>

	internal var node: Node?
	internal var previousNode: Node?

	/// - complexity: log(tree.count)
	public required init(tree: AVLTreeMap<Key, Value>) {
		if let root = tree.root {
			node = root.minimum
			previousNode = nil
		}
	}

	internal init(_ node: Node?, previous: Node?) {
		// The precondition only holds if the tree is not empty
		// precondition(node != nil || previous != nil, "A index must have at least a node, either current or previous")
		self.node = node
		self.previousNode = previous
	}

	/// - complexity: Amortized O(1)
	internal func next() -> Index {
		precondition(node != nil)
		return Index(node?.next, previous: node)
	}

	/// - complexity: Amortized O(1)
	internal func previous() -> Index {
		precondition(previousNode != nil)
		return Index(node?.previous, previous: node)
	}
}

extension AVLTreeIndex: Strideable {
	public typealias Stride = Int

	public static func ==<Key: Comparable, Value>(lhs: AVLTreeIndex<Key, Value>, rhs: AVLTreeIndex<Key, Value>) -> Bool {
		return lhs.node === rhs.node
	}

	public static func <<Key: Comparable, Value>(lhs: AVLTreeIndex<Key, Value>, rhs: AVLTreeIndex<Key, Value>) -> Bool {
		if let lkey = lhs.node?.key, let rkey = rhs.node?.key {
			return lkey < rkey
		} else {
			return lhs.node != nil
		}
	}

	public func advanced(by n: Stride) -> Self {
		var index: AVLTreeIndex<Key, Value> = self
		for _ in 0..<n {
			index = index.next()
		}
		return self
	}

	public func distance(to other: AVLTreeIndex<Key, Value>) -> Stride {
		var count = 0;
		var startIndex: Index
		var endIndex: Index

		if let selfKey = node?.key, let otherKey = other.node?.key {
			if selfKey > otherKey {
				startIndex = other
				endIndex = self
			} else {
				startIndex = self
				endIndex = other
			}
		} else if node == nil {
			// This is the last one
			startIndex = other
			endIndex = self
		} else {	// Other is nil
			startIndex = self
			endIndex = other
		}

		while startIndex != endIndex {
			// If startIndex.node == nil => endIndex is too
			count += 1
			startIndex = startIndex.next()
		}

		return count
	}
}
