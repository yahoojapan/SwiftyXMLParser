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

/// available Type in XML.Accessor subscript
public protocol XMLSubscriptType {}
extension Int: XMLSubscriptType {}
extension String: XMLSubscriptType {}

infix operator ?= // Failable Assignment

/**
 assign value if rhs is not optonal. When rhs is optional, nothing to do.
*/
public func ?=<T>(lhs: inout T, rhs: T?) {
    if let unwrappedRhs = rhs {
        lhs = unwrappedRhs
    }
}

infix operator ?<< // Failable Push

/**
 push value to array if rhs is not optonal. When rhs is optional, nothing to do.
*/
public func ?<< <T>(lhs: inout [T], rhs: T?) {
    if let unwrappedRhs = rhs {
        lhs.append(unwrappedRhs)
    }
}


/**
 Director class to parse and access XML document. 
 
 You can parse XML docuemnts with parse() method and get the accessor.
 
 ### Example
 ```
    let string = "<ResultSet><Result><Hit index="1"><Name>ほげ</Name></Hit><Hit index="2"><Name>ふが</Name></Hit></Result></ResultSet>"
    xml = XML.parse(string)
    let text = xml["ResultSet"]["Result"]["Hit"][0]["Name"].text {
        println("exsists path & text")
    }

    let text = xml["ResultSet", "Result", "Hit", 0, "Name"].text {
        println("exsists path & text")
    }

    let attributes = xml["ResultSet", "Result", "Hit", 0, "Name"].attributes {
        println("exsists path & attributes")
    }

    for hit in xml["ResultSet", "Result", "Hit"] {
        println("enumarate existing element")
    }

    switch xml["ResultSet", "Result", "TypoKey"] {
    case .Failure(let error):
        println(error)
    case .SingleElement(_), .Sequence(_):
        println("success parse")
    }
 ```
*/
open class XML {

    /**
    Interface to parse InputStream
    
    - parameter strea:InputStream for an XML document
    - returns:Accessor object to access XML document
    */
    open class func parse(_ stream: InputStream) -> Accessor {
        return Parser().parse(stream)
    }
    
    
    /**
    Interface to parse NSData
    
    - parameter data:NSData XML document
    - returns:Accessor object to access XML document
    */
    open class func parse(_ data: Data) -> Accessor {
        return Parser().parse(data)
    }
    
    /**
     Interface to parse String
     
     - parameter data:Data XML document
     - parameter manner:CharacterSet If you want to trim text (default off)
     - parameter ignoreNamespaces:Bool If set to true all accessors will ignore the first part of an element name up to a semicolon (default false)
     - returns:Accessor object to access XML document
     */
    open class func parse(_ data: Data, trimming manner: CharacterSet? = nil, ignoreNamespaces: Bool = false) -> Accessor {
        return Parser(trimming: manner, ignoreNamespaces: ignoreNamespaces).parse(data)
    }
    
    /**
     Interface to parse String
     
     - parameter str:String XML document
     - parameter manner:CharacterSet If you want to trim text (default off)
     - parameter ignoreNamespaces:Bool If set to true all accessors will ignore the first part of an element name up to a semicolon (default false)
     - returns:Accessor object to access XML document
     */
    open class func parse(_ str: String, trimming manner: CharacterSet? = nil, ignoreNamespaces: Bool = false) throws -> Accessor {
        guard let data = str.data(using: String.Encoding.utf8) else {
            throw XMLError.failToEncodeString
        }
        
        return Parser(trimming: manner, ignoreNamespaces: ignoreNamespaces).parse(data)
    }

    /**
     Convert accessor back to XML document string.

     - parameter accessor:XML accessor
     - parameter withDeclaration:Prefix with standard XML declaration (default true)
     - returns:XML document string
     */
    open class func document(_ accessor: Accessor, withDeclaration: Bool = true) throws -> String {
        return try Converter(accessor).makeDocument(withDeclaration: withDeclaration)
    }
}
