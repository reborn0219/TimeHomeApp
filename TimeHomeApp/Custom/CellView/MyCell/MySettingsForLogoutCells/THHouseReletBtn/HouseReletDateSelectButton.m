//
//  HouseReletDateSelectButton.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "HouseReletDateSelectButton.h"

@interface HouseReletDateSelectButton ()

@property (nonatomic, strong) UILabel *leftLabel;

@end

@implementation HouseReletDateSelectButton


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    
    _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 85, 35)];
    _leftLabel.font = [UIFont systemFontOfSize:16];
    _leftLabel.textColor = TITLE_TEXT_COLOR;
    _leftLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_leftLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(_leftLabel.frame.size.width+2, 8, 1, 35-16)];
    line.backgroundColor = TEXT_COLOR;
    [self addSubview:line];
    
    _dateLabel = [[UILabel alloc]init];
    _dateLabel.textColor = TEXT_COLOR;
    _dateLabel.font = DEFAULT_FONT(14);
    [self addSubview:_dateLabel];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line).offset(20);
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
}
- (void)setDateStyle:(NSInteger)dateStyle {
    _dateStyle = dateStyle;
    
    switch (_dateStyle) {
        case TextStyleBeginDate:
        {
            _leftLabel.text = @"开始日期";
        }
            break;
        case TextStyleEndDate:
        {
            _leftLabel.text = @"结束日期";
        }
            break;
        default:
            break;
    }
    
}

@end
