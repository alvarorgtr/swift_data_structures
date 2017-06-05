//
//  Dijkstra.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 27/5/17.
//  Copyright © 2017 DeltaApps. All rights reserved.
//

import Foundation

public class Dijkstra {
	private typealias Edge = DirectedWeightedGraphEdge<Int, Double>
	
	private var edgeTo: [Edge?] = []
	private var distTo: [Double] = []
	private var pq = FibonacciHeap<Int, Double>()
	
	// ACCESSORS
	func lenghtOfShortestPath(to v: Int) -> Double {
		return distTo[v]
	}
	
	// DIJKSTRA
	func computeShortestPaths(on graph: WeightedDigraph<Double>, startingFrom s: Int) {
		self.edgeTo = [Edge?](repeating: nil, count: graph.vertexCount)
		self.distTo = [Double](repeating: Double.infinity, count: graph.vertexCount)
		self.pq = FibonacciHeap<Int, Double>()
		
		distTo[s] = 0
		pq.insert(s, with: 0.0)
		
		while let v = pq.extractMinimum() {
			for edge in graph.adjacentEdges(to: v) {
				relax(edge)
			}
		}
	}
	
	private func relax(_ e: Edge) {
		let v = e.from
		let w = e.to
		
		if distTo[w] > distTo[v] + e.weight {
			distTo[w] = distTo[v] + e.weight
			edgeTo[w] = e
			
			pq.decreasePriority(of: w, to: distTo[w])	// Automagically inserts the node if it isn't already there
		}
	}
}
