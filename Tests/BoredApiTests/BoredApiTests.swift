import XCTest
@testable import BoredApi

final class BoredApiTests: XCTestCase {
    let api = BoredApi()

    func testLoadRandomActivity() async throws {
        let activtiy = try await api.loadActivity()

        XCTAssert(activtiy.accessibility >= 0)
        XCTAssert(activtiy.accessibility <= 1)
        XCTAssert(activtiy.activity.count > 1)
    }

    // only the price param is extensively tested, this can be extended to further params

    func testLoadInvalidParam_price() async throws {
        do {
            let _ = try await api.loadActivity(price: -1)
            XCTFail("Error should be throws")
        }
        catch {
            if case BoredApi.ApiError.noActivityFound = error {
                XCTAssertTrue(true, "ApiError successfully parsed")
            }
            else {
                XCTFail("noActivityFound should have been thrown")
            }
        }
    }

    func testLoadInvalidParam_price_exact() async throws {
        do {
            let _ = try await api.loadActivity(price: .exact(value: -1))
            XCTFail("Error should be throws")
        }
        catch {
            if case BoredApi.ApiError.noActivityFound = error {
                XCTAssertTrue(true, "ApiError successfully parsed")
            }
            else {
                XCTFail("noActivityFound should have been thrown")
            }
        }
    }

    func testLoadInvalidParam_price_range() async throws {
        do {
            let _ = try await api.loadActivity(price: .range(min: -2, max: -1))
            XCTFail("Error should be throws")
        }
        catch {
            if case BoredApi.ApiError.noActivityFound = error {
                XCTAssertTrue(true, "ApiError successfully parsed")
            }
            else {
                XCTFail("noActivityFound should have been thrown")
            }
        }
    }

    func testLoadValidParam_price() async throws {
        let activtiy = try await api.loadActivity(price: 0.5)
        XCTAssertEqual(activtiy.price, 0.5)
    }

    func testLoadValidParam_price_exact() async throws {
        let activtiy = try await api.loadActivity(price: .exact(value: 0.5))
        XCTAssertEqual(activtiy.price, 0.5)
    }

    func testLoadValidParam_price_range() async throws {
        let activtiy = try await api.loadActivity(price: .range(min: 0.4, max: 0.6))
        XCTAssertGreaterThanOrEqual(activtiy.price, 0.4)
        XCTAssertLessThanOrEqual(activtiy.price, 0.6)
    }
}
