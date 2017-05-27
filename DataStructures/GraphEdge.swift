//
//  GraphEdge.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 23/3/17.
//  Copyright © 2017 DeltaApps. All rights reserved.
//

import Foundation

public protocol GraphEdgeProtocol {
	associatedtype Label: Equatable
	
	var from: Label { get }
	var to: Label { get }
	
	var either: Label { get }
	func other(endpoint: Label) -> Label
}

extension GraphEdgeProtocol {
	public var either: Label {
		return from
	}
	
	public func other(endpoint: Label) -> Label {
		return (from == endpoint) ? to : from
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

public struct DirectedGraphEdge<Label: Equatable>: GraphEdgeProtocol {
	public var from: Label
	public var to: Label
	
	public init(from: Label, to: Label) {
		self.from = from
		self.to = to
	}
}

public struct DirectedWeightedGraphEdge<Label: Equatable, Weight: Comparable>: GraphEdgeProtocol {
	public var from: Label
	public var to: Label
	public var weight: Weight
	
	public init(from: Label, to: Label, weight: Weight) {
		self.from = from
		self.to = to
		self.weight = weight
	}
}
