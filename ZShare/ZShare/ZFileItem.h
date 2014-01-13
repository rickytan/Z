//
//  ZFileItem.h
//  ZShare
//
//  Created by ricky on 14-1-13.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFileItem : NSObject
@property (nonatomic, strong) NSString * fileName;
@property (nonatomic, strong) NSNumber * fileSize;
@property (nonatomic, strong) NSDate * fileCreationDate;
@property (nonatomic, strong) NSDate * fileModificationDate;
@end
