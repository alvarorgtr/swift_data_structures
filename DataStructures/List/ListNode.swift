//
//  ListNode.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 29/10/16.
//  Copyright © 2016 DeltaApps. All rights reserved.
//

import Foundation

internal class ListNode<Element> {
	internal var next: ListNode<Element>?
	internal weak var previous: ListNode<Element>?
	internal var value: Element
	
	internal init(value: Element, previous: ListNode<Element>? = nil, next: ListNode<Element>? = nil) {
		self.value = value
		self.next = next
		self.previous = previous
	}
}
