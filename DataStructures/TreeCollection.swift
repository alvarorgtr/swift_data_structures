//
//  TreeCollection.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 27/12/16.
//  Copyright © 2016 DeltaApps. All rights reserved.
//

import Foundation

public protocol TreeCollection: BidirectionalCollection {
	associatedtype Index = Iterator.Index
	associatedtype Node: Index.Node
	associatedtype Element = (Iterator.Index.Node.Key, Iterator.Index.Node.Value)
	associatedtype Iterator: TreeIterator
	
}

public protocol TreeMapCollection: TreeCollection, DictionaryCollection {
	
}
