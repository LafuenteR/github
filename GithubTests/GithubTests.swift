//
//  GithubTests.swift
//  GithubTests
//
//  Created by Ruel Lafuente on 10/2/21.
//

import XCTest
@testable import Github

class GithubTests: XCTestCase {
    
    func testIsDivisibleByFour() {
        let number = 4
        let isnumberDivisbleByFour = number.divisibleByFour()
        XCTAssertTrue(isnumberDivisbleByFour)
    }

}
