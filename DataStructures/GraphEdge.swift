//
//  GraphEdge.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 23/3/17.
//  Copyright © 2017 DeltaApps. All rights reserved.
//

import Foundation

public protocol GraphEdgeProtocol: Equatable {
	associatedtype Label: Equatable
	
	var from: Label { get }
	var to: Label { get }
	
	var either: Label { get }
	func other(endpoint: Label) -> Label
	
	init(from: Label, to: Label)
}

extension GraphEdgeProtocol {
	public var either: Label {
		return from
	}
	
	public func other(endpoint: Label) -> Label {
		return (from == endpoint) ? to : from
	}
}
