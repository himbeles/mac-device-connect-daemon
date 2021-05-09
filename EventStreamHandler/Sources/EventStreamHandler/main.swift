import Foundation
import XPC

/// wait for the event to be consumed
let semaphore = DispatchSemaphore(value: 0)
NSLog("Waiting for com.apple.iokit.matching event...");

xpc_set_event_stream_handler("com.apple.iokit.matching", nil) { object in
    let event = xpc_dictionary_get_string(object, XPC_EVENT_KEY_NAME);
    NSLog(String(cString: event!));
    semaphore.signal()
}
semaphore.wait()

/// run executable passed as CL argument
let args = CommandLine.arguments
if(args.count >= 2) {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: args[1])
    task.arguments = Array(args[2...])

    try task.run()
}
