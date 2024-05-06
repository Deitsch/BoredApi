import XCTest
@testable import BoredApi

final class BoredApiTests: XCTestCase {
    let api = BoredApi()

    func testLoadRandomActivity() async throws {
        let activtiy = try await api.loadActivity()

        XCTAssert(activtiy.accessibility >= 0)
        XCTAssert(activtiy.accessibility <= 1)
    }
}
