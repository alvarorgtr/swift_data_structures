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
}

public extension GraphCollection where IndexDistance == Int {
	public var count: Self.IndexDistance {
		return vertexCount
	}
}
