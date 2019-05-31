//
//  YYSelectButton.m
//  TimeHomeApp
//
//  Created by 世博 on 16/7/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "YYSelectButton.h"

@implementation YYSelectButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUp];
        
        
    }
    return self;
}

- (void)setUp {
    
    _leftImageView = [[UIImageView alloc]init];
    [self addSubview:_leftImageView];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).offset(15);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.centerY.equalTo(self.mas_centerY);
        
    }];
    
    _rightLabel = [[UILabel alloc]init];
    [self addSubview:_rightLabel];
    _rightLabel.font = DEFAULT_FONT(16);
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_leftImageView.mas_right).offset(10);
        make.centerY.equalTo(self.mas_centerY);
        
        
    }];
    
}

@end
