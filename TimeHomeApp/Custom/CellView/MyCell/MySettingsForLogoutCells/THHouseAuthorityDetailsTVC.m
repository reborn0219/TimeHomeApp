//
//  THHouseAuthorityDetailsTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THHouseAuthorityDetailsTVC.h"

@implementation THHouseAuthorityDetailsTVC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    
    
    _rightImage= [[UIImageView alloc]init];
//    _rightImage.image = [UIImage imageNamed:@"我的_右箭头"];
    [self.contentView addSubview:_rightImage];
    [_rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@13);
        make.height.equalTo(@13);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    
    _rightLabel = [[UILabel alloc]init];
    _rightLabel.textAlignment = NSTextAlignmentRight;
    _rightLabel.textColor = TEXT_COLOR;
    _rightLabel.font = DEFAULT_FONT(14);
    [self.contentView addSubview:_rightLabel];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_rightImage).offset(-20);
        make.width.equalTo(@80);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    
    _leftLabel = [[UILabel alloc]init];
    _leftLabel.textColor = TITLE_TEXT_COLOR;
    _leftLabel.font = DEFAULT_FONT(14);
    [self.contentView addSubview:_leftLabel];
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(_rightLabel.mas_left).offset(-20);
    }];
    
}

@end
