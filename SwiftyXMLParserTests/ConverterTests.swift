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

class ConverterTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }
    
    func testMakeDosument() {
        let childElements = [XML.Element(name: "child_name",
                                         text: "child_text",
                                         attributes: ["child_key": "child_value"])]
        let element = XML.Element(name: "name",
                                  text: "text",
                                  attributes: ["key": "value"],
                                  childElements: childElements)
        let converter = XML.Converter(XML.Accessor(element))
        guard let result = try? converter.makeDocument() else {
            XCTFail("fail to make document")
            return
        }
        let extpected = """
        <name key="value">
            text
            <child_name child_key="child_value">
                child_text
            </child_name>
        </name>
        """
        XCTAssertEqual(result, extpected)
    }
}

extension XML.Element {
    convenience init(name: String,
                     text: String? = nil,
                     attributes: [String: String] = [String: String](),
                     childElements: [XML.Element] = [XML.Element]()) {
        self.init(name: name)
        self.text = text
        self.attributes = attributes
        self.childElements = childElements
    }
}
