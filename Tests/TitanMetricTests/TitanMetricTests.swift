import XCTest
@testable import TitanMetric
import TitanKituraAdapter
import Titan
import KituraNet

class TitanMetricTests: XCTestCase {

    var server: HTTPServer!
    let port: Int = 12345

    override func tearDown() {
        server.stop()
        server = nil
    }

    func testLogger() {

        let titan = Titan()
        titan.addFunction(metricHeader)
        titan.get("/testrequest") { (req, res) -> (RequestType, ResponseType) in
            for header in req.headers {
                print(header.name + " : " + header.value)
            }

            for header in res.headers {
                print(header.name + " : " + header.value)
            }

            return (req, res)
        }

        titan.addFunction(metricHeader)

        guard let url = URL(string: "https://localhost:9200") else {
            XCTFail("Wrong format")
            return
        }

        do {
            let metricLogger = try MetricLogger(elasticHosts: [url], username: "user", password: "password")

            // Configure Kitura server
            let serverStartedExpectation = expectation(description: "Server started")
            let kituraServerDelegate = TitanServerDelegate(titan.app, defaultResponse: Response(code: 404, body: nil),
                                                           metrics: metricLogger.logger())
            server = HTTP.createServer().started {
                serverStartedExpectation.fulfill()
            }

            do {
                try server.listen(on: port)
            } catch {
                XCTFail("Can't listen")
            }

            // Configure Titan integration
            server.delegate = kituraServerDelegate

            // Make the request
            let requestExpectation = expectation(description: "request started")

            let session = URLSession(configuration: .default)
            guard let url = URL(string: "http://localhost:\(port)/testrequest") else {
                XCTFail("Can't create URL")
                return
            }
            let r = URLRequest(url: url)

            session.dataTask(with: r, completionHandler: { (_, response, error) in
                print(error)
                let res = response as? HTTPURLResponse
                print(res?.allHeaderFields)
                XCTAssertNotNil(res?.allHeaderFields["X-B3-TraceId".lowercased()])

                requestExpectation.fulfill()
            }).resume()

            wait(for: [serverStartedExpectation, requestExpectation], timeout: 20)

        } catch {
            XCTFail(error.localizedDescription)
        }

    }

    static var allTests = [
        ("testLogger", testLogger)
    ]
}
