import Foundation


public class BoredApi {

    private let apiURL: URL
    private let urlSession: URLSession

    public init() {
        apiURL  = URL(string: "https://www.boredapi.com/api/")!
        urlSession = URLSession(configuration: .default)
    }

    private enum Endpoint: String {
        case activity
    }

    private func buildRequest(method: URLRequest.HttpMethod, endpoint: Endpoint, parameters: [URLQueryItem]) throws -> URLRequest {
        var urlComponents = URLComponents(string: apiURL.appending(path: endpoint.rawValue).absoluteString)
        urlComponents?.queryItems = parameters
        guard let url = urlComponents?.url else {
            throw ApiError.failedToConstructUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod(method)
        return request
    }
}

extension BoredApi {

    /// default implementation of the API
    public func loadActivity(key: String? = nil, type: ActivityType? = nil, participants: Int? = nil, price: Double? = nil, minprice: Double? = nil, maxprice: Double? = nil, accessibility: Int? = nil, minaccessibility: Int? = nil, maxaccessibility: Int? = nil) async throws -> Activity {
        var params: [URLQueryItem] = []
        if let key {
            params.append(URLQueryItem(name: "key", value: key))
        }
        if let type = type?.rawValue {
            params.append(URLQueryItem(name: "type", value: type))
        }
        if let participants = participants.map(String.init) {
            params.append(URLQueryItem(name: "participants", value: participants))
        }
        if let price {
            params.append(URLQueryItem(name: "price", value: String(price)))
        }
        if let minprice {
            params.append(URLQueryItem(name: "minprice", value: String(minprice)))
        }
        if let maxprice {
            params.append(URLQueryItem(name: "maxprice", value: String(maxprice)))
        }
        if let minaccessibility = minaccessibility.map(String.init) {
            params.append(URLQueryItem(name: "minaccessibility", value: minaccessibility))
        }
        if let maxaccessibility = maxaccessibility.map(String.init) {
            params.append(URLQueryItem(name: "maxaccessibility", value: maxaccessibility))
        }
        if let accessibility = accessibility.map(String.init) {
            params.append(URLQueryItem(name: "accessibility", value: accessibility))
        }
        let activityRequest = try buildRequest(method: .GET, endpoint: .activity, parameters: params)
        return try await requestActivity(request: activityRequest)
    }

    /// improved implementation of the API, which makes range and exact mutually exclusive
    public func loadActivity(key: String? = nil, type: ActivityType? = nil, participants: Int? = nil, price: ExactOrRange<Double>? = nil, accessibility: ExactOrRange<Int>? = nil) async throws -> Activity {
        var params: [URLQueryItem] = []
        if let key {
            params.append(URLQueryItem(name: "key", value: key))
        }
        if let type = type?.rawValue {
            params.append(URLQueryItem(name: "type", value: type))
        }
        if let participants = participants.map(String.init) {
            params.append(URLQueryItem(name: "participants", value: participants))
        }
        if let price {
            params.append(contentsOf: price.params(name: "price"))
        }
        if let accessibility {
            params.append(contentsOf: accessibility.params(name: "accessibility"))
        }
        let activityRequest = try buildRequest(method: .GET, endpoint: .activity, parameters: params)
        return try await requestActivity(request: activityRequest)
    }

    private func requestActivity(request: URLRequest) async throws -> Activity {
        let (data, response) = try await urlSession.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiError.internalServerError
        }
        guard httpResponse.statusCode == 200 else {
            throw ApiError.statusCode(httpResponse.statusCode)
        }
        do {
            return try JSONDecoder().decode(Activity.self, from: data)
        } catch {
            if let _ = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                throw ApiError.noActivityFound
            }
            else {
                throw ApiError.decodingError(error)
            }
        }
    }
}
