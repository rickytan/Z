//
//  ZImageListCell.m
//  ZFreshman
//
//  Created by ricky on 14-2-13.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZImageListCell.h"

@implementation ZImageListCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10, 10, 84, self.contentView.bounds.size.height - 20);
    CGRect rect = self.textLabel.frame;
    rect.origin.x = CGRectGetMaxX(self.imageView.frame) + 8;
    rect.size.width = MIN(rect.size.width, CGRectGetWidth(self.contentView.bounds) - rect.origin.x);
    self.textLabel.frame = rect;
}

@end
