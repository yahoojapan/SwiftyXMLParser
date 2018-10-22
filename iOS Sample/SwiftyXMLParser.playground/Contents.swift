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

import SwiftyXMLParser

let str = """
<ResultSet>
    <Result>
        <Hit index=\"1\">
            <Name>Item1</Name>
        </Hit>
        <Hit index=\"2\">
            <Name>Item2</Name>
        </Hit>
    </Result>
</ResultSet>
"""

// parse xml document
let xml = try! XML.parse(str)

// access xml element
let accessor = xml["ResultSet"]

// access XML Text

if let text = xml["ResultSet", "Result", "Hit", 0, "Name"].text {
    print(text)
}

let texts = xml["ResultSet", "Result", "Hit"].compactMap({ $0.Name.text })
print(texts)

if let text = xml.ResultSet.Result.Hit[0].Name.text {
    print(text)
}

// access XML Attribute
if let index = xml["ResultSet", "Result", "Hit"].attributes["index"] {
    print(index)
}

// enumerate child Elements in the parent Element
for hit in xml["ResultSet", "Result", "Hit"] {
    print(hit)
}

// check if the XML path is wrong
if case .failure(let error) =  xml["ResultSet", "Result", "TypoKey"] {
    print(error)
}
