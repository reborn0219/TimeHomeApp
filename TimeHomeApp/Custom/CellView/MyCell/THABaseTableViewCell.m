//
//  THABaseTableViewCell.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THABaseTableViewCell.h"

@implementation THABaseTableViewCell

- (void)setFrame:(CGRect)frame
{
    frame.origin.x += 7;
    frame.size.width -= 14;
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
