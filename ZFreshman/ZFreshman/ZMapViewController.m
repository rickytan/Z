//
//  ZMapViewController.m
//  ZFreshman
//
//  Created by ricky on 14-2-14.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZMapViewController.h"

@interface ZImageView : UIImageView@end
@implementation ZImageView

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)setCenter:(CGPoint)center
{
    [super setCenter:center];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
}

@end

@interface ZMapViewController () <UIScrollViewDelegate>
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
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

    self.scrollView                     = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delegate            = self;
    self.scrollView.decelerationRate    = UIScrollViewDecelerationRateFast;
    self.scrollView.autoresizesSubviews = YES;
    
    self.imageView                  = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
    self.imageView.contentMode      = UIViewContentModeScaleAspectFit;
    self.imageView.image            = [UIImage imageNamed:@"zjg.jpg"];
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.scrollView addSubview:self.imageView];
    [self.view addSubview:self.scrollView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    self.scrollView.frame = self.view.bounds;
    self.imageView.frame = self.scrollView.bounds;
    [self setUpScaleAndFrame];
    [self centeringImageView];
}

#pragma mark - Gestures

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
    CGSize size = self.scrollView.frame.size;

    CGFloat hfactor = size.width / imgSize.width;
    CGFloat vfactor = size.height / imgSize.height;
    CGFloat factor = MIN(hfactor, vfactor);

    self.imageView.bounds = (CGRect){{0, 0}, {imgSize.width * factor, imgSize.height * factor}};

    if (hfactor > 1.0 && vfactor > 1.0)
        factor = 1.0;

    [UIView setAnimationsEnabled:NO];
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 1.0 / factor;
    self.scrollView.zoomScale = 1.0;
    [UIView setAnimationsEnabled:YES];
    _zoomIn = NO;
}

- (void)centeringImageView
{
    CGSize boundsSize = self.scrollView.frame.size;
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
                        atScale:(CGFloat)scale
{
    [self centeringImageView];
    if (scale == scrollView.minimumZoomScale)
        _zoomIn = NO;
}

@end
