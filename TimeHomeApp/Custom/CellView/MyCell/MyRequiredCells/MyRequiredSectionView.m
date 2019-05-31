//
//  MyRequiredSectionView.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MyRequiredSectionView.h"

@implementation MyRequiredSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"状态跟踪";
    label.font = DEFAULT_FONT(16);
    label.textColor = TITLE_TEXT_COLOR;
    label.textAlignment = NSTextAlignmentLeft;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@26);
        
    }];
    
    UIImageView *rightImageView = [[UIImageView alloc]init];
    rightImageView.image = [UIImage imageNamed:@"物业服务_在线报修_状态跟踪"];
    [self addSubview:rightImageView];
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(label.mas_right).offset(5);
        make.centerY.equalTo(label.mas_centerY);
        make.height.equalTo(@16);
        make.width.equalTo(@95);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kNewRedColor;
    [rightImageView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightImageView);
        make.top.equalTo(rightImageView.mas_bottom);
        make.width.equalTo(@20);
        make.height.equalTo(@1);
    }];
    
}

@end
