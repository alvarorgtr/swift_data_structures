//: Playground - noun: a place where people can play

import UIKit
import DataStructures

var str = "Hello, playground"

var heap = FibonacciHeap<Int>()

heap.insert(4)
heap.insert(32)
heap.insert(25)
heap.insert(1)

var heap2 = FibonacciHeap<Int>()

heap2.insert(6)
heap2.insert(24)
heap2.insert(2)
heap2.insert(33)

var heap3 = heap.union(heap2)
heap
heap2

heap3.extractMinimum()
heap3
heap3.minimum
heap3.extractMinimum()
heap3
heap3.extractMinimum()
heap3
