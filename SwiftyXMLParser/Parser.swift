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
#if canImport(FoundationXML)
    import FoundationXML
#endif

extension XML {
    class Parser: NSObject, XMLParserDelegate {
        /// If it has value, Parser is interuppted by error. (e.g. using invalid character)
        /// So the result of parsing is missing.
        /// See https://developer.apple.com/documentation/foundation/xmlparser/errorcode
        private(set) var error: XMLError?

        func parse(_ data: Data) -> Accessor {
            stack = [Element]()
            stack.append(documentRoot)
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
            if let error = error {
                return Accessor(error)
            } else {
                return Accessor(documentRoot)
            }
        }

        init(trimming manner: CharacterSet? = nil, ignoreNamespaces: Bool = false) {
            self.trimmingManner = manner
            self.ignoreNamespaces = ignoreNamespaces
            self.documentRoot = Element(name: "XML.Parser.AbstructedDocumentRoot", ignoreNamespaces: ignoreNamespaces)
        }
        
        // MARK:- private
        fileprivate var documentRoot: Element
        fileprivate var stack = [Element]()
        fileprivate let trimmingManner: CharacterSet?
        fileprivate let ignoreNamespaces: Bool
        
        func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
            let node = Element(name: elementName, ignoreNamespaces: ignoreNamespaces)
            node.lineNumberStart = parser.lineNumber
            if !attributeDict.isEmpty {
                node.attributes = attributeDict
            }
            
            let parentNode = stack.last
            
            node.parentElement = parentNode
            parentNode?.childElements.append(node)
            stack.append(node)
        }
        
        func parser(_ parser: XMLParser, foundCharacters string: String) {
            if let text = stack.last?.text {
                stack.last?.text = text + string
            } else {
                stack.last?.text = "" + string
            }
        }

        func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
            stack.last?.CDATA = CDATABlock
        }
        
        func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
            stack.last?.lineNumberEnd = parser.lineNumber
            if let trimmingManner = self.trimmingManner {
                stack.last?.text = stack.last?.text?.trimmingCharacters(in: trimmingManner)
            }
            stack.removeLast()
        }
        
        func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
            error = .interruptedParseError(rawError: parseError)
        }
    }
}
