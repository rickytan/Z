//
//  ZHomeViewController.m
//  ZFreshman
//
//  Created by ricky on 14-2-12.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZHomeViewController.h"
#import "UIColor+RExtension.h"

static NSString *cellColors[] = {@"#866fd7", @"#3cc", @"#086ca2", @"#ffd200", @"#00a779", @"#c561d3", @"#274e70", @"#ff7373"};
static NSString *cellTitles[] = {@"专业简介", @"新生宝典", @"校园地图", @"社团组织"};

@interface ZHomeItemCell : UICollectionViewCell
@property (nonatomic, assign) IBOutlet UILabel *textLabel;
@end

@implementation ZHomeItemCell
@end

@interface ZHomeViewController ()

@end

@implementation ZHomeViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return sizeof(cellTitles) / sizeof(NSString *);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZHomeItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemCell"
                                                                           forIndexPath:indexPath];
    NSInteger count = sizeof(cellColors) / sizeof(NSString *);
    cell.backgroundColor = [UIColor colorWithHexString:cellColors[indexPath.row % count]];
    cell.textLabel.text = cellTitles[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath
                                   animated:YES];

}

@end
