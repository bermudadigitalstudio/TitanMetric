# TitanMetric

Log HTTP request metric into a ElasticSearch.

## Getting started

TitanMetric depends on [TitanKituraAdapter](https://github.com/bermudadigitalstudio/TitanKituraAdapter).


Add this in your Package.swift :


`.package(url: "https://github.com/bermudadigitalstudio/TitanMetric.git", .upToNextMajor(from:"0.0.0"))`


```swift
import Titan
import TitanKituraAdapter
import TitanMetric


let redis = try Redis(hostname:"redis",port:6379) 

let titanApp = Titan()

titanApp.get("/") {
  return "Hello world"
}

do {

    let metricLogger = try MetricLogger(elasticHosts: [url], username: "", password: "")
     TitanKituraAdapter.serve(titan.app, on: 1234,  defaultResponse: Response(code: 404, body: nil), metrics: metricLogger.logger())

} catch {

}

```