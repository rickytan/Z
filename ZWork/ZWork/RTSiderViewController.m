//
//  RTSiderViewController.m
//  RTNavigationController
//
//  Created by ricky on 13-3-31.
//  Copyright (c) 2013年 ricky. All rights reserved.
//

#import "RTSiderViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

#define DEFAULT_MARGIN 48.0f
#define PAN_THRESHOLD 64.0f

@interface RTSiderContentView : UIView

@end

@implementation RTSiderContentView

+ (Class)layerClass
{
    return [CATransformLayer class];
}

@end
@interface RTSiderViewController ()
@property (nonatomic, readwrite) SlideState state;
- (void)onPan:(UIPanGestureRecognizer*)pan;
- (void)onSwipe:(UISwipeGestureRecognizer*)swipe;
- (void)onTap:(UITapGestureRecognizer*)tap;

- (CGFloat)normalizedOffset;
- (void)applyTranslationForController:(UIViewController*)controller
                           withOffset:(CGFloat)offset;
- (CGFloat)marginForSlidingRight;
- (CGFloat)marginForSlidingLeft;

- (void)loadLeftViewController;
- (void)loadRightViewController;
@end

@implementation RTSiderViewController
@synthesize state = _state;
@synthesize translationStyle = _translationStyle;
@synthesize middleTranslationStyle = _middleTranslationStyle;
@synthesize tapToCenter = _tapToCenter;
@synthesize allowOverDrag = _allowOverDrag;
@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;

- (void)dealloc
{
    SAFE_RELEASE(_maskView);
    SAFE_RELEASE(_pan);
    SAFE_RELEASE(_swipe);
    SAFE_RELEASE(_maskView);
    
    SAFE_DEALLOC(super);
}

- (void)commonInit
{
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                   action:@selector(onPan:)];
    _pan.delegate = self;
    
    _swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                       action:@selector(onSwipe:)];
    _swipe.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    _swipe.delegate = self;
    
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                   action:@selector(onTap:)];
    _tap.numberOfTapsRequired = 1;
    _tap.numberOfTouchesRequired = 1;
    _tap.delegate = self;
    //[_tap requireGestureRecognizerToFail:_pan];
    
    _currentTrans = CGAffineTransformIdentity;
    
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.userInteractionEnabled = NO;
    _maskView.alpha = 0.0f;
    _maskView.hidden = YES;
    
    self.tapToCenter = YES;
    self.allowOverDrag = YES;
    self.middleTranslationStyle = MiddleViewTranslationStyleDefault;
    self.translationStyle = SlideTranslationStyleNormal;
}

- (void)awakeFromNib
{
    [self commonInit];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self commonInit];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor clearColor];
    //self.view.multipleTouchEnabled = NO;
    
    _maskView.frame = self.view.bounds;
    [self.view addSubview:_maskView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.view addGestureRecognizer:_pan];
    //[self.view addGestureRecognizer:_swipe];
    [self.view addGestureRecognizer:_tap];
    
    CATransform3D t = CATransform3DIdentity;
    t.m34 = -0.002;
    self.view.layer.sublayerTransform = t;
    
    _currentMiddleViewController.view.frame = self.view.bounds;
    [self.view addSubview:_currentMiddleViewController.view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter & setter

- (void)setTranslationStyle:(SlideTranslationStyle)translationStyle
{
    if (_translationStyle != translationStyle) {
        _translationStyle = translationStyle;
        
        if (self.state == SlideStateLeft) {
            [self applyTranslationForController:_currentLeftViewController
                                     withOffset:1.0];
        }
        else if (self.state == SlideStateRight) {
            [self applyTranslationForController:_currentRightViewController
                                     withOffset:-1.0];
        }
    }
}

- (void)setState:(SlideState)state
{
    if (_state == state)
        return;
    switch (state) {
        case SlideStateLeft:
        {
            [self loadLeftViewController];
            _currentLeftViewController.view.userInteractionEnabled = NO;
            
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(-4, -8, 8, self.view.bounds.size.height + 16)];
            _currentMiddleViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
            _currentMiddleViewController.view.layer.shadowOffset = CGSizeZero;
            _currentMiddleViewController.view.layer.shadowOpacity = 0.75;
            _currentMiddleViewController.view.layer.shadowPath = path.CGPath;
            if (_currentRightViewController.isViewLoaded)
                [_currentRightViewController.view removeFromSuperview];
        }
            break;
        case SlideStateMiddle:
            _currentMiddleViewController.view.layer.shadowOffset = CGSizeZero;
            _currentMiddleViewController.view.layer.shadowColor = NULL;
            _currentMiddleViewController.view.layer.shadowOpacity = 0.0;
            if (_currentLeftViewController.isViewLoaded)
                [_currentLeftViewController.view removeFromSuperview];
            if (_currentRightViewController.isViewLoaded)
                [_currentRightViewController.view removeFromSuperview];
            break;
        case SlideStateRight:
        {
            [self loadRightViewController];
            _currentRightViewController.view.userInteractionEnabled = NO;
            
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(self.view.bounds.size.width-4, -8, 8, self.view.bounds.size.height + 16)];
            _currentMiddleViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
            _currentMiddleViewController.view.layer.shadowOffset = CGSizeZero;
            _currentMiddleViewController.view.layer.shadowOpacity = 0.75;
            _currentMiddleViewController.view.layer.shadowPath = path.CGPath;
            if (_currentLeftViewController.isViewLoaded)
                [_currentLeftViewController.view removeFromSuperview];
        }
        default:
            break;
    }
    
    _state = state;
}

- (void)setTapToCenter:(BOOL)tapToCenter
{
    _tapToCenter = tapToCenter;
    _tap.enabled = _tapToCenter;
}

- (void)setDataSource:(id<RTSiderViewControllerDatasource>)dataSource
{
    _dataSource = dataSource;
    
    if ([_dataSource respondsToSelector:@selector(shouldAdjustWidthOfLeftViewController)]) {
        _sideControllerFlags.shouldAdjustLeftWidth = [_dataSource shouldAdjustWidthOfLeftViewController];
    }
    if ([_dataSource respondsToSelector:@selector(shouldAdjustWidthOfRightViewController)]) {
        _sideControllerFlags.shouldAdjustRightWidth = [_dataSource shouldAdjustWidthOfRightViewController];
    }
}

- (void)setMiddleViewController:(UIViewController *)controller animated:(BOOL)animated
{
    if (_currentMiddleViewController != controller) {
        NSAssert(controller != nil, @"Middle View Controller Can't be Nil!");
        
        if (!_currentMiddleViewController) {
            [self addChildViewController:controller];
            _currentMiddleViewController = controller;
            [_currentMiddleViewController.view addObserver:self
                                                forKeyPath:@"transform"
                                                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                                   context:NULL];
            if (self.isViewLoaded) {
                _currentMiddleViewController.view.frame = self.view.bounds;
                [self.view addSubview:_currentMiddleViewController.view];
                [self.view bringSubviewToFront:_currentMiddleViewController.view];
            }
            return;
        }
        
        [self addChildViewController:controller];
        
        if (self.state == SlideStateMiddle) {
            [self transitionFromViewController:_currentMiddleViewController
                              toViewController:controller
                                      duration:animated?0.25:0.0
                                       options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                                    animations:^{
                                        
                                    }
                                    completion:^(BOOL finished) {
                                        [_currentMiddleViewController.view removeObserver:self
                                                                               forKeyPath:@"transform"];
                                        [_currentMiddleViewController removeFromParentViewController];
                                        _currentMiddleViewController = controller;
                                        [_currentMiddleViewController.view addObserver:self
                                                                            forKeyPath:@"transform"
                                                                               options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                                                               context:NULL];
                                    }];
            return;
        }
        
        _currentMiddleViewController.view.userInteractionEnabled = NO;
        
        void(^block)(BOOL) = ^(BOOL finished){
            [_currentMiddleViewController.view removeObserver:self
                                                   forKeyPath:@"transform"];
            controller.view.userInteractionEnabled = NO;
            controller.view.frame = self.view.bounds;
            controller.view.transform = _currentMiddleViewController.view.transform;
            [self.view insertSubview:controller.view
                        aboveSubview:_currentMiddleViewController.view];
            [_currentMiddleViewController.view removeFromSuperview];
            
            [_currentMiddleViewController removeFromParentViewController];
            
            _currentMiddleViewController = controller;
            [_currentMiddleViewController.view addObserver:self
                                                forKeyPath:@"transform"
                                                   options:NSKeyValueObservingOptionNew
                                                   context:NULL];
            
            [self slideToMiddleAnimated:animated];
        };
        
        if (self.middleTranslationStyle == MiddleViewTranslationStyleStay) {
            block(YES);
        }
        else if (self.middleTranslationStyle == MiddleViewTranslationStyleBackIn) {
            [UIView animateWithDuration:animated?0.25:0.0
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 CGAffineTransform tran = {0};
                                 if (self.state == SlideStateLeft) {
                                     tran = CGAffineTransformMakeTranslation(self.view.bounds.size.width, 0);
                                 }
                                 else if (self.state == SlideStateRight) {
                                     tran = CGAffineTransformMakeTranslation(-self.view.bounds.size.width, 0);
                                 }
                                 _currentMiddleViewController.view.transform = tran;
                             }
                             completion:block];
        }
    }
    else {
        [self slideToMiddleAnimated:animated];
    }
}

- (void)setMiddleViewController:(UIViewController *)controller
{
    [self setMiddleViewController:controller
                         animated:NO];
}

- (void)setLeftViewController:(UIViewController *)controller
{
    if (_currentLeftViewController != controller) {
        if (!controller) {
            if ([_currentLeftViewController isViewLoaded])
                [_currentLeftViewController.view removeFromSuperview];
            
            [_currentLeftViewController removeFromParentViewController];
            _currentLeftViewController = nil;
            return;
        }
        if (!_currentLeftViewController) {
            [self addChildViewController:controller];
            _currentLeftViewController = controller;
            return;
        }
        
        [self addChildViewController:controller];
        [self transitionFromViewController:_currentLeftViewController
                          toViewController:controller
                                  duration:0.25
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    
                                }
                                completion:^(BOOL finished) {
                                    if (finished) {
                                        [_currentLeftViewController removeFromParentViewController];
                                        _currentLeftViewController = controller;
                                    }
                                }];
        
    }
}

- (void)setRightViewController:(UIViewController *)controller
{
    if (_currentRightViewController != controller) {
        if (!controller) {
            if ([_currentRightViewController isViewLoaded])
                [_currentRightViewController.view removeFromSuperview];
            [_currentRightViewController removeFromParentViewController];
            _currentRightViewController = nil;
            return;
        }
        if (!_currentRightViewController) {
            [self addChildViewController:controller];
            _currentRightViewController = controller;
            return;
        }
        
        [self addChildViewController:controller];
        [self transitionFromViewController:_currentLeftViewController
                          toViewController:controller
                                  duration:0.25
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    
                                }
                                completion:^(BOOL finished) {
                                    if (finished) {
                                        [_currentLeftViewController removeFromParentViewController];
                                        _currentLeftViewController = controller;
                                    }
                                }];
        
    }
}

#pragma mark - Methods

- (void)onPan:(UIPanGestureRecognizer *)pan
{
    switch (_pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            _currentMiddleViewController.view.userInteractionEnabled = NO;
            
            if (_currentLeftViewController.isViewLoaded)
                _currentLeftViewController.view.userInteractionEnabled = NO;
            if (_currentRightViewController.isViewLoaded)
                _currentRightViewController.view.userInteractionEnabled = NO;
            
            
            _currentTrans = _currentMiddleViewController.view.transform;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint p = [_pan translationInView:self.view];
            CGFloat tx = p.x + _currentTrans.tx;
            
            if ((tx > 0 && _currentLeftViewController) ||
                (tx < 0 && _currentRightViewController)) {
                if (!self.allowOverDrag) {
                    if (self.state == SlideStateLeft &&
                        tx > CGRectGetWidth(self.view.bounds) - [self marginForSlidingRight])
                        tx = CGRectGetWidth(self.view.bounds) - [self marginForSlidingRight];
                    else if (self.state == SlideStateRight &&
                             tx < -(CGRectGetWidth(self.view.bounds) - [self marginForSlidingLeft]))
                        tx = -(CGRectGetWidth(self.view.bounds) - [self marginForSlidingLeft]);
                }
                _currentMiddleViewController.view.transform = CGAffineTransformMakeTranslation(tx, 0);
            }
            else
                _currentMiddleViewController.view.transform = CGAffineTransformIdentity;
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            CGPoint v = [_pan velocityInView:self.view];
            if (fabs(v.x) < 32.0) {
                CGPoint p = [_pan translationInView:self.view];
                if (self.state == SlideStateLeft) {
                    if (p.x + _currentTrans.tx > PAN_THRESHOLD)
                        [self slideToRightAnimated:YES];
                    else
                        [self slideToMiddleAnimated:YES];
                }
                else if (self.state == SlideStateRight) {
                    if (p.x + _currentTrans.tx < -PAN_THRESHOLD)
                        [self slideToLeftAnimated:YES];
                    else
                        [self slideToMiddleAnimated:YES];
                }
            }
            else {
                if (v.x < 0) {
                    if (self.state == SlideStateLeft)
                        [self slideToMiddleAnimated:YES];
                    else
                        [self slideToLeftAnimated:YES];
                }
                else {
                    if (self.state == SlideStateRight)
                        [self slideToMiddleAnimated:YES];
                    else
                        [self slideToRightAnimated:YES];
                }
            }
            _scrollView.panGestureRecognizer.enabled = YES;
            _scrollView = nil;
        }
            break;
        default:
            break;
    }
}

- (void)onTap:(UITapGestureRecognizer *)tap
{
    switch (_tap.state) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateEnded:
            [self slideToMiddleAnimated:YES];
            break;
        default:
            break;
    }
    
}

- (void)onSwipe:(UISwipeGestureRecognizer *)swipe
{
    if (_swipe.state == UIGestureRecognizerStateEnded) {
        if (_swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
            if (self.state == SlideStateMiddle)
                [self slideToLeftAnimated:YES];
            else if (self.state == SlideStateLeft)
                [self slideToMiddleAnimated:YES];
        }
        else if (_swipe.direction == UISwipeGestureRecognizerDirectionRight) {
            if (self.state == SlideStateMiddle)
                [self slideToRightAnimated:YES];
            else if (self.state == SlideStateRight)
                [self slideToMiddleAnimated:YES];
        }
        
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (!_sideControllerFlags.isAnimating && object == _currentMiddleViewController.view) {
        CGFloat offset = [self normalizedOffset];
        
        if (self.state == SlideStateLeft)
            [self applyTranslationForController:_currentLeftViewController
                                     withOffset:offset];
        else if (self.state == SlideStateRight)
            [self applyTranslationForController:_currentRightViewController
                                     withOffset:offset];
    }
}

- (CGFloat)normalizedOffset
{
    CGFloat offset = _currentMiddleViewController.view.frame.origin.x;
    if (offset > 0) {
        self.state = SlideStateLeft;
        offset = MIN(offset / (self.view.bounds.size.width - [self marginForSlidingRight]),1.0);
    }
    else if (offset < 0) {
        self.state = SlideStateRight;
        offset = MAX(offset / (self.view.bounds.size.width - [self marginForSlidingLeft]),-1.0);
    }
    return offset;
}

- (void)applyTranslationForController:(UIViewController *)controller
                           withOffset:(CGFloat)offset
{
    _maskView.hidden = YES;
    
    switch (self.translationStyle) {
        case SlideTranslationStyleNormal:
            controller.view.transform = CGAffineTransformIdentity;
            break;
        case SlideTranslationStyleFade:
            _maskView.hidden = NO;
            _maskView.alpha = 0.8 * (1 - fabs(offset));
            controller.view.transform = CGAffineTransformIdentity;
            break;
        case SlideTranslationStylePull:
            if (offset > 0) {
                CGFloat w = self.view.bounds.size.width - [self marginForSlidingRight];
                controller.view.transform = CGAffineTransformMakeTranslation(offset*w - w, 0);
            }
            else if (offset < 0) {
                CGFloat w = self.view.bounds.size.width - [self marginForSlidingLeft];
                controller.view.transform = CGAffineTransformMakeTranslation(offset*w + w, 0);
            }
            else {
                if (self.state == SlideStateLeft) {
                    CGFloat w = self.view.bounds.size.width - [self marginForSlidingRight];
                    controller.view.transform = CGAffineTransformMakeTranslation(-w, 0);
                }
                else if (self.state == SlideStateRight) {
                    CGFloat w = self.view.bounds.size.width - [self marginForSlidingLeft];
                    controller.view.transform = CGAffineTransformMakeTranslation(w, 0);
                }
            }
            break;
        case SlideTranslationStyleHalfPull:
            _maskView.hidden = NO;
            _maskView.alpha = 0.8 * (1 - fabs(offset));
            offset /= 2;
            if (offset > 0) {
                CGFloat w = self.view.bounds.size.width - [self marginForSlidingRight];
                controller.view.transform = CGAffineTransformMakeTranslation((offset - 0.5)*w, 0);
            }
            else if (offset < 0) {
                CGFloat w = self.view.bounds.size.width - [self marginForSlidingLeft];
                controller.view.transform = CGAffineTransformMakeTranslation((offset + 0.5)*w, 0);
            }
            else {
                if (self.state == SlideStateLeft) {
                    CGFloat w = self.view.bounds.size.width - [self marginForSlidingRight];
                    controller.view.transform = CGAffineTransformMakeTranslation(-0.5*w, 0);
                }
                else if (self.state == SlideStateRight) {
                    CGFloat w = self.view.bounds.size.width - [self marginForSlidingLeft];
                    controller.view.transform = CGAffineTransformMakeTranslation(0.5*w, 0);
                }
            }
            break;
        case SlideTranslationStyleDeeper:
            _maskView.hidden = NO;
            _maskView.alpha = 0.8 * (1 - fabs(offset));
            controller.view.layer.transform = CATransform3DMakeTranslation(0, 0, -18 + 16 * fabsf(offset));
            break;
        case SlideTranslationStyleLean:
        {
            _maskView.hidden = NO;
            _maskView.alpha = 0.8 * (1 - fabs(offset));
            CGFloat angle = 4.0 * (1-fabs(offset)) * M_PI/180;
            CGFloat z = self.view.bounds.size.height/2 * sinf(angle);
            CATransform3D t = CATransform3DMakeTranslation(0, 0, -2 - z);
            t = CATransform3DRotate(t, angle, 1.0, 0, 0);
            controller.view.layer.transform = t;
        }
            break;
        case SlideTranslationStyleCustom:
            controller.view.layer.transform = [self.dataSource siderViewController:self
                                                               transformWithOffset:offset
                                                                     andFadingView:_maskView];
            break;
        default:
            break;
    }
}

- (void)slideToLeftAnimated:(BOOL)animated
{
    if (!_currentRightViewController)
        return;
    
    [self loadRightViewController];
    
    _currentRightViewController.view.userInteractionEnabled = NO;
    _currentMiddleViewController.view.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _currentMiddleViewController.view.transform = CGAffineTransformMakeTranslation(-(self.view.bounds.size.width - [self marginForSlidingLeft]), 0);
                     }
                     completion:^(BOOL finished) {
                         _currentRightViewController.view.userInteractionEnabled = YES;
                     }];
}

- (void)slideToMiddleAnimated:(BOOL)animated
{
    _currentMiddleViewController.view.userInteractionEnabled = NO;
    
    if (_currentLeftViewController.isViewLoaded)
        _currentLeftViewController.view.userInteractionEnabled = NO;
    if (_currentRightViewController.isViewLoaded)
        _currentRightViewController.view.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _currentMiddleViewController.view.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         if (finished)
                             self.state = SlideStateMiddle;
                         _currentMiddleViewController.view.userInteractionEnabled = YES;
                     }];
}

- (void)slideToRightAnimated:(BOOL)animated
{
    if (!_currentLeftViewController)
        return;
    
    [self loadLeftViewController];
    
    _currentLeftViewController.view.userInteractionEnabled = NO;
    _currentMiddleViewController.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _currentMiddleViewController.view.transform = CGAffineTransformMakeTranslation((self.view.bounds.size.width - [self marginForSlidingRight]), 0);
                     }
                     completion:^(BOOL finished) {
                         _currentLeftViewController.view.userInteractionEnabled = YES;
                     }];
}

- (CGFloat)marginForSlidingLeft
{
    CGFloat v = DEFAULT_MARGIN;
    if ([self.dataSource respondsToSelector:@selector(siderViewControllerMarginForSlidingToLeft:)])
        v = [self.dataSource siderViewControllerMarginForSlidingToLeft:self];
    return v;
}

- (CGFloat)marginForSlidingRight
{
    CGFloat v = DEFAULT_MARGIN;
    if ([self.dataSource respondsToSelector:@selector(siderViewControllerMarginForSlidingToRight:)])
        v = [self.dataSource siderViewControllerMarginForSlidingToRight:self];
    return v;
}

- (void)loadRightViewController
{
    if (!_currentRightViewController.isViewLoaded) {
        _currentRightViewController.view.transform = CGAffineTransformIdentity;
        if (_sideControllerFlags.shouldAdjustRightWidth)
            _currentRightViewController.view.frame = UIEdgeInsetsInsetRect(self.view.bounds, UIEdgeInsetsMake(0, [self marginForSlidingLeft], 0, 0));
        else
            _currentRightViewController.view.frame = self.view.bounds;
    }
    [self.view insertSubview:_currentRightViewController.view
                belowSubview:_maskView];
}

- (void)loadLeftViewController
{
    if (!_currentLeftViewController.isViewLoaded) {
        _currentLeftViewController.view.transform = CGAffineTransformIdentity;
        if (_sideControllerFlags.shouldAdjustLeftWidth)
            _currentLeftViewController.view.frame = UIEdgeInsetsInsetRect(self.view.bounds, UIEdgeInsetsMake(0, 0, 0, [self marginForSlidingRight]));
        else
            _currentLeftViewController.view.frame = self.view.bounds;
    }
    [self.view insertSubview:_currentLeftViewController.view
                belowSubview:_maskView];
}

#pragma mark - UIGesture Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if (_pan == gestureRecognizer) {
        _scrollView = nil;
        UIView *v = touch.view;
        while (v) {
            if ([v isKindOfClass:[UIScrollView class]]) {
                _scrollView = (UIScrollView*)v;
                break;
            }
            v = v.superview;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ((_tap == gestureRecognizer && _pan == otherGestureRecognizer) ||
        (_pan == gestureRecognizer && _tap == otherGestureRecognizer))
        return NO;
    if (_pan == gestureRecognizer)
        return NO;
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (_pan == gestureRecognizer) {
        CGPoint p = [_pan translationInView:self.view];
        BOOL begin = fabsf(p.x) > fabsf(p.y);
        if (begin) {
            if (self.state == SlideStateMiddle) {
                if (p.x < 0) {
                    if (_currentRightViewController == nil)
                        begin = NO;
                    else if (_currentRightViewController &&
                             [self.delegate respondsToSelector:@selector(siderViewController:canSlideToDirection:)])
                        begin = [self.delegate siderViewController:self
                                               canSlideToDirection:SlideStateRight];
                    
                    CGFloat offset = _scrollView.contentOffset.x + _scrollView.bounds.size.width - _scrollView.contentInset.right;
                    if (offset >= _scrollView.contentSize.width && begin)
                        _scrollView.panGestureRecognizer.enabled = NO;
                }
                else {
                    if (_currentLeftViewController == nil)
                        begin = NO;
                    else if (_currentLeftViewController &&
                             [self.delegate respondsToSelector:@selector(siderViewController:canSlideToDirection:)])
                        begin = [self.delegate siderViewController:self
                                               canSlideToDirection:SlideStateLeft];
                    
                    CGFloat offset = _scrollView.contentOffset.x + _scrollView.contentInset.left;
                    if (offset <= 0.0 && begin)
                        _scrollView.panGestureRecognizer.enabled = NO;
                }
                
            }
            else {
                _scrollView = nil;
                
                CGPoint l = [_pan locationInView:self.view];
                begin = CGRectContainsPoint(_currentMiddleViewController.view.frame, l);
            }
        }
        return begin;
    }
    else if (_swipe == gestureRecognizer) {
        return YES;
    }
    else if (_tap == gestureRecognizer) {
        CGPoint l = [_tap locationInView:self.view];
        return self.tapToCenter && self.state != SlideStateMiddle && CGRectContainsPoint(_currentMiddleViewController.view.frame, l);
    }
    return YES;
}

@end


@implementation UIViewController (RTSiderViewControllerItem)

- (RTSiderViewController*)siderViewController
{
    UIViewController *c = self.parentViewController;
    while (c) {
        if ([c isKindOfClass:[RTSiderViewController class]])
            return (RTSiderViewController*)c;
        c = c.parentViewController;
    }
    return nil;
}

@end
