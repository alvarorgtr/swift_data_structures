//
// Created by alvaro on 14/10/16.
//

import Foundation

internal struct AVLTreeIterator<Key: Comparable, Value, Iterable>: IteratorProtocol {
	internal typealias Element = Iterable

	private var index: AVLTreeIndex<Key, Value>
	private var iterableExtractor: (AVLTreeNode<Key, Value>) -> Element

	init(tree: AVLTreeMap<Key, Value>, iteratedOver iterator: @escaping (AVLTreeNode<Key, Value>) -> Element) {
		index = AVLTreeIndex<Key, Value>(tree: tree)
		iterableExtractor = iterator
	}

	internal mutating func next() -> Element? {
		if let node = index.node {
			index = index.next()
			return iterableExtractor(node)
		} else {
			return nil
		}
	}

	public static func defaultIterator(forTree tree: AVLTreeMap<Key, Value>) -> AVLTreeIterator<Key, Value, (Key, Value)> {
		return AVLTreeIterator<Key, Value, (Key, Value)>(tree: tree, iteratedOver: { (node) in (node.key, node.value) })
	}
}