# TitanMetric

Log HTTP request metric into a Redis Channel.

## Getting started

TitanMetric depends on [Redshot](https://github.com/bermudadigitalstudio/Redshot) and [TitanKituraAdapter](https://github.com/bermudadigitalstudio/TitanKituraAdapter).


Add this in your Package.swift :

`.Package(url: "https://github.com/bermudadigitalstudio/TitanMetric.git", majorVersion: 0)`

or for Swift 4

`.package(url: "https://github.com/bermudadigitalstudio/TitanMetric.git", .upToNextMajor(from:"0.0.0"))`


```swift
import Titan
import TitanKituraAdapter
import TitanMetric

let titanApp = Titan()

titanApp.get("/") {
  return "Hello world"
}


TitanKituraAdapter.serve(titanApp.app, on: 8000, metrics: metricLogger(redis: redis, service: "myservicename",channel:"mychannel.tolog"))
```

## Get the metrics

`redis-cli SUBSCRIBE mychannel.tolog`