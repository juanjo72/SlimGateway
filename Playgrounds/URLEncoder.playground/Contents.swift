import SlimGateway

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

let source = URL(string: "https://jsonplaceholder.typicode.com/albums")!
let resource = URLResource<[Album]>(url: source) { serverResponse in
    guard let json = serverResponse as? [JSONDictionary] else { return nil }
    return json.compactMap(Album.init)
}

let gateway = SlimGateway()
gateway.request(urlResource: resource) { result in
    switch result {
    case .success(let albums):
        print(albums.count)
    case .failure:
        print("some error")
    }
}
