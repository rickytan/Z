//
//  ZParttimeDetailViewController.m
//  ZWork
//
//  Created by ricky on 14-3-22.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZParttimeDetailViewController.h"

@interface ZParttimeDetailViewController () <UIWebViewDelegate>
@property (nonatomic, assign) IBOutlet UIWebView *webView;
@end

@implementation ZParttimeDetailViewController

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
    
    self.webView.hidden = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUrl:(NSURL *)url
{
    if (_url != url) {
        _url = url;
        if (self.isViewLoaded) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
        }
    }
}

#pragma mark - UIWebView Delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"\
     document.body.style.background = 'none';\
     document.body.style.padding = '2em 1em';\
     document.body.style.fontSize = '12pt';\
     var m=document.createElement('meta');\
     m.name='viewport';\
     m.content='width=device-width,initial-scale=1,maxinum-scale=1,user-scalable=0';\
     document.head.appendChild(m);\
     div = document.getElementsByClassName('about_word')[0];\
     div.style.width='100%';\
     div.style.float='none';\
     document.body.innerText = div.outerText;\
     "];
    webView.hidden = NO;
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anim.fromValue = [NSNumber numberWithFloat:0];
    anim.duration = 0.35;
    anim.removedOnCompletion = YES;
    [webView.layer addAnimation:anim
                         forKey:@"Fadeout"];
}

@end
