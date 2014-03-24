//
//  ZHelpDetailViewController.m
//  ZWork
//
//  Created by ricky on 14-3-24.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZHelpDetailViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface ZHelpDetailViewController () <UIWebViewDelegate>
@property (nonatomic, assign) IBOutlet UIWebView * webView;
@end

@implementation ZHelpDetailViewController

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
    
    [self.webView loadHTMLString:[self buildHTMLFromTemplate]
                         baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)buildHTMLFromTemplate
{
    NSString *temp = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"template"
                                                                                        ofType:@"html"]
                                               encoding:NSUTF8StringEncoding error:NULL];
    NSString *title = self.needItem[@"title"];
    NSMutableString *images = [[NSMutableString alloc] initWithString:@""];
    if ([self.needItem[@"image0"] isKindOfClass:[AVFile class]]) {
        AVFile *file = (AVFile *)self.needItem[@"image0"];
        [images appendFormat:@"<p><img src='%@'/></p>\n", file.url];
    }
    if ([self.needItem[@"image1"] isKindOfClass:[AVFile class]]) {
        AVFile *file = (AVFile *)self.needItem[@"image0"];
        [images appendFormat:@"<p><img src='%@'/></p>\n", file.url];
    }
    if ([self.needItem[@"image2"] isKindOfClass:[AVFile class]]) {
        AVFile *file = (AVFile *)self.needItem[@"image0"];
        [images appendFormat:@"<p><img src='%@'/></p>\n", file.url];
    }
    NSString *content = [NSString stringWithFormat:@"%@<p>%@</p><p>需要%d人，报酬：%@</p>", images, self.needItem[@"details"], [self.needItem[@"numOfPeople"] intValue], self.needItem[@"payment"]];
    temp = [temp stringByReplacingOccurrencesOfString:@"${title}"
                                           withString:title];
    temp = [temp stringByReplacingOccurrencesOfString:@"${content}"
                                           withString:content];
    return temp;
}

- (void)setNeedItem:(AVObject *)needItem
{
    if (_needItem != needItem) {
        _needItem = needItem;
        if (self.isViewLoaded) {
            [self.webView loadHTMLString:[self buildHTMLFromTemplate]
                                 baseURL:nil];
        }
    }
}

@end
