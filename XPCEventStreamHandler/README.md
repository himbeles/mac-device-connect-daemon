# XPCEventStreamHandler

Command line tool that sets up an XPC connection with the `com.apple.iokit.matching` Mach service, 
which is used by the system to match and configure device drivers. The code waits for an event to occur on the connection, 
and then logs the event to the console using NSLog. Afterwards, it runs an executable passed as an argument.

- Creates an XPC connection to the Mach service "com.apple.iokit.matching" using `xpc_connection_create_mach_service`.
- Sets an event handler using `xpc_connection_set_event_handler`.
- Resumes the connection with `xpc_connection_resume`.
- Runs the executable passed as an argument.

Build release  
```
swift build --configuration release
```

and copy `handle-xpc-event-stream` to `usr/local/bin`

```
cp -f .build/release/handle-xpc-event-stream /usr/local/bin/handle-xpc-event-stream
```
