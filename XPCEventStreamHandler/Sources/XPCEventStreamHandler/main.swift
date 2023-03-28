import Foundation
import XPC
import ArgumentParser
import OSLog

let defaultLog = Logger()

struct XPCEventStreamHandler: ParsableCommand {
    
    public static let configuration = CommandConfiguration(
        abstract: """
            Command line tool that sets up an XPC connection with the `com.apple.iokit.matching` Mach service, 
            which is used by the system to match and configure device drivers. The code waits for an event to occur on the connection, 
            and then logs the event to the console using NSLog. Afterwards, it runs an executable passed as an argument.

            - Creates an XPC connection to the Mach service "com.apple.iokit.matching" using `xpc_connection_create_mach_service`.
            - Sets an event handler using `xpc_connection_set_event_handler`.
            - Resumes the connection with `xpc_connection_resume`.
            - Runs the executable passed as an argument.
        """)

    @Argument(help: "The executable to run after the event has been consumed.")
    private var executable: String

    init() { }
    
    func run() throws {
        /// wait for the event to be consumed
        let semaphore = DispatchSemaphore(value: 0)
        defaultLog.log("Waiting for com.apple.iokit.matching event...");
        xpc_set_event_stream_handler("com.apple.iokit.matching", nil) { object in
            let event = xpc_dictionary_get_string(object, XPC_EVENT_KEY_NAME)
            
            defaultLog.log("detected event: \(String(cString: event!), privacy: .public)")
            semaphore.signal()
        }
        semaphore.wait()

        /// run executable passed as CL
        defaultLog.log("Running executable ...");
        let task = Process()
        task.executableURL = URL(fileURLWithPath: executable)
        try task.run()
    }
}

XPCEventStreamHandler.main()
