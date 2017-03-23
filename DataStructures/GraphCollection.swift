//
//  File.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 23/3/17.
//  Copyright © 2017 DeltaApps. All rights reserved.
//

import Foundation

public protocol GraphCollection: Collection {
	associatedtype Vertex: Equatable
	associatedtype Edge: GraphEdgeProtocol
	
	var vertexCount: Int { get }
	var edgeCount: Int { get }
	
	func vertex(for label: Int) -> Vertex
}

public extension GraphCollection where IndexDistance == Int {
	public var count: Self.IndexDistance {
		return vertexCount
	}
	
	public var startIndex: Int {
		return 0
	}
	
	public var endIndex: Int {
		return count
	}
}

public extension GraphCollection where Index == Int {
	public func index(after i: Index) -> Index {
		return i + 1
	}
	
	public func makeIterator() -> AnyIterator<Vertex> {
		var index = 0
		return AnyIterator<Vertex> {
			if index < self.endIndex {
				index += 1
				return self.vertex(for: index)
			}
			
			return nil
		}
	}
	
	public subscript(i: Index) -> Vertex {
		return vertex(for: i)
	}
}
