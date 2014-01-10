//
//  ZPaymentSettingViewController.h
//  ZWork
//
//  Created by ricky on 14-1-10.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZPaymentSettingViewController;

@protocol ZPaymentSettingDelegate <NSObject>
@optional
- (void)paymentSettingController:(ZPaymentSettingViewController *)controller didEndEditingWithText:(NSString *)text;

@end
@interface ZPaymentSettingViewController : UITableViewController
@property (nonatomic, assign) id<ZPaymentSettingDelegate> delegate;
@end
