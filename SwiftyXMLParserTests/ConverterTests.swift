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
import SwiftyXMLParser

class ConverterTests: XCTestCase {
    func testMakeDosument() {
        // no chiled element, text only
        do {
            let element = XML.Element(name: "name",
                                      text: "text",
                                      attributes: ["key": "value"])
            let converter = XML.Converter(XML.Accessor(element))
            
            guard let result = try? converter.makeDocument() else {
                XCTFail("fail to make document")
                return
            }
            let extpected = """
        <?xml version="1.0" encoding="UTF-8"?><name key="value">text</name>
        """
            XCTAssertEqual(result, extpected)
        }
        
        // no text, chiled elements only
        do {
            let childElements = [
                XML.Element(name: "c_name1", text: "c_text1", attributes: ["c_key1": "c_value1"]),
                XML.Element(name: "c_name2", text: "c_text2", attributes: ["c_key2": "c_value2"])
            ]
            let element = XML.Element(name: "name",
                                      text: nil,
                                      attributes: ["key": "value"],
                                      childElements: childElements)
            
            let converter = XML.Converter(XML.Accessor(element))
            guard let result = try? converter.makeDocument() else {
                XCTFail("fail to make document")
                return
            }
            let extpected = """
        <?xml version="1.0" encoding="UTF-8"?><name key="value"><c_name1 c_key1="c_value1">c_text1</c_name1><c_name2 c_key2="c_value2">c_text2</c_name2></name>
        """
            XCTAssertEqual(result, extpected)
        }
        
        // both text and chiled element
        do {
            let childElements = [
                XML.Element(name: "c_name1", text: "c_text1", attributes: ["c_key1": "c_value1"]),
                XML.Element(name: "c_name2", text: "c_text2", attributes: ["c_key2": "c_value2"])
            ]
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
        <?xml version="1.0" encoding="UTF-8"?><name key="value">text<c_name1 c_key1="c_value1">c_text1</c_name1><c_name2 c_key2="c_value2">c_text2</c_name2></name>
        """
            XCTAssertEqual(result, extpected)
        }
        
        // nested child elements
        do {
            let grateGrandchildElements = [
                XML.Element(name: "ggc_name1", text: "ggc_text1", attributes: ["ggc_key1": "ggc_value1"])
            ]
            
            let grandchildElements = [
                XML.Element(name: "gc_name1", text: "gc_text1", attributes: ["gc_key1": "gc_value1"], childElements: grateGrandchildElements)
            ]
            
            let childElements = [
                XML.Element(name: "c_name1", text: "c_text1", attributes: ["c_key1": "c_value1"]),
                XML.Element(name: "c_name2", text: "c_text2", attributes: ["c_key2": "c_value2"], childElements: grandchildElements)
            ]
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
        <?xml version="1.0" encoding="UTF-8"?><name key="value">text<c_name1 c_key1="c_value1">c_text1</c_name1><c_name2 c_key2="c_value2">c_text2<gc_name1 gc_key1="gc_value1">gc_text1<ggc_name1 ggc_key1="ggc_value1">ggc_text1</ggc_name1></gc_name1></c_name2></name>
        """
            XCTAssertEqual(result, extpected)
        }
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
