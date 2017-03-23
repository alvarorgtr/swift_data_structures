//
//  Graph.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 23/3/17.
//  Copyright © 2017 DeltaApps. All rights reserved.
//

import Foundation

public struct Graph<Element: Equatable> {
	public typealias Vertex = Element
	public typealias Edge = GraphEdge
	
	private var edges: [Int: List<Vertex>] = [:]
	fileprivate var vertices: [Vertex] = []
	
	public var edgeCount: Int {
		// TODO: Store it
		return edges.reduce(0, { (sum: Int, element: (key: Int, value: List<Vertex>)) -> Int in
			return sum + element.value.count
		})
	}
	
	public var vertexCount: Int {
		return vertices.count
	}
}

extension Graph: GraphCollection {
	public typealias Index = Int
	public typealias Iterator = AnyIterator<Vertex>
	
	public func vertex(for label: Int) -> Element {
		return vertices[label]
	}
}

public struct GraphEdge: GraphEdgeProtocol {
	public var from: Int = 0
	public var to: Int = 0
	
	public init(from: Int, to: Int) {
		self.from = from
		self.to = to
	}
}

public func ==(lhs: GraphEdge, rhs: GraphEdge) -> Bool {
	return (lhs.from == rhs.from && lhs.to == rhs.to) || (lhs.from == rhs.to && lhs.to == rhs.from)
}
