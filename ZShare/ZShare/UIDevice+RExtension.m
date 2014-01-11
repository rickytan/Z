//
//  UIDevice+RExtension.m
//  ZShare
//
//  Created by ricky on 14-1-12.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "UIDevice+RExtension.h"
#include <netinet/in.h>
#include <netdb.h>
#include <ifaddrs.h>

@implementation UIDevice (RExtension)

- (struct in_addr)addr
{
    struct in_addr add = {0};

    struct ifaddrs *interfaces = NULL;

    // retrieve the current interfaces - returns 0 on success
    if (!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *temp_addr = interfaces;
        while (temp_addr) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if (!strcmp(temp_addr->ifa_name, "en0")) {
                    // Get NSString from C String
                    add = ((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr;
                    break;
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }

    // Free
    freeifaddrs(interfaces);
    return add;
}

- (NSString *)localIPAddress
{
    NSString *address = [NSString stringWithUTF8String:inet_ntoa(self.addr)];    
    return address;
}

@end
