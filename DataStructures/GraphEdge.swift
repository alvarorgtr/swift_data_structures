//
//  GraphEdge.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 23/3/17.
//  Copyright © 2017 DeltaApps. All rights reserved.
//

import Foundation

public protocol GraphEdgeProtocol: Equatable {
	var from: Int { get set }
	var to: Int { get set }
	
	var either: Int { get }
	func other(endpoint: Int) -> Int
	
	init(from: Int, to: Int)
}

extension GraphEdgeProtocol {
	public var either: Int {
		return from
	}
	
	public func other(endpoint: Int) -> Int {
		return (from == endpoint) ? to : from
	}
}
