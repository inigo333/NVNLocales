//
//  MIMSingleton.h
//  ConciergePrototype
//
//  Created by imato on 04/06/2015.
//  Copyright (c) 2015 Media inMotion. All rights reserved.
//

/*!
 * @function Singleton GCD Macro
 */


#ifndef SINGLETON_GCD
#define SINGLETON_GCD(classname)\
\
__strong static classname * shared##classname = nil;\
+ (classname *)shared##classname {\
    if(!shared##classname) {\
        static dispatch_once_t pred;\
        dispatch_once( &pred, ^{\
            shared##classname = [[self alloc] init];\
        });\
    }\
    return shared##classname;\
}\
\
+ (classname *)sharedManaged##classname {\
    return shared##classname;\
}\
\
+ (void)update##classname:(id)singleton {\
\
    shared##classname = singleton;\
}\

#endif
