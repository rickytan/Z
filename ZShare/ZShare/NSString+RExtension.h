//
//  NSString+RExtension.h
//  RTUsefulExtension
//
//  Created by ricky on 13-4-27.
//  Copyright (c) 2013年 ricky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RExtension)
- (NSString*)md5;
- (NSData*)base64DecodedData;
+ (NSString*)uniqueString;
+ (NSString*)documentsPath;
+ (NSString*)libraryPath;
+ (NSString*)cachePath;
+ (NSString*)downloadPath;
+ (NSString*)tmpPath;
@end
