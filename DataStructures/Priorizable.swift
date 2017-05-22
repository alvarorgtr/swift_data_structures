//
//  Priorizable.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 22/5/17.
//  Copyright © 2017 DeltaApps. All rights reserved.
//

import Foundation

public protocol Priorizable {
	associatedtype Priority
	
	var priority: Priority { get }
}
