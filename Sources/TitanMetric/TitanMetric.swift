import RedShot
import TitanKituraAdapter

public func metricLogger(redis: Redis, service: String, channel: String) -> MetricHandler {
    let fn = { (metric:HTTPMetric) -> Void in
        _ = try? redis.publish(channel: channel,
                               message: "{\"time\":\(metric.startAt),\"service\":\"\(service)\",\"remote\":\"\(metric.requestRemoteAddress)\",\"method\":\"\(metric.requestMethod)\",\"url\":\"\(metric.requestUrl)\",\"status\":\(metric.responseStatusCode),\"duration\":\(metric.duration)}")
    }

    return fn
}
