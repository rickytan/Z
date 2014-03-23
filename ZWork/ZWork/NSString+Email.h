//
//  NSString+Email.h
//  ZWork
//
//  Created by ricky on 14-3-23.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Email)
@property (nonatomic, readonly, getter = isValidEmail) BOOL validEmail;
@end
