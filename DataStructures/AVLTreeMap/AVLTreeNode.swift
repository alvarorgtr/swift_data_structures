import Foundation 

internal final class AVLTreeNode<Key: Comparable, Value> {
	typealias Node = AVLTreeNode<Key, Value>

	var leftChild: Node? {
		didSet {
			if let node = leftChild {
				node.parent = self
			}
		}
	}
	var rightChild: Node? {
		didSet {
			if let node = rightChild {
				node.parent = self
			}
		}
	}
	private(set) internal weak var parent: Node?

	var key: Key
	var value: Value

	var keyValue: (Key, Value) {
		return (key, value)
	}

	private(set) internal var height: Int = 0

	var next: Node? {
		get {
			var newNode: Node?

			if let right = rightChild {
				newNode = right.minimum
			} else {
				var child = self

				while let parent = child.parent {
					if parent.isLeftChild(child) {
						newNode = parent
						break
					}

					child = parent
				}
			}

			return newNode
		}
	}

	var previous: Node? {
		get {
			var newNode: Node?

			if let left = leftChild {
				newNode = left.maximum
			} else {
				var child = self

				while let parent = child.parent {
					if parent.isRightChild(child) {
						newNode = parent
						break
					}

					child = parent
				}
			}

			return newNode
		}
	}

	/// - complexity: O(log n)
	internal var depth: Int {
		if let parent = parent {
			return parent.depth + 1
		} else {
			return 0
		}
	}

	internal init(key: Key, value: Value) {
		self.key = key
		self.value = value
	}

	internal init(_ keyValue: (Key, Value)) {
		self.key = keyValue.0
		self.value = keyValue.1
	}

	internal func isLeftChild(_ node: Node) -> Bool {
		return leftChild === node
	}

	internal func isRightChild(_ node: Node) -> Bool {
		return rightChild === node
	}

	internal func updateHeight() {
		height = max(leftChild?.height ?? -1, rightChild?.height ?? -1) + 1
	}

	internal func removeChild(node: Node) {
		updateChild(node: node, withNode: nil)
	}

	internal func updateChild(node: Node, withNode newNode: Node?) {
		if isRightChild(node) {
			rightChild = newNode
		} else if isLeftChild(node) {
			leftChild = newNode
		}
	}

	internal var minimum: Node {
		get {
			if let left = leftChild {
				return left.minimum
			} else {
				return self
			}
		}
	}

	internal var maximum: Node {
		get {
			if let right = rightChild {
				return right.maximum
			} else {
				return self
			}
		}
	}
}

extension AVLTreeNode: CustomStringConvertible {
	public var description: String {
		get {
			let leftString = leftChild?.description ?? "nil"
			let rightString = rightChild?.description ?? "nil"

			return "AVLTreeNode<key: \(key), value: \(value), leftChild: \(leftString), rightChild: \(rightString)>"
		}
	}
}