/**
 * The MIT License (MIT)
 *
 * Copyright (C) 2016 Yahoo Japan Corporation.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import XCTest
@testable import SwiftyXMLParser

class AccessorTests: XCTestCase {

    override func setUp() {
        XML.ignoreNamespaces = false
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testIndexerTypeIntToSingleElement() {
        let singleElementAccessor = XML.Accessor(singleElement())
        let target1 = singleElementAccessor[0]
        if let name = target1.name {
            XCTAssertEqual(name, "RootElement", "can access element name")
        } else {
            XCTFail("fail to get name")
        }
        
        let target2 = singleElementAccessor[1]
        switch target2 {
        case .failure(_):
            XCTAssert(true, "access to wrong path")
        default:
            XCTFail("need to fail")
        }
    }
    
    func testIndexerTypeIntToSequence() {
        let accessor = XML.Accessor(sequence())
        let target1 = accessor[0]
        if let name = target1.name {
            XCTAssertEqual(name, "Element", "can access corrent element")
        } else {
            XCTFail("fail to get name")
        }
        
        let target2 = accessor[1]
        if let name = target2.name {
            XCTAssertEqual(name, "Element", "can access corrent element")
        } else {
            XCTFail("fail to get name")
        }
        
        let target3 = accessor[2]
        switch target3 {
        case .failure(_):
            XCTAssert(true, "Aaccess to wrong path")
        default:
            XCTFail("need to fail")
        }
    }
    
    func testIndexerTypeString() {
        let accessor = XML.Accessor(singleElement())
        let me = accessor["RootElement"]
        switch me {
        case .failure(_):
            XCTAssert(true, "can access corrent element")
        default:
            XCTFail("fail to get element")
        }
    }
    
    func testIndexerTypeStringShingleElement() {
        let accessor = XML.Accessor(singleElement())
        let children = accessor["ChildElement"]
        switch children {
        case .sequence(_):
            XCTAssert(true, "can access corrent element")
        default:
            XCTFail("fail to get element")
        }
    }
    
    func testIndexerTypeStringSequence() {
        let accessor = XML.Accessor(sequence())
        let failureChildren = accessor["ChildElement"]
        switch failureChildren {
        case .failure(_):
            XCTAssert(true, "need to select one element from multiple elements")
        default:
            XCTFail("need to fail")
        }
        
        let successChildren = accessor[0]["ChildElement1"]
        switch successChildren {
        case .sequence(_):
            XCTAssert(true, "can access corrent element")
        default:
            XCTFail("fail to get element")
        }
    }
    
    func testIndexerToFailure() {
        let accessor = XML.Accessor(failure())
        let intIndexer = accessor[0]
        switch intIndexer {
        case .failure(_):
            XCTAssert(true, "need to return failure when access wrong path once")
        default:
            XCTFail("need to fail")
        }
        
        let stringIndexer = accessor["ChildElement"]
        switch stringIndexer {
        case .failure(_):
            XCTAssert(true, "need to return failure when access wrong path once")
        default:
            XCTFail("need to fail")
        }
    }
    
    func testIndexTypeArray() {
        let accessor = XML.Accessor(sequence())
        let indexer = accessor[[0, "ChildElement1", 1]]
        switch indexer {
        case .singleElement(_):
            XCTAssert(true, "access element with Array")
        default:
            XCTFail("fail to get element")
        }
        
        let failureIndexer = accessor[[1, "Hoget", "Foge"]]
        switch failureIndexer {
        case .failure(_):
            XCTAssert(true, "access wrong path with Array")
        default:
            XCTFail("need to fail")
        }
    }
    
    func testIndexTypeVariableArguments() {
        let accessor = XML.Accessor(sequence())
        let indexer = accessor[0, "ChildElement1", 1]
        switch indexer {
        case .singleElement(_):
            XCTAssert(true, "access element with Variadic")
        default:
            XCTFail("fail to get element")
        }
        
        let failureIndexer = accessor[1, "Hoget", "Foge"]
        switch failureIndexer {
        case .failure(_):
            XCTAssert(true, "access wrong path with Variadic")
        default:
            XCTFail("need to fail")
        }
    }
    
    func testName() {
        let accessor = XML.Accessor(singleElement())
        if let name = accessor.name {
            XCTAssertEqual(name, "RootElement", "access name with SingleElement Accessor")
        } else {
            XCTFail("fail")
        }
        
        let sequenceAccessor = XML.Accessor(sequence())
        if let _ = sequenceAccessor.name {
            XCTFail("access name with Failure Sequence")
        } else {
            XCTAssert(true, "fail")
        }
        
        let failureAccessor = XML.Accessor(failure())
        if let _ = failureAccessor.name {
            XCTFail("fail")
        } else {
            XCTAssert(true, "fail to access name with Failure Accessor")
        }
    }
    
    func testText() {
        let accessor = XML.Accessor(singleElement())
        if let text = accessor.text {
            XCTAssertEqual(text, "text", "access text with SingleElement Accessor")
        } else {
            XCTFail("fail")
        }
        
        let sequenceAccessor = XML.Accessor(sequence())
        if let _ = sequenceAccessor.text {
            XCTFail("fail")
        } else {
            XCTAssert(true, "fail to access text with Sequence Accessor")
        }
        
        let failureAccessor = XML.Accessor(failure())
        if let _ = failureAccessor.text {
            XCTFail("fail")
        } else {
            XCTAssert(true, "fail to access name with Failure Accessor")
        }
    }

    func testSetText() throws {
        var accessor = XML.Accessor(singleElement())
        accessor.text = "text2"
        XCTAssertEqual(accessor.text, "text2", "set text on first single element")

        var element = accessor["ChildElement"].first
        element.text = "childText1"
        XCTAssertEqual(element.text, "childText1", "set text for first child element")

        element = accessor["ChildElement"].last
        element.text = "childText2"
        XCTAssertEqual(element.text, "childText2", "set text for last child element")

        XCTAssertEqual(
            try XML.document(accessor),
            "<?xml version=\"1.0\" encoding=\"UTF-8\"?><RootElement key=\"value\">text2<ChildElement >childText1</ChildElement><ChildElement >childText2</ChildElement></RootElement>",
            "end document has newly added texts"
        )

        var sequenceAccessor = XML.Accessor(sequence())
        sequenceAccessor.text = "text"
        XCTAssertEqual(sequenceAccessor.text, nil, "cannot set text on sequence")

        var accessorElement = sequenceAccessor.first
        accessorElement.text = "newText"
        XCTAssertEqual(accessorElement.text, "newText", "set text for first element in sequence")

        accessorElement = sequenceAccessor.last
        accessorElement.text = "newText2"
        XCTAssertEqual(accessorElement.text, "newText2", "set text for last element in sequence")

        accessorElement = sequenceAccessor.first["ChildElement1"]
        accessorElement.text = "childText"
        XCTAssertEqual(accessorElement.text, nil, "cannot set text for sequence")

        accessorElement = sequenceAccessor.first["ChildElement1"].first
        accessorElement.text = "childText1"
        XCTAssertEqual(accessorElement.text, "childText1", "set text for first element of first child")

        accessorElement = sequenceAccessor.first["ChildElement1"].last
        accessorElement.text = "childText2"
        XCTAssertEqual(accessorElement.text, "childText2", "set text for last element of first child")

        XCTAssertEqual(
            try XML.document(sequenceAccessor),
            "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Element key=\"value\">newText<ChildElement1 >childText1</ChildElement1><ChildElement1 >childText2</ChildElement1></Element><Element >newText2<ChildElement2 ></ChildElement2><ChildElement2 ></ChildElement2></Element>",
            "end document has newly added texts"
        )
    }
    
    func testAttributes() {
        let accessor = XML.Accessor(singleElement())
        if !accessor.attributes.isEmpty {
            XCTAssertEqual(accessor.attributes, ["key": "value"], "access attriubtes with SingleElement Accessor")
        } else {
            XCTFail("fail")
        }
        
        let sequenceAccessor = XML.Accessor(sequence())
        if !sequenceAccessor.attributes.isEmpty {
            XCTFail("fail")
        } else {
            XCTAssert(true, "fail to attributes text with Sequence Accessor")
        }
        
        let failureAccessor = XML.Accessor(failure())
        if !failureAccessor.attributes.isEmpty {
            XCTFail("fail")
        } else {
            XCTAssert(true, "fail to access name with Failure Accessor")
        }
    }
    
    func testAll() {
        let accessor = XML.Accessor(singleElement())
        if let all = accessor.all {
            XCTAssertEqual(all.count, 1, "access all elements")
        } else {
            XCTFail("fail")
        }
        
        let sequenceAccessor = XML.Accessor(sequence())
        if let all = sequenceAccessor.all {
            XCTAssertEqual(all.count, 2, "access all elements")
        } else {
            XCTAssert(true, "fail")
        }
        
        let failureAccessor = XML.Accessor(failure())
        if let _ = failureAccessor.all {
            XCTFail("access all elements")
        } else {
            XCTAssert(true, "fail")
        }
    }
    
    func testNames() {
        let accessor = XML.Accessor(singleElement())
        if let names = accessor.names {
            XCTAssertEqual(names[0], "RootElement", "access all names")
        } else {
            XCTFail("fail")
        }
        
        let sequenceAccessor = XML.Accessor(sequence())
        if let names = sequenceAccessor.names {
            XCTAssertEqual(names, ["Element", "Element"], "access all names")
        } else {
            XCTFail("fail")
        }
        
        let failureAccessor = XML.Accessor(failure())
        if let _ = failureAccessor.names {
            XCTFail("fail")
        } else {
            XCTAssert(true, "fail to access all names")
        }
    }
    
    func testError() {
        let accessor = XML.Accessor(singleElement())
        if let _ = accessor.error {
            XCTFail("fail")
        } else {
            XCTAssert(true, "return nil from SngleElement")

        }
        
        let sequenceAccessor = XML.Accessor(sequence())
        if let _ = sequenceAccessor.error {
            XCTFail("fail")
        } else {
            XCTAssert(true, "return nil from SngleElement")
            
        }
        
        let failureAccessor = XML.Accessor(failure())
        if let _ = failureAccessor.error {
            XCTAssert(true, "return Error from SngleElement")
        } else {
            XCTFail("fail")
        }
    }
    
    func testMap() {
        let accessor = XML.Accessor(singleElement())
        let newAccessor = accessor.map { $0 }
        XCTAssertEqual(newAccessor.count, 1, "access single element with map")

        let sequenceAccessor = XML.Accessor(sequence())
        let newSequenceAccessor = sequenceAccessor.map { $0 }
        XCTAssertEqual(newSequenceAccessor.count, 2, "access each element with map")
        
        let failureAccessor = XML.Accessor(failure())
        let newFailureAccessor = failureAccessor.map { $0 }
        XCTAssertEqual(newFailureAccessor.count, 0, "access failure with map")
    }
    
    func testFlatMap() {
        let accessor = XML.Accessor(singleElement())
        let singleText = accessor.compactMap { $0.text }
        XCTAssertEqual(singleText, ["text"], "can access text")
        
        let sequenceAccessor = XML.Accessor(sequence())
        let texts = sequenceAccessor.compactMap { $0.text }
        XCTAssertEqual(texts, ["text", "text2"], "can access each text")
        
        let failureAccessor = XML.Accessor(failure())
        let failureTexts = failureAccessor.compactMap { $0.text }
        XCTAssertEqual(failureTexts, [], "has no text")
    }

    func testIgnoreNamespaces() throws {
        let accessor = XML.Accessor(singleElementWithNamespaces())
        XCTAssertEqual(accessor.text, "text", "access element text")

        var element = accessor["ChildElement"].first
        XCTAssertEqual(element.text, nil, "does not find element without ignoring namespace")

        XML.ignoreNamespaces = true

        element = accessor["ChildElement"].first
        XCTAssertEqual(element.text, "childText1", "access text for first child element ignoring namespace")

        element = accessor["ChildElement"].last
        XCTAssertEqual(element.text, "childText2", "access text for last child element ignoring namespace")

        XCTAssertEqual(accessor["ChildElement"].all?.count, 2)

        XCTAssertEqual(
            try XML.document(accessor),
            "<?xml version=\"1.0\" encoding=\"UTF-8\"?><env:RootElement key=\"value\">text<ns1:ChildElement >childText1</ns1:ChildElement><ns2:ChildElement >childText2</ns2:ChildElement></env:RootElement>",
            "end document preserves elements with namespaces"
        )
    }
    
    func testIterator() {
        let accessor = XML.Accessor(singleElement())
        var result: [XML.Accessor] = []
        for accessorElem in accessor {
            result.append(accessorElem)
        }
        XCTAssertEqual(result.count, 1, "access single element with for-in")
        
        let sequneceAccessor = XML.Accessor(sequence())
        var sequenceResult: [XML.Accessor] = []
        for accessorElem in sequneceAccessor {
            sequenceResult.append(accessorElem)
        }
        XCTAssertEqual(sequenceResult.count, 2, "access multiple element with for-in")
        
        let failureAccessor = XML.Accessor(failure())
        var failureResult: [XML.Accessor] = []
        for accessorElem in failureAccessor {
            failureResult.append(accessorElem)
        }
        XCTAssertEqual(failureResult.count, 0, "access failure element with for-in")
    }
    
    fileprivate func singleElement() -> XML.Element {
        let element = XML.Element(name: "RootElement")
        element.text = "text"
        element.attributes = ["key": "value"]
        element.childElements = [
            XML.Element(name: "ChildElement"),
            XML.Element(name: "ChildElement")
        ]
        return element
    }

    fileprivate func singleElementWithNamespaces() -> XML.Element {
        let element = XML.Element(name: "env:RootElement")
        element.text = "text"
        element.attributes = ["key": "value"]
        element.childElements = [
            XML.Element(name: "ns1:ChildElement", text: "childText1"),
            XML.Element(name: "ns2:ChildElement", text: "childText2"),
        ]
        return element
    }
    
    fileprivate func sequence() -> [XML.Element] {
        let elem1 = XML.Element(name: "Element")
        elem1.text = "text"
        elem1.attributes = ["key": "value"]
        elem1.childElements = [
            XML.Element(name: "ChildElement1"),
            XML.Element(name: "ChildElement1")
        ]
        let elem2 = XML.Element(name: "Element")
        elem2.text = "text2"
        elem2.childElements = [
            XML.Element(name: "ChildElement2"),
            XML.Element(name: "ChildElement2")
        ]
        let elements = [ elem1, elem2 ]
        return elements
    }
    
    fileprivate func failure() -> XMLError {
        return XMLError.accessError(description: "error")
    }
}
