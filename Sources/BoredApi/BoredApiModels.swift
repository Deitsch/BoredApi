//
//  File.swift
//  
//
//  Created by Simon Deutsch on 06.05.24.
//

import Foundation

extension BoredApi {

    /// Type of Activity returned by BoredApi
    public enum ActivityType: String, Codable, CaseIterable {
        case education, recreational, social, diy, charity, cooking, relaxation, music, busywork
    }

    /// Errors BoredApi can throw
    public enum ApiError: Error {
        case internalServerError
        case statusCode(Int)
        case decodingError(Error)
        case failedToConstructUrl
        case noActivityFound
    }

    struct ErrorModel: Codable {
        let error: String
    }

    public struct Activity: Codable {

        /// Description of the queried activity
        public let activity: String

        /// A factor describing how possible an event is to do with zero being the most accessible
        ///
        /// range [0.0, 1.0]
        public let accessibility: Double

        /// Type of the activity
        public let type: ActivityType

        /// The number of people that this activity could involve
        ///
        /// range [0, n]
        public let participants: Int

        /// A factor describing the cost of the event with zero being free
        ///
        /// range [0, 1]
        public let price: Double

        /// A link where to find more about the activity
        public let link: String

        /// A unique numeric id
        ///
        /// range [1000000, 9999999]
        public let key: Int

        private enum CodingKeys: String, CodingKey {
            case activity
            case accessibility
            case participants
            case type
            case price
            case link
            case key
        }

        public init(from decoder: Decoder) throws {
            let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
            activity = try rootContainer.decode(String.self, forKey: .activity)
            accessibility = try rootContainer.decode(Double.self, forKey: .accessibility)
            let typeRaw = try rootContainer.decode(String.self, forKey: .type)
            type = ActivityType(rawValue: typeRaw) ?? .busywork
            participants = try rootContainer.decode(Int.self, forKey: .participants)
            price = try rootContainer.decode(Double.self, forKey: .price)
            link = try rootContainer.decode(String.self, forKey: .link)
            let keyString = try rootContainer.decode(String.self, forKey: .key)
            key = Int(keyString) ?? 0
        }

        public init(activity: String, accessibility: Double, type: ActivityType, participants: Int, price: Double, link: String, key: Int) {
            self.activity = activity
            self.accessibility = accessibility
            self.type = type
            self.participants = participants
            self.price = price
            self.link = link
            self.key = key
        }
    }

    public enum ExactOrRange<T: LosslessStringConvertible>: Equatable where T: Equatable {
        /// Set exact value to match
        case exact(value: T?)
        /// Set min or max boundary nil if not needed
        case range(min: T?, max: T?)

        func params(name: String) -> [URLQueryItem] {
            switch self {
            case .exact(let value):
                var params: [URLQueryItem] = []
                if let value {
                    params.append(URLQueryItem(name: name, value: String(value)))
                }
                return params
            case .range(let min, let max):
                var params: [URLQueryItem] = []
                if let min {
                    params.append(URLQueryItem(name: "min" + name, value: String(min)))
                }
                if let max {
                    params.append(URLQueryItem(name: "max" + name, value: String(max)))
                }
                return params
            }
        }

        public static func == (lhs: BoredApi.ExactOrRange<T>, rhs: BoredApi.ExactOrRange<T>) -> Bool {
            switch (lhs, rhs) {
            case (.exact(let vall), .exact(let valr)): vall == valr
            case (.range(let minl, let maxl), .range(let minr, let maxr)): minl == minr && maxl == maxr
            default: false
            }
        }

    }
}
