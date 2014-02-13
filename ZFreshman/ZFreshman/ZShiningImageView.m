//
//  ZShiningImageView.m
//  ZFreshman
//
//  Created by ricky on 14-2-13.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZShiningImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ZShiningImageView

- (void)commonInit
{

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [self commonInit];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
