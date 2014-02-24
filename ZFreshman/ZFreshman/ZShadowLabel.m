//
//  ZShadowLabel.m
//  ZFreshman
//
//  Created by ricky on 14-2-14.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZShadowLabel.h"

@implementation ZShadowLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGRect f = rect;
    f.origin.y = 30;
    for (int i=0; i < 32; ++i) {
        [[UIColor colorWithWhite:0.3
                           alpha:0.05 - 0.1 * i / 32] set];
        [self.text drawInRect:f
                     withFont:self.font
                lineBreakMode:self.lineBreakMode
                    alignment:self.textAlignment];
        f.origin.x += 0.5;
        f.origin.y += 0.5;
    }
    [super drawRect:rect];
}


@end
