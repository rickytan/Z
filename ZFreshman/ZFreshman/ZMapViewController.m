//
//  ZMapViewController.m
//  ZFreshman
//
//  Created by ricky on 14-2-14.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZMapViewController.h"

@interface ZMapViewController () <UIScrollViewDelegate>
@property (nonatomic, assign) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) IBOutlet UIImageView *imageView;
@property (nonatomic, assign) BOOL zoomIn;
@end

@implementation ZMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.scrollView.frame = self.view.bounds;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.imageView.frame = self.scrollView.bounds;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    [self setUpScaleAndFrame];
    [self centeringImageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onDoubleTap:(UITapGestureRecognizer*)tap
{
    switch (tap.state) {
        case UIGestureRecognizerStateEnded:
            if (!_zoomIn) {
                CGPoint point = [tap locationInView:self.imageView];
                [self.scrollView zoomToRect:(CGRect){point, CGSizeZero}
                                   animated:YES];

                [self centeringImageView];
            }
            else {
                [self.scrollView setZoomScale:self.scrollView.minimumZoomScale
                                     animated:YES];

                [self centeringImageView];
            }
            break;

        default:
            break;
    }
}

- (void)setUpScaleAndFrame
{
    CGSize imgSize = self.imageView.image.size;
    CGSize size = self.scrollView.bounds.size;

    CGFloat hfactor = size.width / imgSize.width;
    CGFloat vfactor = size.height / imgSize.height;
    CGFloat factor = MIN(hfactor, vfactor);

    self.imageView.bounds = (CGRect){{0,0}, {imgSize.width * factor, imgSize.height * factor}};

    if (hfactor > 1.0 && vfactor > 1.0)
        factor = 1.0;

    [UIView setAnimationsEnabled:NO];
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 1.0 / factor;
    self.scrollView.zoomScale = 1.0;
    [UIView setAnimationsEnabled:YES];
}

- (void)centeringImageView
{
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect frameToCenter = self.imageView.frame;

    // Horizontally
    if (frameToCenter.size.width <= boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
	} else {
        frameToCenter.origin.x = 0;
	}

    // Vertically
    if (frameToCenter.size.height <= boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
	} else {
        frameToCenter.origin.y = 0;
	}

    self.imageView.frame = frameToCenter;
}

#pragma mark - Gestures



#pragma mark - UIScroll Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView
                          withView:(UIView *)view
{
    _zoomIn = YES;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centeringImageView];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView
                       withView:(UIView *)view
                        atScale:(float)scale
{
    [self centeringImageView];
    if (scale == scrollView.minimumZoomScale)
        _zoomIn = NO;
}

@end
