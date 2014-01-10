//
//  RTSiderViewController.h
//  RTNavigationController
//
//  Created by ricky on 13-3-31.
//  Copyright (c) 2013年 ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef SAFE_RELEASE
#if __has_feature(objc_arc)
#define SAFE_RELEASE(o) ((o) = nil)
#define SAFE_DEALLOC(o) {}
#else
#define SAFE_RELEASE(o) ([(o) release], (o) = nil)
#define SAFE_AUTORELEASE(o) ([(o) autorelease])
#define SAFE_DEALLOC(o) [o dealloc]
#endif
#endif

@class RTSiderViewController;

@protocol RTSiderViewControllerDatasource <NSObject>
@optional
- (BOOL)shouldAdjustWidthOfLeftViewController;
- (BOOL)shouldAdjustWidthOfRightViewController;

- (CGFloat)siderViewControllerMarginForSlidingToRight:(RTSiderViewController*)controller;
- (CGFloat)siderViewControllerMarginForSlidingToLeft:(RTSiderViewController*)controller;

- (CATransform3D)siderViewController:(RTSiderViewController*)controller
                 transformWithOffset:(CGFloat)offset
                       andFadingView:(UIView*)view;

@end

typedef enum {
    SlideTranslationStyleNormal,
    SlideTranslationStyleFade,
    SlideTranslationStylePull,
    SlideTranslationStyleHalfPull,
    SlideTranslationStyleDeeper,
    SlideTranslationStyleLean,
    SlideTranslationStyleCustom
}SlideTranslationStyle;

typedef enum {
    SlideStateMiddle = 0,
    SlideStateLeft = 1,
    SlideStateRight = -1
}SlideState;

typedef enum {
    MiddleViewTranslationStyleStay,
    MiddleViewTranslationStyleBackIn,
    MiddleViewTranslationStyleDefault = MiddleViewTranslationStyleBackIn
}MiddleViewTranslationStyle;

@protocol RTSiderViewControllerDelegate <NSObject>
@optional
- (BOOL)siderViewController:(RTSiderViewController*)controller
        canSlideToDirection:(SlideState)state;
- (void)siderViewController:(RTSiderViewController*)controller
       willSlideToDirection:(SlideState)state;
- (void)siderViewController:(RTSiderViewController *)controller
        didSlideToDirection:(SlideState)state;

@end

@interface RTSiderViewController : UIViewController <UIGestureRecognizerDelegate>
{
    UIViewController            * _currentMiddleViewController;
    UIViewController            * _currentLeftViewController;
    UIViewController            * _currentRightViewController;
    UIPanGestureRecognizer      * _pan;
    UISwipeGestureRecognizer    * _swipe;
    UITapGestureRecognizer      * _tap;
    
    CGAffineTransform             _currentTrans;
    
    UIView                      * _maskView;
    UIScrollView                * _scrollView;
    
    SlideState                    _state;
    
    struct {
        unsigned int shouldAdjustLeftWidth:1;
        unsigned int shouldAdjustRightWidth:1;
        unsigned int isAnimating:1;
    } _sideControllerFlags;
}

@property (nonatomic, assign) id<RTSiderViewControllerDatasource> dataSource;
@property (nonatomic, assign) id<RTSiderViewControllerDelegate> delegate;     // Not Implemented yet!
@property (nonatomic, assign) SlideTranslationStyle translationStyle;
@property (nonatomic, assign) MiddleViewTranslationStyle middleTranslationStyle;
@property (nonatomic, readonly) SlideState state;
@property (nonatomic, assign) BOOL allowOverDrag;   // default YES
@property (nonatomic, assign) BOOL tapToCenter;    // default YES

- (void)setMiddleViewController:(UIViewController*)controller
                       animated:(BOOL)animated;
- (void)setMiddleViewController:(UIViewController *)controller;
- (void)setLeftViewController:(UIViewController*)controller;
- (void)setRightViewController:(UIViewController*)controller;

- (void)slideToRightAnimated:(BOOL)animated;
- (void)slideToLeftAnimated:(BOOL)animated;
- (void)slideToMiddleAnimated:(BOOL)animated;

@end


@interface UIViewController (RTSiderViewControllerItem)
@property (nonatomic, readonly) RTSiderViewController *siderViewController;
@end
