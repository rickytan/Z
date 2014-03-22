//
//  UIView+DL.m
//  DreamLand
//
//  Created by ricky on 14-2-23.
//  Copyright (c) 2014年 ricky. All rights reserved.
//

#import "UIView+DL.h"

@implementation UIView (DL)

- (void)startShining
{
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.frame = CGRectMake(-2 * self.bounds.size.width, 0, 3 * self.bounds.size.width, self.bounds.size.height);
    maskLayer.colors = @[(id)[UIColor colorWithWhite:0
                                               alpha:0.4].CGColor,
                         (id)[UIColor colorWithWhite:0
                                               alpha:1].CGColor,
                         (id)[UIColor colorWithWhite:0
                                               alpha:0.4].CGColor];
    maskLayer.locations = @[[NSNumber numberWithFloat:1.0/3], [NSNumber numberWithFloat:0.5], [NSNumber numberWithFloat:2.0/3]];
    maskLayer.startPoint = CGPointMake(0, 1);
    CGFloat ratio = maskLayer.bounds.size.width / maskLayer.bounds.size.height;
    maskLayer.endPoint = CGPointMake(1, ratio * ratio);
    maskLayer.startPoint = CGPointMake(0, 1);
    maskLayer.endPoint = CGPointMake(1, 1);
    self.layer.mask = maskLayer;

    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    anim.byValue = [NSValue valueWithCGPoint:CGPointMake(2 * self.bounds.size.width, 0)];
    //anim.removedOnCompletion = YES;
    //anim.delegate = self;
    anim.duration = 3.0;
    //anim.autoreverses = YES;
    anim.repeatCount = CGFLOAT_MAX;
    [maskLayer addAnimation:anim
                     forKey:nil];
}

- (void)stopShining
{
    self.layer.mask = nil;
}

@end
