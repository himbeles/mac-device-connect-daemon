# Tested on macOS Ventura.  Original version did not work.
- Creates an XPC connection to the Mach service "com.apple.iokit.matching" using `xpc_connection_create_mach_service`.
- Sets an event handler using `xpc_connection_set_event_handler`.
- Resumes the connection with `xpc_connection_resume`.
