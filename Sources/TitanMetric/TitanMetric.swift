import Foundation
import TitanCore
import TitanKituraAdapter
import SwiftyBeaver

enum MetricError: Error {
    case credentialSerialization
}

public class MetricLogger {

    private let session = URLSession(configuration: .default)
    private let hosts: [URL]
    private let credentials: String
    private let log: SwiftyBeaver.Type?

    /// Creates a new MetricLogger, which is sending metric to an ElasticSearch host by using the Elasticsearch HTTP API.
    /// - Parameters:
    ///   - elasticHost: An array of `URL` of Elasticsearch nodes to connect to.
    ///   - username: The basic authentication username for connecting to Elasticsearch.
    ///   - password: The basic authentication password for connecting to Elasticsearch.
    ///   - log: A SwiftyBeaver instance to get some cool logs ;-).
    public init(elasticHosts: [URL], username: String, password: String, log: SwiftyBeaver.Type? = nil) throws {
        self.hosts = elasticHosts
        let login = String(format: "%@:%@", username, password)
        guard let credentials = login.data(using: .utf8)?.base64EncodedString() else {
            throw MetricError.credentialSerialization
        }
        self.credentials = credentials
        self.log = log
    }

    /// The function to pass to the `TitanKituraAdapter`
    ///
    /// ```swift
    /// let metricLogger = try MetricLogger(elasticHosts: [url], username: "", password: "")
    /// TitanKituraAdapter.serve(titan.app, on: 1234,  defaultResponse: Response(code: 404, body: nil), metrics: metricLogger.logger())
    /// ```
    public func logger() -> MetricHandler {

        let fn = { (metric: HTTPMetric) -> Void in

            guard let url = self.hosts.first else { return }

            var request = URLRequest(url: url.appendingPathComponent("/titantrace/trace"))
            request.httpMethod = "POST"
            request.addValue("Basic \(self.credentials)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

            do {
                request.httpBody = try JSONEncoder().encode(metric)

                self.session.dataTask(with: request, completionHandler: { (_, _, error) in
                    if let error = error {
                        self.log?.error(error)
                    }
                }).resume()
            } catch {
                self.log?.error(error)
            }
        }

        return fn
    }
}

public func metricHeader(req: RequestType, res: ResponseType) -> (RequestType, ResponseType) {
    var res = res.copy()
    if let traceId = req.headers["X-B3-TraceId"] {
        res.headers["X-B3-TraceId"] = traceId
    } else {
        res.headers["X-B3-TraceId"] = UUID().uuidString
    }

    return (req, res)
}
