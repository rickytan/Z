//
//  ZMasterViewController.h
//  ZFreshman
//
//  Created by ricky on 13-12-21.
//  Copyright (c) 2013年 Ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZDetailViewController;

@interface ZMasterViewController : UITableViewController

@property (strong, nonatomic) ZDetailViewController *detailViewController;

@end
