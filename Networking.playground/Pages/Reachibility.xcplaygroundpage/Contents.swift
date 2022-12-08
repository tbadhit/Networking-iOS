import UIKit
import SystemConfiguration

func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
    let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
    return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
}

let reachability = SCNetworkReachabilityCreateWithName(nil, "www.dicoding.com")
var flags = SCNetworkReachabilityFlags()
SCNetworkReachabilityGetFlags(reachability!, &flags)

if !isNetworkReachable(with: flags) {
    print("Device doesn't have internet connection")
} else {
    print("Host www.dicoding.com is reachable")
}

#if os(iOS)
if flags.contains(.isWWAN) {
    print("Device is using mobile data")
}
#endif
