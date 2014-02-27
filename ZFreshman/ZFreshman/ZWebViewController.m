//
//  ZQuestionViewController.m
//  ZFreshman
//
//  Created by ricky on 14-2-14.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZWebViewController.h"
#import "SVModalWebViewController.h"

@interface ZWebViewController () <UIWebViewDelegate>
@property (nonatomic, assign) IBOutlet UIWebView *webView;
@property (nonatomic, assign) BOOL flip;
@end

@implementation ZWebViewController

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
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Web Delegate

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked && !request.URL.isFileURL && [request.URL.scheme hasPrefix:@"http"]) {
        SVModalWebViewController *controller = [[SVModalWebViewController alloc] initWithURL:request.URL];
        [self presentViewController:controller
                           animated:YES
                         completion:NULL];
        return NO;
    }
    else if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        self.flip = YES;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (self.flip)
        [UIView transitionWithView:self.view
                          duration:0.35
                           options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            self.webView.alpha = 0.0;
                        }
                        completion:^(BOOL finished) {

                        }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.webView.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {

                     }];
}

@end
