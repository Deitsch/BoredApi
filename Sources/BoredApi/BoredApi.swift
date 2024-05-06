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

    private func buildRequest(method: URLRequest.HttpMethod, endpoint: Endpoint) -> URLRequest {
        var request = URLRequest(url: apiURL.appending(path: endpoint.rawValue))
        request.httpMethod(method)
        return request
    }
}

extension BoredApi {
    public func loadActivity() async throws -> Activity {
        let activityRequest = buildRequest(method: .GET, endpoint: .activity)

        let (data, response) = try await urlSession.data(for: activityRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiError.internalServerError
        }
        guard httpResponse.statusCode == 200 else {
            throw ApiError.statusCode(httpResponse.statusCode)
        }
        do {
            return try JSONDecoder().decode(Activity.self, from: data)
        } catch {
            throw ApiError.decodingError(error)
        }
    }
}
