import Foundation
import XPC
import ArgumentParser

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
        NSLog("Waiting for com.apple.iokit.matching event...");
        let connection = xpc_connection_create_mach_service("com.apple.iokit.matching", nil, UInt64(XPC_CONNECTION_MACH_SERVICE_LISTENER))
        xpc_connection_set_event_handler(connection, { object in
            let event = xpc_dictionary_get_string(object, XPC_EVENT_KEY_NAME)
            print(String(cString: event!))
            semaphore.signal()
        })
        xpc_connection_resume(connection)
        semaphore.wait()

        /// run executable passed as CL
        NSLog("Running executable \(executable)...");
        let task = Process()
        task.executableURL = URL(fileURLWithPath: executable)
        try task.run()
    }
}

XPCEventStreamHandler.main()
