//
//  Telephone.h
//  iZJU
//
//  Created by ricky on 12-12-14.
//
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

@interface PhoneItem : NSObject
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger pID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign, getter = isLeaf) BOOL leaf;
@property (nonatomic, assign) BOOL hasChild;
@property (nonatomic, strong) NSArray *numbers;
@end

@interface Telephone : UITableViewController
+ (NSString*)telephoneDBPath;
@end
