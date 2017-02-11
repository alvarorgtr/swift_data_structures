//
//  DictionaryCollection.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 11/2/17.
//  Copyright © 2017 DeltaApps. All rights reserved.
//

import Foundation

public protocol DictionaryCollection: Collection, ExpressibleByDictionaryLiteral {
	associatedtype Key: Equatable
	associatedtype Value
	
	subscript(key: Key) -> Value? { get set }
	
	@discardableResult mutating func removeValue(forKey key: Key) -> Value?
	@discardableResult mutating func updateValue(_ value: Value, forKey key: Key) -> Value?
}

extension Dictionary: DictionaryCollection {
	
}
