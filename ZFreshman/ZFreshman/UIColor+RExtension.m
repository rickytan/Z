//
//  UIColor+RExtension.m
//  ZFreshman
//
//  Created by ricky on 14-2-12.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "UIColor+RExtension.h"

@implementation UIColor (RExtension)

+ (instancetype)colorWithHexString:(NSString *)colorString
{
    if (![colorString hasPrefix:@"#"] || (colorString.length != 7 && colorString.length != 4))
        return nil;

    char colorValue[8] = {0};
    if (![colorString getCString:colorValue
                       maxLength:8
                        encoding:NSUTF8StringEncoding])
        return nil;

    if (strlen(colorValue) == 4) {
        char r, g, b;
        r = colorValue[1];
        g = colorValue[2];
        b = colorValue[3];

        colorValue[2] = r;
        colorValue[3] = colorValue[4] = g;
        colorValue[5] = colorValue[6] = b;
    }

    unsigned int value = 0;
    sscanf(colorValue+1, "%x", &value);
    return [UIColor colorWithRed:1.0 * (value >> 16) / 255
                           green:1.0 * ((value >> 8) & 0xff) / 255
                            blue:1.0 * ((value >> 0) & 0xff) / 255
                           alpha:1.0];
}

@end