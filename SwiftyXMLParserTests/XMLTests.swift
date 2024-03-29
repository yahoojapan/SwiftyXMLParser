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

class XMLTests: XCTestCase {
    fileprivate let packageRootPath = URL(fileURLWithPath: #file)
        .pathComponents
        .dropLast()
        .joined(separator: "/")
        .dropFirst()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    private func getPath(_ name: String) -> String {
        "\(packageRootPath)/\(name)"
    }

    func testParse() {
        if let data = try? Data(contentsOf: URL(fileURLWithPath: getPath("XMLDocument.xml"))) {
            let xml = XML.parse(data)
            if  let _ = xml["ResultSet"].error {
                XCTFail("fail to parse")

            } else {
                XCTAssert(true, "sucess to Parse")
            }
        } else {
            XCTFail("fail to generate data")
        }
    }

    func testParseWithArguments() {
        if let data = try? Data(contentsOf: URL(fileURLWithPath: getPath("XMLDocument.xml"))) {
            let xml = XML.parse(data, trimming: .whitespacesAndNewlines, ignoreNamespaces: true)
            if  let _ = xml["ResultSet"].error {
                XCTFail("fail to parse")

            } else {
                XCTAssert(true, "sucess to Parse")
            }
        } else {
            XCTFail("fail to generate data")
        }
    }
    
    func testSuccessParseFromString() {
        if let string = try? String(contentsOfFile: getPath("XMLDocument.xml"), encoding: String.Encoding.utf8),
            let xml = try? XML.parse(string) {
            if  let _ = xml["ResultSet"].error {
                XCTFail("fail to parse")
            } else {
                XCTAssert(true, "success to parse")
            }
        } else {
            XCTFail("fail to parse")
        }
    }
    
    func testSuccessParseFromDoublebyteSpace() {
        guard let xml = try? XML.parse("<Name>　</Name>") else {
            XCTFail("Fail Parse")
            return
        }
        
        if  let name = xml["Name"].text {
            XCTAssertEqual(name, "　", "Parse Success Double-byte Space")
        } else {
            XCTFail("Fail Parse")
        }
    }
}
