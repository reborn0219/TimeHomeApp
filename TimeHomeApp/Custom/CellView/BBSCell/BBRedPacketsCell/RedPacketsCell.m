//
//  RedPacketsCell.m
//  TimeHomeApp
//
//  Created by 优思科技 on 17/2/13.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.

#import "RedPacketsCell.h"

@implementation RedPacketsCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _headerImageV.layer.cornerRadius = 20.0f;
    _headerImageV.layer.masksToBounds = YES;
    
}

#pragma mark - 红包手气是否最佳
-(void)isTheBest:(BOOL)isBest
{
    if (isBest) {
        _moneyLb_content.constant = -10;

    }else
    {
        _moneyLb_content.constant = 0;

    }
    [_huangguanImgV setHidden:!isBest];
    [_bestLb setHidden:!isBest];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
