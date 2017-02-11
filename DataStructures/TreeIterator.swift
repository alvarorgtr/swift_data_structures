//
//  TreeIterator.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 11/2/17.
//  Copyright © 2017 DeltaApps. All rights reserved.
//

import Foundation

public protocol TreeIterator: IteratorProtocol {
	associatedtype Index: TreeIndex
	
}
