//
//  URLQueryRepresentable.swift
//  SlimGateway
//
//  Created by Juanjo García Villaescusa on 2/9/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

protocol URLQueryRepresentable {
    var urlParamValue: String { get }
}

extension Int: URLQueryRepresentable {
    var urlParamValue: String {
        String(self)
    }
}

extension Double: URLQueryRepresentable {
    var urlParamValue: String {
        String(self)
    }
}

extension String: URLQueryRepresentable {
    var urlParamValue: String {
        self
    }
}

extension Bool: URLQueryRepresentable {
    var urlParamValue: String {
        self ? "true" : "false"
    }
}

extension Array: URLQueryRepresentable where Element: URLQueryRepresentable {
    var urlParamValue: String {
        map { $0.urlParamValue }.joined(separator: ",")
    }
}
