//
//  GraphTests.swift
//  DataStructures
//
//  Created by Álvaro Rodríguez García on 23/3/17.
//  Copyright © 2017 DeltaApps. All rights reserved.
//

import XCTest
import Foundation
@testable import DataStructures

class GraphTests: XCTestCase {
	var smallGraph: LabelledGraph<Int>!
	
	let smallGraphEdges = [(1,2), (2,3), (2,4), (4,1), (5,7), (6,7)]
	var smallGraphMaxVertex: Int {
		return smallGraphEdges.reduce(Int.min) { (result, edge) -> Int in return max(result, edge.0, edge.1) }
	}
	
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
		smallGraph = LabelledGraph<Int>(edges: smallGraphEdges)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	/*
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    } */
	
	func testCreation() {
		XCTAssertEqual(smallGraphEdges.count, smallGraph.edgeCount, "Wrong edge count")
		XCTAssertEqual(smallGraphMaxVertex, smallGraph.vertexCount, "Wrong vertex count")
	}
	
	func testBigGraph() {
		if let path = Bundle(for: GraphTests.self).path(forResource: "BigGraph", ofType: "txt") {
			do {
				let contents = try String(contentsOfFile: path)
				let graph = try parseIntGraph(from: contents)
				
				XCTAssertEqual(1476, graph.edgeCount, "Wrong edge count")
				XCTAssertEqual(829, graph.vertexCount, "Wrong vertex count")
			} catch ReadingError.parsing(line: let line) {
				XCTFail("Big graph parsing failed with line contents <\(line)>")
			} catch {
				XCTFail("Big graph reading failed; error unknown")
			}
		}
	}
	
	func testAccessors() {
		XCTAssertEqual(smallGraph.degree(of: 1), 2, "Wrong degree for vertex 1")
		XCTAssertEqual(smallGraph.degree(of: 4), 2, "Wrong degree for vertex 4")
		XCTAssertEqual(smallGraph.degree(of: 6), 1, "Wrong degree for vertex 6")

		XCTAssertTrue(smallGraph.areAdjacent(4, 2), "4 and 2 are adjacent")
		XCTAssertFalse(smallGraph.areAdjacent(5, 6), "5 and 6 are not adjacent")
		
		for pair in zip(smallGraph.adjacentVertices(to: 4), [2, 1]) {
			XCTAssertEqual(pair.0, pair.1, "Wrong adjacency list for vertex 4: \(pair.0) != \(pair.1)")
		}
	}
	
	func testAccessorsInStringGraph() {
		let graph = LabelledGraph<String>(edges: smallGraphEdges.map { (String($0.0), String($0.1)) }.reversed())
		
		XCTAssertEqual(graph.degree(of: "1"), 2, "Wrong degree for vertex 1")
		XCTAssertEqual(graph.degree(of: "4"), 2, "Wrong degree for vertex 4")
		XCTAssertEqual(graph.degree(of: "6"), 1, "Wrong degree for vertex 6")
		
		XCTAssertTrue(graph.areAdjacent("4", "2"), "4 and 2 are adjacent")
		XCTAssertFalse(graph.areAdjacent("5", "6"), "5 and 6 are not adjacent")
		
		for pair in zip(graph.adjacentVertices(to: "4"), ["1", "2"]) {
			XCTAssertEqual(pair.0, pair.1, "Wrong adjacency list for vertex 4: \(pair.0) != \(pair.1)")
		}
	}
	
	func testAdding() {
		var graph = LabelledGraph<String>()
		
		graph.addEdge(from: "A", to: "C")
		XCTAssertFalse(graph.isEmpty, "The graph is not empty")
		XCTAssertTrue(graph.areAdjacent("C", "A"), "C and A are adjacent")
		XCTAssertFalse(graph.areAdjacent("B", "A"), "B cannot be adjacent to nothing")
		
		graph.addEdge(from: "A", to: "D")
		XCTAssertTrue(graph.areAdjacent("A", "D"), "A and D are adjacent")
		XCTAssertFalse(graph.areAdjacent("C", "D"), "C is not adjacent to D")
		
		graph.add(vertex: "B")
		XCTAssertTrue(graph.contains("B"), "B should be a vertex")
		XCTAssertTrue(graph.adjacentVertices(to: "B").elementsEqual([]), "B should not have adjacent vertices")
		
		graph.add(edge: GraphEdge<String>(from: "B", to: "A"))
		XCTAssertTrue(graph.areAdjacent("A", "B"), "A and B are adjacent")
		XCTAssertFalse(graph.areAdjacent("B", "B"), "B is not adjacent to itself")
	}
	
	func testDFS() {
		XCTAssertTrue(smallGraph.depthFirstSearched().elementsEqual([1,2,3,4,5,7,6]), "The DFS is not that")
		
		let graph2 = LabelledGraph<Int>(edges: [(1,2),(2,3),(3,4),(1,5),(5,6),(6,7),(5,8),(1,9),(9,10)])
		XCTAssertTrue(graph2.depthFirstSearched().elementsEqual(1...10), "The DFS is not that")
	}
	
	func testBFS() {
		XCTAssertTrue(smallGraph.breadthFirstSearched().elementsEqual([1,2,4,3,5,7,6]), "The BFS is not that")
		
		let stringGraph = LabelledGraph<String>(edges: [("A","E"), ("A","B"), ("A", "C"), ("A","G"), ("E","D"), ("E","F"), ("D", "F"), ("F", "G")])
		XCTAssertTrue(stringGraph.breadthFirstSearched().elementsEqual(["A", "E", "B", "C", "G", "D", "F"]), "The BFS is not that")
	}
	
	func testDijkstra() {
		// TODO
	}
}

extension GraphTests {
	fileprivate func parseIntGraph(from string: String) throws -> LabelledGraph<Int> {
		var graph = LabelledGraph<Int>()
		var count = 1
		
		for line in string.components(separatedBy: CharacterSet.newlines).dropLast() {
			let words = line.components(separatedBy: CharacterSet.whitespaces)
			if words.count >= 2, let from = Int(words[0]), let to = Int(words[1]) {
				graph.add(edge: GraphEdge<Int>(from: from, to: to))
			} else {
				throw ReadingError.parsing(line: count)
			}
			count += 1
		}
		
		return graph
	}
}

fileprivate enum ReadingError: Error {
	case parsing(line: Int)
}
