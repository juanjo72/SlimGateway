# SlimGateway

SlimGateway is a network layer to include in your projects so you can access your RESTFUL resources in a simple and elegant way.

## Instalation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager which automates and simplifies the process of using 3rd-party libraries like `SlimGateway` in your projects. 

First, add the following line to your [Podfile](http://guides.cocoapods.org/using/using-cocoapods.html):

```ruby
pod 'SlimGateway'
```

Then, run the following line for integrating it into your project.

```ruby
pod install
```

## Usage

### Basic GET Request

Import the framework:

```swift
import SlimGateway
```

Define your entity and create a failable initializer to process a json dictionary:

```swift
struct Album {
    let id: Int
    let title: String
}

extension Album {
    init?(json: JSONDictionary) {
        guard let id = json["id"] as? Int,
            let title = json["title"] as? String else { return nil }
        self.id = id
        self.title = title
    }
}
```

Create the URLResource that includes the mapping closure:

```swift
let source = URL(string: "https://jsonplaceholder.typicode.com/albums")!
let resource = URLResource<[Album]>(url: source) { serverResponse in
    guard let json = serverResponse as? [JSONDictionary] else { return nil }
    return json.compactMap(Album.init)
}
```

Now we are ready to make the call using SlimGateway:

```swift
let gateway = SlimGateway()
gateway.request(urlResource: resource) { result in
    switch result {
    case .success(let albums):
        print(albums.count)
    case .failure:
        print("some error")
    }
}
```

### POST Request

To create a new album we set up a resource as the following:

```swift
let url = URL(string: "https://jsonplaceholder.typicode.com/albums")!
var newAlbum = Parameters()
newAlbum["userId"] = 1
newAlbum["title"] = "foo"
let newAlbumResource = URLResource<Album>(url: url, httpMethod: .post, parameters: newAlbum) { result in
    guard let json = result as? JSONDictionary else { return nil }
    return Album(json: json)
}
let gateway = SlimGateway()
gateway.request(urlResource: resource) { result in
    switch result {
    case .success(let album):
        print(album.id)
    case .failure:
        print("some error")
    }
}
```


## License

`SlimGateway` is distributed under the terms and conditions of the [MIT license](LICENSE.md).