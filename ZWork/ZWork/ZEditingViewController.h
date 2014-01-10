//
//  ZJUEditingViewController.h
//  iZJU
//
//  Created by ricky on 13-6-26.
//  Copyright (c) 2013年 iZJU Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZEditingViewController;

@protocol ZEditingViewControllerDelegate <NSObject>
@optional
- (void)editingViewController:(ZEditingViewController*)controller didEndEditingWithText:(NSString*)text;
- (void)editingViewControllerDidCancelEditing:(ZEditingViewController *)controller;

@end

typedef enum {
    EditingTypeTextField,
    EditingTypeTextView,
    EditingTypePhone,
    EditingTypeOptions,
    EditingTypeDate,
    EditingTypeDateTime
} EditingType;

@interface ZEditingViewController : UITableViewController
@property (nonatomic, assign) id<ZEditingViewControllerDelegate> delegate;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, retain, readwrite) NSString *string;
@property (nonatomic, assign) EditingType type;
@property (nonatomic, retain) NSArray *options;     // Must set for EditingTypeOptions
@end
