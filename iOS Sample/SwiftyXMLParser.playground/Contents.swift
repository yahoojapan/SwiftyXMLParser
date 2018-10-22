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
