//
//  ZHomeViewController.m
//  ZFreshman
//
//  Created by ricky on 14-2-12.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZHomeViewController.h"
#import "UIColor+RExtension.h"
#import <MediaPlayer/MediaPlayer.h>

static NSString *cellTitles[] = {@"专业简介", @"新生宝典", @"校园地图", @"社团组织", @"浙大写意"};
static NSString *cellSegues[] = {@"MajorIntro", @"Question", @"Map", @"League", @"playVideo"};

@interface ZHomeItemCell : UICollectionViewCell
@property (nonatomic, assign) IBOutlet UILabel *textLabel;
@end

@implementation ZHomeItemCell

- (void)didMoveToSuperview
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    anim.toValue = [NSNumber numberWithFloat:1.1];
    anim.duration = 0.2;
    anim.repeatCount = 2.0;
    anim.autoreverses = YES;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:anim
                      forKey:nil];

    anim = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    anim.toValue = [NSNumber numberWithFloat:1.1];
    anim.duration = 0.2;
    anim.timeOffset = 0.1;
    anim.repeatCount = 2.0;
    anim.autoreverses = YES;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:anim
                      forKey:nil];
}

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

- (void)playVideo
{
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:@"http://61.160.198.203/youku/6973F5A8BD94E832224DA75631/03002001004DDA70FF8F9503802B8F42EB7811-91E6-C741-20E3-E1F7A89E110B.mp4"]];
    [self presentMoviePlayerViewControllerAnimated:player];
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
    cell.backgroundColor = [UIColor colorForIndex:indexPath.row];
    cell.textLabel.text = cellTitles[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath
                                   animated:YES];
    if (cellSegues[indexPath.row].length > 0) {
        @try {
            [self performSegueWithIdentifier:cellSegues[indexPath.row]
                                      sender:self];
        }
        @catch (NSException *exception) {
            SEL action = NSSelectorFromString(cellSegues[indexPath.row]);
            if ([self respondsToSelector:action])
                [self performSelector:action];
        }
    }
}

@end
