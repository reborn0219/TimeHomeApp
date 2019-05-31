//
//  YYTopCheckView.m
//  TimeHomeApp
//
//  Created by 世博 on 16/8/11.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "YYTopCheckView.h"

@interface YYTopCheckView ()


@end

@implementation YYTopCheckView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kNewRedColor;
        [self setup];
    }
    return self;
}

- (void)setup {
 
    _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self addSubview:_checkButton];
    
    _checkButton.frame = CGRectMake(SCREEN_WIDTH/2.f - WidthSpace(236)/2.f, WidthSpace(64), WidthSpace(236), WidthSpace(236));
    
    _checkButton.backgroundColor = CLEARCOLOR;
    
    _checkButton.layer.cornerRadius = WidthSpace(236)/2;
    _checkButton.layer.borderWidth = 1.f;
    _checkButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [_checkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _checkButton.titleLabel.font = DEFAULT_BOLDFONT(15);
    [_checkButton setTitle:@"开始检测" forState:UIControlStateNormal];
    _checkButton.selected = NO;
    
    [_checkButton addTarget:self action:@selector(checkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _carNumbel_Label = [[UILabel alloc]init];
    _carNumbel_Label.font = DEFAULT_BOLDFONT(15);
    _carNumbel_Label.textColor = [UIColor whiteColor];
    [self addSubview:_carNumbel_Label];
    [_carNumbel_Label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_checkButton.mas_bottom).offset(WidthSpace(22));
        make.centerX.equalTo(self.mas_centerX);
        
    }];
    
    _check_Label = [[UILabel alloc] init];
    [self addSubview:_check_Label];
    _check_Label.text = @"检测中......";
    _check_Label.textColor = [UIColor whiteColor];

    if (SCREEN_WIDTH == 320) {
        _check_Label.font = DEFAULT_BOLDFONT(13);

    }else {
        _check_Label.font = DEFAULT_BOLDFONT(15);

    }
    
    _check_Label.hidden = YES;
    [_check_Label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).offset(WidthSpace(55));
        make.top.equalTo(self).offset(WidthSpace(40));
        
    }];
    

    _rightBottom_Label = [[UILabel alloc] init];
    [self addSubview:_rightBottom_Label];
    if (SCREEN_WIDTH == 320) {
        _rightBottom_Label.font = DEFAULT_BOLDFONT(12);
    }else {
        _rightBottom_Label.font = DEFAULT_BOLDFONT(15);
    }
    _rightBottom_Label.textColor = [UIColor whiteColor];
//    _rightBottom_Label.hidden = YES;
    _rightBottom_Label.text = @"请以待机检查为准";
    _rightBottom_Label.textAlignment = NSTextAlignmentRight;
    [_rightBottom_Label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(_carNumbel_Label.mas_centerY);
        make.right.equalTo(self).offset(-10);
        make.left.equalTo(_carNumbel_Label.mas_right).offset(5);
    }];
    
    
    _rightTop_Label = [[UILabel alloc] init];
    [self addSubview:_rightTop_Label];
    if (SCREEN_WIDTH == 320) {
        _rightTop_Label.font = DEFAULT_BOLDFONT(12);
    }else {
        _rightTop_Label.font = DEFAULT_BOLDFONT(15);
    }
    _rightTop_Label.textColor = [UIColor whiteColor];
    _rightTop_Label.text = @"已检测数据项";
    _rightTop_Label.hidden = YES;
    _rightTop_Label.textAlignment = NSTextAlignmentRight;
    [_rightTop_Label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(_rightBottom_Label.mas_right);
        make.bottom.equalTo(_rightBottom_Label.mas_top).offset(-WidthSpace(12));
        
    }];
    
    
}

/**
 *  开始检测点击
 *
 *  @param button
 */
- (void)checkButtonClick:(UIButton *)button {
    
    if (button.selected) {
        return;
    }
    
    button.selected = YES;
    
    if (self.checkButtonBlock) {
        self.checkButtonBlock(button);
    }
    
}


@end
