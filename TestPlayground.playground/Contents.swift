//: Playground - noun: a place where people can play

import UIKit
import DataStructures

var str = "Hello, playground"

var heap = FibonacciHeap<String, Int>()

heap.insert("a", with: 4)
heap.insert("b", with: 32)
heap.insert("c", with: 25)
heap.insert("d", with: 1)

var heap2 = FibonacciHeap<String, Int>()

heap2.insert("e", with: 6)
heap2.insert("f", with: 24)
heap2.insert("g", with: 2)
heap2.insert("h", with: 33)

var heap3 = heap.union(heap2)
heap
heap2

heap3.extractMinimumAndPriority()
heap3
heap3.minimum
heap3.extractMinimumAndPriority()
heap3
heap3.extractMinimumAndPriority()
heap3
heap3.insert("i", with: 42)
heap3.insert("j", with: 1)
heap3.insert("k", with: 10)
heap3.insert("l", with: 31)
heap3.extractMinimumAndPriority()

heap3.insert("m", with: 11)
heap3
heap3.decreasePriority(of: "k", to: 4)
heap3.decreasePriority(of: "h", to: 17)
heap3.decreasePriority(of: "h", to: 0)
heap3.extractMinimumAndPriority()
heap3
heap3.decreasePriority(of: "i", to: 0)
heap3.delete("c")