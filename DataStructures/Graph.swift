//
//  Graph.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 23/3/17.
//  Copyright © 2017 DeltaApps. All rights reserved.
//

import Foundation

fileprivate typealias TreeMap<Key: Comparable, Value> = AVLTreeMap<Key, Value>

/**
Implementation of a undirected, unweighted graph via adjacency lists.

For the label management we are using the Sedgewick et al. implementation.

Possible anomalies: parallel edges, self-loops
*/
public struct Graph<Label: Hashable> {
	public typealias Vertex = Label
	public typealias Edge = GraphEdge<Int>
	
	/*
	private ST<String, Integer> st;
	private String[] keys;
	private Graph G;
	*/
	private var edges: [List<Edge>]
	fileprivate var vertices: [Vertex]
	private var keys: [Vertex: Int]
	
	public var edgeCount: Int = 0
	
	public var vertexCount: Int {
		return vertices.count
	}
	
	// MARK: Initializers
	
	init() {
		edges = []
		vertices = []
		keys = [:]
	}
	
	init<V: Sequence, E: Sequence>(vertices: V, edges: E) where V.Iterator.Element == Vertex, E.Iterator.Element == (from: Vertex, to: Vertex) {
		self.vertices = [Vertex](vertices)
		self.edges = Array(repeating: List<Edge>(), count: self.vertices.count)
		keys = [:]
		
		for (index, vertex) in self.vertices.enumerated() {
			keys[vertex] = index
		}
		
		for edgeTuple in edges {
			if let from = keys[edgeTuple.from], let to = keys[edgeTuple.to] {
				let edge1 = Edge(from: from, to: to)
				let edge2 = Edge(from: to, to: from)
				self.edges[edge1.from].appendFirst(edge1)
				self.edges[edge2.from].appendFirst(edge2)
				edgeCount += 1
			} else {
				fatalError("Unknown vertex in edge")
			}
		}
	}
	
	// MARK: Accessors
	public func degree(of vertex: Vertex) -> Int {
		precondition(keys[vertex] != nil, "The vertex must be in the graph")
		
		return edges[keys[vertex]!].count
	}
	
	public func adjacentVertices(to vertex: Vertex) -> AnySequence<GraphEdge<Vertex>> {
		precondition(keys[vertex] != nil, "The vertex must be in the graph")

		return AnySequence<GraphEdge<Vertex>>(self.edges[keys[vertex]!].map({ (edge) -> GraphEdge<Vertex> in
			return GraphEdge<Vertex>(from: self.vertices[edge.from], to: self.vertices[edge.to])
		}))
	}
	
	// MARK: Mutators
	
	/** Adds a vertex to the graph if it isn't already there.
	- parameter vertex: the vertex to be added.
	- returns: the index of the vertex.
	- complexity: Amortized O(1)
	*/
	@discardableResult
	public mutating func add(vertex: Vertex) -> Int {
		if let index = keys[vertex] {
			return index
		} else {
			vertices.append(vertex)
			keys[vertex] = vertexCount - 1
			return vertexCount - 1
		}
	}
	
	/** Adds the edge from-to to the graph and the corresponding vertices if needed. Since the graph is not directed the to-from edge is also added.
	- parameter from: the first vertex
	- parameter to: the second vertex
	- warning: this function doesn't check for parallel vertices.
	*/
	public mutating func addEdge(from: Vertex, to: Vertex) {
		// Won't add if already there
		let fromInt = add(vertex: from)
		let toInt = add(vertex: to)
		
		let edge1 = Edge(from: fromInt, to: toInt)
		let edge2 = Edge(from: toInt, to: fromInt)

		edges[fromInt].appendFirst(edge1)
		edges[toInt].appendFirst(edge2)
		
		edgeCount += 1
	}
	
	/** Adds the edge from-to to the graph and the corresponding vertices if needed. Since the graph is not directed the to-from edge is also added.
	- parameter edge: the edge.
	- warning: this function doesn't check for parallel vertices.
	*/
	public mutating func add(edge: GraphEdge<Vertex>) {
		addEdge(from: edge.from, to: edge.to)
	}
	
	
}

extension Graph: GraphCollection {
	public typealias Element = Label

	public typealias Index = Int
	public typealias Iterator = AnyIterator<Vertex>
	
	public func vertex(for label: Int) -> Element {
		return vertices[label]
	}
}

public struct GraphEdge<Label: Equatable>: GraphEdgeProtocol {
	public var from: Label
	public var to: Label
	
	public init(from: Label, to: Label) {
		self.from = from
		self.to = to
	}
}

public func ==<Label: Equatable>(lhs: GraphEdge<Label>, rhs: GraphEdge<Label>) -> Bool {
	return (lhs.from == rhs.from && lhs.to == rhs.to) || (lhs.from == rhs.to && lhs.to == rhs.from)
}
