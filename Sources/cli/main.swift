#!/usr/bin/env swift

import Foundation

let args = CommandLine.arguments

func usage() -> Never {
    print("Usage: pomodoro <start|pause|toggle|reset> [minutes]")
    exit(1)
}

guard args.count >= 2 else { usage() }

let command = args[1].lowercased()
var userInfo: [String: Any] = ["action": command]

if command == "start" || command == "reset" {
    if args.count >= 3, let minutes = Int(args[2]) {
        userInfo["minutes"] = minutes
    } else {
        // default to 25 minutes if not provided
        userInfo["minutes"] = 25
    }
}

let center = DistributedNotificationCenter.default()
center.post(name: Notification.Name("com.pomoglass.command"), object: nil, userInfo: userInfo)

print("Sent command: \(userInfo)")
