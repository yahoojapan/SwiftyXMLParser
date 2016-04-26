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

import Foundation

extension XML {
    class Parser: NSObject, NSXMLParserDelegate {
        func parse(data: NSData) -> Accessor {
            stack = [Element]()
            stack.append(documentRoot)
            let parser = NSXMLParser(data: data)
            parser.delegate = self
            parser.parse()
            return Accessor(documentRoot)
        }
        
        override init() {
            trimmingManner = nil
        }
        
        init(trimming manner: NSCharacterSet) {
            trimmingManner = manner
        }
        
        // MARK:- private
        private var documentRoot = Element(name: "XML.Parser.AbstructedDocumentRoot")
        private var stack = [Element]()
        private let trimmingManner: NSCharacterSet?
        
        func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
            let node = Element(name: elementName)
            if !attributeDict.isEmpty {
                node.attributes = attributeDict
            }
            
            let parentNode = stack.last
            
            node.parentElement = parentNode
            parentNode?.childElements.append(node)
            stack.append(node)
        }
        
        func parser(parser: NSXMLParser, foundCharacters string: String) {
            if let text = stack.last?.text {
                stack.last?.text = text + (string ?? "")
            } else {
                stack.last?.text = "" + (string ?? "")
            }
        }
        
        func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
            if let trimmingManner = self.trimmingManner {
                stack.last?.text = stack.last?.text?.stringByTrimmingCharactersInSet(trimmingManner)
            }
            stack.removeLast()
        }
    }
}