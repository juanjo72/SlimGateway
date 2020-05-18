//
//  URLQueryRepresentable.swift
//  SlimGateway
//
//  Created by Juanjo García Villaescusa on 2/9/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

public protocol URLQueryRepresentable {
    var urlParamValue: String { get }
}

extension Int: URLQueryRepresentable {
    public var urlParamValue: String {
        String(self)
    }
}

extension Double: URLQueryRepresentable {
    public var urlParamValue: String {
        String(self)
    }
}

extension String: URLQueryRepresentable {
    public var urlParamValue: String {
        self
    }
}

extension Bool: URLQueryRepresentable {
    public var urlParamValue: String {
        self ? "true" : "false"
    }
}
