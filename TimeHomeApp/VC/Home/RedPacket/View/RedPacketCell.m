//
//  RedPacketCell.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/11/2.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RedPacketCell.h"

@implementation RedPacketCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _iconImageView.layer.cornerRadius = 40/2;
    _iconImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
