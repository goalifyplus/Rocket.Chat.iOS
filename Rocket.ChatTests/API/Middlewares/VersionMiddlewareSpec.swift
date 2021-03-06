//
//  VersionMiddlewareSpec.swift
//  Rocket.ChatTests
//
//  Created by Matheus Cardoso on 11/28/17.
//  Copyright © 2017 Rocket.Chat. All rights reserved.
//

import XCTest

@testable import Rocket_Chat

class VersionMiddlewareSpec: XCTestCase {
    class TestRequest: APIRequest {
        let path = "/test"
        var requiredVersion = Version(0, 60, 0)
    }

    func testHandleRequest() {
        let available = Version(0, 60, 0)
        let required = Version(0, 61, 0)

        let api: API! = API(host: "https://demo.goalify.chat", version: available)
        let middleware = VersionMiddleware(api: api)

        var request = TestRequest()
        request.requiredVersion = required

        guard
            let error = middleware.handle(&request),
            case let .version(versionAvailable, versionRequired) = error
        else {
            return XCTFail("should return APIError.version")
        }

        XCTAssertEqual(versionAvailable, available)
        XCTAssertEqual(versionRequired, required)

        request.requiredVersion = .zero

        XCTAssertNil(middleware.handle(&request))
    }
}
