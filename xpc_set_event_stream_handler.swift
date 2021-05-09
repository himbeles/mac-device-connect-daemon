import Foundation

import <xpc/xpc.h>

xpc.xpc_set_event_stream_handler("com.apple.iokit.matching", 

//    xpc_set_event_stream_handler("com.apple.iokit.matching", NULL, ^(xpc_object_t _Nonnull object) {
//        const char *event = xpc_dictionary_get_string(object, XPC_EVENT_KEY_NAME);
//        NSLog(@"%s", event);
//        dispatch_semaphore_signal(semaphore);
//    });
