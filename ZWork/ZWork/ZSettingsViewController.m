//
//  ZSettingsViewController.m
//  ZWork
//
//  Created by ricky on 14-3-22.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZSettingsViewController.h"
#import "RTSiderViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <SDWebImage/UIButton+WebCache.h>

@interface ZSettingsCell : UITableViewCell
@end

@implementation ZSettingsCell

- (void)awakeFromNib
{
    self.backgroundView = [[UIView alloc] init];
    self.selectedBackgroundView = [[UIView alloc] init];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor lightGrayColor] set];
    
    if (self.isHighlighted) {
        CGContextFillRect(context, rect);
    }
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, rect.size.width, 0);
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextDrawPath(context, kCGPathStroke);
}

@end

@interface ZSettingsViewController ()
@property (nonatomic, assign) IBOutlet UIButton * headButton;
- (IBAction)onLogout:(id)sender;
@end

@implementation ZSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([AVUser currentUser].isAuthenticated) {
        [self.headButton setImageWithURL:[NSURL URLWithString:[[AVUser currentUser] objectForKey:@"avatar"]]
                                forState:UIControlStateNormal
                        placeholderImage:[UIImage imageNamed:@"header.png"]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogout:(id)sender
{
    [AVUser logOut];
//    [self.navigationController popViewControllerAnimated:YES];
    [self.siderViewController slideToMiddleAnimated:YES];
}

#pragma mark - Table view data source

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
