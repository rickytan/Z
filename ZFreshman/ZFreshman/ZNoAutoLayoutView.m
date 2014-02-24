//
//  ZNoAutoLayoutView.m
//  ZFreshman
//
//  Created by ricky on 14-2-24.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZNoAutoLayoutView.h"

@implementation ZNoAutoLayoutView

+ (BOOL)requiresConstraintBasedLayout
{
    return NO;
}

@end
