//
//  ZHelpDetailViewController.m
//  ZWork
//
//  Created by ricky on 14-3-24.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZHelpDetailViewController.h"

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
    return nil;
}

@end
