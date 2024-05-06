//
//  File.swift
//  
//
//  Created by Simon Deutsch on 06.05.24.
//

import Foundation

extension URLRequest {
    enum HttpMethod: String {
        case GET
        case POST
        case PUT
        case PATCH
        case DELETE
    }

    mutating func httpMethod(_ method: HttpMethod) {
        httpMethod = method.rawValue
    }
}
