//
//  TreeCollection.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 27/12/16.
//  Copyright © 2016 DeltaApps. All rights reserved.
//

import Foundation

public protocol TreeCollection: BidirectionalCollection {
	associatedtype Index: TreeIndex
	associatedtype Node: Index.Node
	associatedtype Element = (Index.Node.Key, Index.Node.Value)
	
	
}
