import Foundation

public struct AVLTreeMap<Key: Comparable, Value>: ExpressibleByDictionaryLiteral {
	internal typealias Node = AVLTreeNode<Key, Value>

	internal var root: Node? {
		didSet {
			root?.parent = nil
		}
	}

	// We save references for nodes for startIndex & endIndex
	internal var startNode: Node?
	internal var endNode: Node?

	fileprivate(set) public var count = 0

	/// The total height of the tree. -1 if empty.
	/// - complexity: O(log n) where n is the tree count.
	public var height: Int {
		return root?.height ?? -1
	}

	internal init(_ root: Node?, startNode: Node?, endNode: Node?, count: Int) {
		self.root = root
		self.startNode = startNode
		self.endNode = endNode
		self.count = count
	}

	/**
	Creates an empty tree
	**/
	public init() {
		// Does nothing
	}

	public init(dictionaryLiteral elements: (Key, Value)...) {
		let sorted = elements.sorted() { $0.0 < $1.0 }
		self.root = subTreeRoot(bounds: 0..<sorted.count, fromCollection: sorted)
		self.count = elements.count
		if elements.count != 0 {
			self.startNode = findNode(forKey: sorted.first!.0, fromNode: root)
			self.endNode = findNode(forKey: sorted.last!.0, fromNode: root)
		}
	}

	fileprivate func subTreeRoot(bounds: CountableRange<Int>, fromCollection collection: [(Key, Value)]) -> Node? {
		if bounds.count == 0 {
			return nil
		} else if bounds.count == 1 {
			return Node(collection[bounds.first!])
		} else {
			let middle: Int = Int(floor(Double(bounds.count - 1) / 2.0)) + bounds.first!

			let node = Node(collection[middle])
			node.leftChild = subTreeRoot(bounds: bounds.first!..<middle, fromCollection: collection)
			node.rightChild = subTreeRoot(bounds: (middle + 1)..<(bounds.last! + 1), fromCollection: collection)
			node.updateHeight()
			return node
		}
	}
}

extension AVLTreeMap where Key: Hashable {
	/**
	Orders the keys of the dictionary and creates a tree with them.
	
	- parameter dictionary: the source dictionary.
	
	- complexity: O(n log n), where n is the number of elements in the dictionary.
	*/
	public init(dictionary: [Key: Value]) {
		self.init()
		let keysAndValues: [(Key, Value)] = dictionary.keys.map { (key) -> (Key, Value) in (key, dictionary[key]!) }
		let sorted = keysAndValues.sorted() { $0.0 < $1.0 }
		self.root = subTreeRoot(bounds: 0..<sorted.count, fromCollection: sorted)
		self.count = dictionary.count
		if sorted.count != 0 {
			self.startNode = findNode(forKey: sorted.first!.0, fromNode: root)
			self.endNode = findNode(forKey: sorted.last!.0, fromNode: root)
		}

	}
}

extension AVLTreeMap {
	/// Enables subscript access to the value associated with a key.
	///
	/// - parameter key: the key the value is associated to.
	///
	/// - returns: the associated value.
	public subscript(key: Key) -> Value? {
		get {
			return findNode(forKey: key, fromNode: root)?.value
		}

		set (newValue) {
			if let value = newValue {
				update(value: value, forKey: key)
			} else {
				removeValue(forKey: key)
			}
		}
	}

	/**
	Updates the value associated with the key.
	- returns: the old associated value
	*/
	@discardableResult public mutating func update(value: Value, forKey key: Key) -> Value? {
		if root != nil {
			if let oldValue = update(value: value, forKey: key, fromNode: &root) {
				return oldValue
			} else {
				count += 1
			}
		} else {
			root = Node(key: key, value: value)
			startNode = root
			endNode = root
			count = 1
		}
		return nil
	}

	@discardableResult private mutating func update(value: Value, forKey key: Key, fromNode currNode: inout Node?) -> Value? {
		precondition(root != nil)

		guard let node = currNode else {
			return nil
		}

		if key == node.key {
			let oldValue = node.value
			node.value = value
			return oldValue
		} else if key < node.key {
			if node.leftChild != nil {
				let oldValue = update(value: value, forKey: key, fromNode: &node.leftChild)
				balanceRight(&currNode)
				return oldValue
			} else {
				let newNode = Node(key: key, value: value)
				node.leftChild = newNode
				balanceRight(&currNode)

				if key < startNode!.key {
					startNode = newNode
				}
			}
		} else {
			if node.rightChild != nil {
				let oldValue = update(value: value, forKey: key, fromNode: &node.rightChild)
				balanceLeft(&currNode)
				return oldValue
			} else {
				let newNode = Node(key: key, value: value)
				node.rightChild = newNode
				balanceLeft(&currNode)

				if key > endNode!.key {
					endNode = newNode
				}
			}
		}

		return nil
	}

	
	/// Removes the value associated with a key, and balances the tree if needed.
	///
	/// - parameter key: the key whose value we are removing.
	///
	/// - returns: the removed value.
	@discardableResult public mutating func removeValue(forKey key: Key) -> Value? {
		if root != nil {
			if let oldValue = removeValue(forKey: key, fromNode: &root) {
				count -= 1
				return oldValue
			}
		}
		return nil
	}

	@discardableResult internal mutating func removeValue(forKey key: Key, fromNode currNode: inout Node?) -> Value? {
		precondition(root != nil)

		guard let node = currNode else {
			return nil
		}

		if key < node.key {
			if node.leftChild != nil {
				let oldValue = removeValue(forKey: key, fromNode: &node.leftChild)
				balanceLeft(&currNode)
				return oldValue
			} else {
				return nil
			}
		} else if key > node.key {
			if node.rightChild != nil {
				let oldValue = removeValue(forKey: key, fromNode: &node.rightChild)
				balanceRight(&currNode)
				return oldValue
			} else {
				return nil
			}
		} else {
			let oldValue = node.value

			if node.leftChild == nil && node.rightChild == nil {
				currNode = nil
			} else if node.leftChild != nil && node.rightChild != nil {
				let min = node.rightChild!.minimum
				let oldValue = removeValue(forKey: min.key, fromNode: &currNode)
				node.key = min.key
				node.value = min.value
				return oldValue
			} else {
				if let left = node.leftChild {
					currNode = left
				} else {
					currNode = node.rightChild
				}
			}

			if key == startNode!.key {
				startNode = node.next
			}

			if key == endNode!.key {
				endNode = node.previous
			}

			return oldValue
		}
	}

	fileprivate func findNode(forKey key: Key, fromNode node: Node?) -> Node? {
		if let node = node {
			if key == node.key {
				return node
			} else if key < node.key {
				return findNode(forKey: key, fromNode: node.leftChild)
			} else {
				return findNode(forKey: key, fromNode: node.rightChild)
			}
		} else {
			return nil
		}
	}
}

extension AVLTreeMap {
	internal mutating func balanceLeft(_ currNode: inout Node?) {
		guard let node = currNode else {
			return
		}
		
		node.updateHeight()

		if (node.rightChild?.height ?? -1) - (node.leftChild?.height ?? -1) > 1 {
			if (node.rightChild?.leftChild?.height ?? -1) > (node.rightChild?.rightChild?.height ?? -1) {
				rotateRightLeft(&currNode!)
			} else {
				rotateLeft(&currNode!)
			}
		}
	}

	internal mutating func balanceRight(_ currNode: inout Node?) {
		guard let node = currNode else {
			return
		}
		
		node.updateHeight()

		if (node.leftChild?.height ?? -1) - (node.rightChild?.height ?? -1) > 1 {
			if (node.leftChild?.rightChild?.height ?? -1) > (node.leftChild?.leftChild?.height ?? -1) {
				rotateLeftRight(&currNode!)
			} else {
				rotateRight(&currNode!)
			}
		}
	}

	private mutating func rotateRight(_ node2: inout Node) {
		precondition(node2.leftChild != nil, "Cannot rotate right in such a tree.")
		/*
		      node2
		      /   \
		   node1   z
		    / \     \
		   x   y
		*/
		let node1 = node2.leftChild!
		node2.leftChild = node1.rightChild
		node1.rightChild = node2
		node2.updateHeight()
		node1.updateHeight()
		node2 = node1
	}

	private mutating func rotateLeft(_ node1: inout Node) {
		precondition(node1.rightChild != nil, "Cannot rotate left in such a tree.")
		/*
		      node1
		      /   \
		     x   node2
		         /   \
		        y     z
		*/
		let node2 = node1.rightChild!
		node1.rightChild = node2.leftChild
		node2.leftChild = node1
		node1.updateHeight()
		node2.updateHeight()
		node1 = node2
	}

	private mutating func rotateLeftRight(_ node: inout Node) {
		precondition(node.leftChild != nil, "Cannot rotate left right in such a node.")
		rotateLeft(&node.leftChild!)
		rotateRight(&node)
	}

	private mutating func rotateRightLeft(_ node: inout Node) {
		precondition(node.rightChild != nil, "Cannot rotate left right in such a node.")
		rotateRight(&node.rightChild!)
		rotateLeft(&node)
	}
}

extension AVLTreeMap: Sequence {
	public typealias Element = (Key, Value)
	public typealias SubSequence = AVLTreeMap<Key, Value>
	public typealias Iterator = AnyIterator<Element>

	public func makeIterator() -> Iterator {
		return AnyIterator(AVLTreeIterator<Key, Value, Element>.defaultIterator(forTree: self))
	}
}

extension AVLTreeMap: BidirectionalCollection {
	public typealias Index = AVLTreeIndex<Key, Value>

	public var startIndex: Index {
		return Index(startNode, previous: nil)
	}

	public var endIndex: Index {
		return Index(nil, previous: endNode)
	}

	public var isEmpty: Bool {
		return root == nil
	}

	public func index(before i: Index) -> Index {
		return i.previous()
	}

	public func index(after i: Index) -> Index {
		return i.next()
	}

	public subscript(index: Index) -> Element {
		precondition(index.node != nil, "AVLTreeMap index out of bounds")
		return index.node!.keyValue
	}

	public subscript(bounds: Range<Index>) -> SubSequence {
		return self[CountableRange<Index>(bounds)]
	}

	public subscript(bounds: CountableRange<Index>) -> SubSequence {
		var min, max: Node?
		var count = 0
		let root = subTreeRoot(bounds: bounds, size: bounds.count, min: &min, max: &max, count: &count)
		return AVLTreeMap<Key, Value>(root, startNode: min, endNode: max, count: count)
	}

	private func subTreeRoot(bounds: CountableRange<Index>, size: Int, min: inout Node?, max: inout Node?, count: inout Int) -> Node? {
		if size == 0 {
			return nil
		} else if size == 1 {
			let oldKeyValue = self[bounds.first!]
			let node = Node(oldKeyValue)

			if min == nil || min!.key > oldKeyValue.0 {
				min = node
			}

			if max == nil || max!.key < oldKeyValue.0 {
				max = node
			}

			count += 1
			return node
		} else {
			let middle: Int = Int(floor(Double(size - 1) / 2.0))
			let middleIndex = index(bounds.first!, offsetBy: middle)

			let node = Node(self[middleIndex])
			node.leftChild = subTreeRoot(bounds: bounds.first!..<middleIndex, size: middle, min: &min, max: &max, count: &count)
			node.rightChild = subTreeRoot(bounds: middleIndex.next()..<bounds.last!.next(), size: size - middle - 1, min: &min, max: &max, count: &count)
			count += 1
			return node
		}
	}
}

extension AVLTreeMap: CustomStringConvertible {
	public var description: String {
		get {
			let nodeString = root?.description ?? "nil"
			return "AVLTreeMap<count: \(count), nodes: \(nodeString)>"
		}
	}
}

extension AVLTreeMap: CustomDebugStringConvertible {
	public var debugDescription: String {
		get {
			return "AVLTreeMap<count: \(count), startNodeKey: \(startNode?.key), endNodeKey: \(endNode?.key)>"
		}
	}
}

// MARK: Draw in console
extension AVLTreeMap where Key: CustomStringConvertible {
	public func log() {
		root?.log()
		print("")
	}
	
	/// A series of text lines with an text drawing of the tree.
	///
	/// - returns: The array of lines.
	public func drawASCII() -> [String] {
		return root?.drawASCII() ?? []
	}
}

extension AVLTreeNode where Key: CustomStringConvertible {
	internal func log() {
		for line in drawASCII() {
			print(line)
		}
	}
	
	// The first returned string is the topmost one
	internal func drawASCII() -> [String] {
		let nodeString = "(\(key))"
		
		let leftStrings = leftChild?.drawASCII() ?? []
		let rightStrings = rightChild?.drawASCII() ?? []
		
		if leftStrings.count == 0 && rightStrings.count == 0 {
			return [nodeString]
		} else if leftStrings.count == 0 {
			let childSize = rightStrings.first!.characters.count
			let topLine = makeLine(keyString: nodeString, childSize: childSize, hasLeftBranch: false, hasRightBranch: true)
			
			return [topLine] + rightStrings.map{ String(repeating: " ", count: ((topLine.characters.count - 1) / 2) + 1) + $0 }
		} else if rightStrings.count == 0 {
			let childSize = leftStrings.first!.characters.count
			let topLine = makeLine(keyString: nodeString, childSize: childSize, hasLeftBranch: true, hasRightBranch: false)
			
			return [topLine] + leftStrings.map{ $0 + String(repeating: " ", count: ((topLine.characters.count - 1) / 2) + 1) }
		} else {
			let leftSize = leftStrings.first!.characters.count
			let rightSize = rightStrings.first!.characters.count
			let childSize = leftSize > rightSize ? leftSize : rightSize // Weird error: max(leftSize, rightSize)
			let topLine = makeLine(keyString: nodeString, childSize: childSize, hasLeftBranch: true, hasRightBranch: true)
			let topChildSize = (topLine.characters.count - 1) / 2
			
			let fillToSize: (String, Int) -> String = { (string, size) in
				if topChildSize <= size {
					return string
				} else {
					let diff = topChildSize - size
					let leftSpace = diff / 2
					let rightSpace = diff - leftSpace
					
					return String(repeating: " ", count: leftSpace) + string + String(repeating: " ", count: rightSpace)
				}
			}
			
			var result: [String] = [topLine]
			let min = leftStrings.count > rightStrings.count ? rightStrings.count : leftStrings.count // Weird error: min(leftStrings.count, rightStrings.count)
			for i in 0..<min {
				result.append(fillToSize(leftStrings[i], leftSize) + " " + fillToSize(rightStrings[i], rightSize))
			}
			
			let diff = leftStrings.count - rightStrings.count
			let biggest: [String] = diff > 0 ? leftStrings : rightStrings
			for i in (biggest.count - abs(diff))..<biggest.count {
				if diff > 0 {
					result.append(fillToSize(leftStrings[i], leftSize) + String(repeating: " ", count: topChildSize + 1))
				} else {
					result.append(String(repeating: " ", count: topChildSize + 1) + fillToSize(rightStrings[i], rightSize))
				}
			}
			
			
			return result
		}
	}
	
	private func makeLine(keyString: String, childSize oldChildSize: Int, hasLeftBranch: Bool, hasRightBranch: Bool) -> String {
		var rightString: String = ""
		var leftString: String = ""
		
		let keySize = keyString.characters.count
		let childSize = max(oldChildSize, keySize / 2)
		let totalSize = 2 * childSize + 1
		let leftSize = childSize - ((keySize - 1) / 2)
		let rightSize = totalSize - (leftSize + keySize)
		let spaces = (childSize - 1) / 2
		
		let spacesString = String(repeating: " ", count: spaces)
		if hasLeftBranch {
			leftString = spacesString + "+" + String(repeating: "-", count: leftSize - (spaces + 1))
		} else {
			leftString = String(repeating: " ", count: leftSize)
		}
		
		if hasRightBranch {
			rightString = String(repeating: "-", count: rightSize - (spaces + 1)) + "+" + spacesString
		} else {
			rightString = String(repeating: " ", count: rightSize)
		}
		
		return leftString + keyString + rightString
	}

}

/// - complexity: O(n) where n = min(lhs.count, rhs.count)
public func ==<Key: Comparable, Value: Equatable>(lhs: AVLTreeMap<Key, Value>, rhs: AVLTreeMap<Key, Value>) -> Bool {
	guard lhs.count == rhs.count else {
		return false
	}
	
	for (leftElement, rightElement) in zip(lhs, rhs) {
		if leftElement != rightElement {
			return false
		}
	}
	
	return true
}
