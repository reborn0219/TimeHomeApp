//
//  PersonalNoticeCell.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PersonalNoticeCell.h"

@implementation PersonalNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
    self.leftImgV.layer.cornerRadius = 6.5;
    self.leftImgV.layer.borderWidth = 2;
    self.leftImgV.layer.borderColor = TEXT_COLOR.CGColor;
    [self.leftImgV setBackgroundColor:[UIColor whiteColor]];
    
    _rigntImage = [[UIImageView alloc]init];
    [self.contentView addSubview:_rigntImage];
    [_rigntImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@25);
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(_titleLb.mas_top);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
