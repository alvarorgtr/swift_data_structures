//
//  GraphTraversal.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 5/4/17.
//  Copyright © 2017 DeltaApps. All rights reserved.
//

import Foundation

extension Graph {
	public func depthFirstSearched() -> AnySequence<Vertex> {
		return AnySequence<Vertex>(makeDFSIterator())
	}
	
	public func breadthFirstSearched() -> AnySequence<Vertex> {
		return AnySequence<Vertex>(makeBFSIterator())
	}
	
	public func makeDFSIterator() -> AnyIterator<Vertex> {
		var stack = Stack<DFSVertex>()
		let vertices = vertexCount
		var marked = [Bool](repeating: false, count: vertices)
		var index = 1
		
		if !isEmpty {
			stack.push(DFSVertex(vertex: 0, adjacent: edges[0]))
			marked[0] = true
		}
		
		return AnyIterator<Vertex>({ () -> Vertex? in
			var next: DFSVertex
			while (!stack.isEmpty || index < vertices) {
				if stack.isEmpty {
					// Look for the next connected component
					while index < vertices && marked[index] {
						index += 1
					}
					
					if index < vertices {
						stack.push(DFSVertex(vertex: index, adjacent: self.edges[index]))
						marked[index] = true
						index += 1
					}
				} else {
					next = stack.pop()!
					
					if let edge = next.adjacent.first {
						next.adjacent.removeFirst()
						stack.push(next)
						if !marked[edge] {
							stack.push(DFSVertex(vertex: edge, adjacent: self.edges[edge]))
							marked[edge] = true
						}
					}
					
					if (!next.visited) {
						next.visited = true
						return self.vertex(for: next.vertex)
					}
				}
			}
			
			return nil
		})
	}
	
	public func makeBFSIterator() -> AnyIterator<Vertex> {
		var queue = Queue<Int>()
		let vertices = vertexCount
		var marked = [Bool](repeating: false, count: vertices)
		var index = 1
		
		if !isEmpty {
			queue.push(0)
			marked[0] = true
		}
		
		return AnyIterator<Vertex>({ () -> Vertex? in
			if queue.isEmpty {
				// Look for the next connected component
				if index >= vertices {
					return nil
				} else {
					while index < vertices && marked[index] {
						index += 1
					}
					
					if index < vertices {
						queue.push(index)
						marked[index] = true
						index += 1
					}
				}
			}
			
			guard let next = queue.pop() else {
				return nil
			}
			
			for edge in self.edges[next] {
				if !marked[edge.to] {
					queue.push(edge.to)
					marked[edge.to] = true
				}
			}
			
			return self.vertex(for: next)
		})
	}
}

fileprivate class DFSVertex {
	var vertex: Int
	var adjacent: List<Int>
	var visited = false
	
	required init(vertex: Int, adjacent: List<GraphEdge<Int>>) {
		self.vertex = vertex
		self.adjacent = List<Int>(adjacent.map { $0.to })
	}
}
