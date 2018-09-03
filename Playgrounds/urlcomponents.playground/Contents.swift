import UIKit
import SlimGateway
import PlaygroundSupport

var str = "Hello, playground"

let url = URL.init(string: "http://https://swapi.co/api/people/1?search=luke")!

var components = URLComponents.init(url: url, resolvingAgainstBaseURL: false)!

components.host
components.path




let test: [String: CustomStringConvertible] = ["name": "Andrés", "age": 47]
let elements = test.map { element in
    URLQueryItem.init(name: element.key, value: element.value.description)
}

components.queryItems = components.queryItems! + elements
components.url
components.percentEncodedQuery



var params = [String: URLQueryRepresentable]()
params["name"] = "juan"
params["age"] = 44

let resource: URLResource<String> = URLResource(url: url, httpMethod: .get, parameters: params, timeOut: .shortTimeOut) { response in
    return "Hello world"
}

let gateway = SlimGateway()
gateway.request(urlResource: resource) { result in
    print(result.value ?? "")
}

PlaygroundPage.current.needsIndefiniteExecution = true
