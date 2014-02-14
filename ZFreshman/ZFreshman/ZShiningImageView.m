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
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.frame = CGRectMake(-24, 0, 24, self.bounds.size.height);
    maskLayer.colors = @[(id)[UIColor colorWithWhite:0
                                               alpha:1].CGColor,
                         (id)[UIColor colorWithWhite:0
                                               alpha:0.1].CGColor,
                         (id)[UIColor colorWithWhite:0
                                               alpha:1].CGColor];
    maskLayer.locations = @[[NSNumber numberWithFloat:0.2], [NSNumber numberWithFloat:0.5], [NSNumber numberWithFloat:0.8]];
    maskLayer.startPoint = CGPointMake(0, 1);
    CGFloat ratio = maskLayer.bounds.size.width / maskLayer.bounds.size.height;
    maskLayer.endPoint = CGPointMake(1, ratio * ratio);
    self.layer.mask = maskLayer;

    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    anim.byValue = [NSValue valueWithCGPoint:CGPointMake(self.bounds.size.width, 0)];
    anim.removedOnCompletion = YES;
    anim.delegate = self;
    anim.duration = 1.5;
    anim.autoreverses = YES;
    [maskLayer addAnimation:anim
                     forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim
                finished:(BOOL)flag
{
    self.layer.mask = nil;
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
