//
//  ZDetailViewController.h
//  ZFreshman
//
//  Created by ricky on 13-12-21.
//  Copyright (c) 2013年 Ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
