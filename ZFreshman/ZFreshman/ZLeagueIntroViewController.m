//
//  ZLeagueIntroViewController.m
//  ZFreshman
//
//  Created by ricky on 14-2-14.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZLeagueIntroViewController.h"

@interface ZLeagueIntroViewController ()
@property (nonatomic, assign) IBOutlet UITextView *textView;
@end

@implementation ZLeagueIntroViewController

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
    self.textView.text = self.text;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setText:(NSString *)text
{
    if (_text != text) {
        _text = text;
        self.textView.text = text;
    }
}

@end
