//
//  UIDevice+RExtension.h
//  ZShare
//
//  Created by ricky on 14-1-12.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <netinet/in.h>
#include <arpa/inet.h>

@interface UIDevice (RExtension)

- (NSString *)localIPAddress;
- (struct in_addr)addr;

@end
