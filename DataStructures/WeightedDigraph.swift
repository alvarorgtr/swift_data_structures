//
//  Graph.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 27/5/17.
//  Copyright © 2017 DeltaApps. All rights reserved.
//

import Foundation

struct WeightedDigraph<Weight: Comparable> {
	public typealias Vertex = Int
	public typealias Edge = DirectedWeightedGraphEdge<Vertex, Weight>
	
	internal var edges: [List<Edge>]
	
	public var edgeCount: Int = 0
	public private(set) var vertexCount: Int
	
	init<E: Sequence>(vertexCount: Int, edges: E? = nil) where E.Iterator.Element == Edge {
		self.vertexCount = vertexCount
		self.edges = Array(repeating: List<Edge>(), count: vertexCount)
		
		if let edges = edges {
			for edge in edges {
				if edge.from < vertexCount && edge.to < vertexCount {
					add(edge: edge)
				}
			}
		}
	}
	
	// MARK: Accessors
	public func degree(of vertex: Vertex) -> Int {
		precondition(vertex < vertexCount, "The vertex must be in the graph")
		
		return edges[vertex].count
	}
	
	public func adjacentVertices(to vertex: Vertex) -> AnySequence<Vertex> {
		precondition(vertex < vertexCount, "The vertex must be in the graph")
		
		return AnySequence<Vertex>(self.edges[vertex].map({ (edge) -> Vertex in
			return edge.to
		}))
	}
	
	public func adjacentEdges(to vertex: Vertex) -> AnySequence<Edge> {
		precondition(vertex < vertexCount, "The vertex must be in the graph")
		
		return AnySequence<Edge>(self.edges[vertex].map({ (edge) -> Edge in
			return edge
		}))
	}

	// MARK: Mutators

	/** Adds a vertex to the graph if it isn't already there.
	- parameter vertex: the vertex to be added.
	- returns: the index of the vertex.
	- complexity: Amortized O(1)
	*/
	@discardableResult
	public mutating func addVertex() -> Int {
		vertexCount += 1
		edges.append(List<Edge>())
		return vertexCount - 1
	}
	
	/** Adds the edge from-to to the graph and the corresponding vertices if needed. Since the graph is not directed the to-from edge is also added.
	- parameter from: the first vertex
	- parameter to: the second vertex
	- warning: this function doesn't check for parallel vertices.
	*/
	public mutating func addEdge(from: Vertex, to: Vertex, weight: Weight) {
		precondition(from < vertexCount && to < vertexCount, "The edge has an endpoint that does not exist.")
		
		let edge = Edge(from: from, to: to, weight: weight)
		add(edge: edge)
	}
	
	/** Adds the edge from-to to the graph and the corresponding vertices if needed. Since the graph is not directed the to-from edge is also added.
	- parameter edge: the edge.
	- warning: this function doesn't check for parallel vertices.
	*/
	public mutating func add(edge: Edge) {
		edges[edge.from].appendLast(edge)
		edgeCount += 1
	}

}
