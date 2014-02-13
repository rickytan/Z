//
//  UIColor+RExtension.h
//  ZFreshman
//
//  Created by ricky on 14-2-12.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RExtension)
+ (instancetype)colorWithHexString:(NSString *)colorString; // #ffbc90 or #ffc
+ (instancetype)colorForIndex:(NSInteger)index;
+ (UIColor *)iOS7DefaultBlueTint;
@end
