//
//  THInputView.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THInputView.h"

@interface THInputView ()

@property (nonatomic, strong) UIView *borderView;

@end

@implementation THInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _leftTitleLabel = [[UILabel alloc]init];
        _leftTitleLabel.textColor = TITLE_TEXT_COLOR;
        _leftTitleLabel.font = DEFAULT_FONT(16);
        [self addSubview:_leftTitleLabel];
        [_leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.width.equalTo(@(80));
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        _borderView = [[UIView alloc]init];
        [self addSubview:_borderView];
        _borderView.layer.borderColor = LINE_COLOR.CGColor;
        _borderView.layer.borderWidth = 1.f;
        [_borderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_leftTitleLabel.mas_right).offset(5);
            make.right.equalTo(self).offset(-15);
            make.height.equalTo(@35);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        _dateSelectButton = [UIButton buttonWithType: UIButtonTypeCustom];
//        _dateSelectButton.hidden = YES;
        _dateSelectButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_dateSelectButton setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        _dateSelectButton.titleLabel.font = DEFAULT_FONT(14);
        [_borderView addSubview:_dateSelectButton];
        [_dateSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_borderView);
            make.right.equalTo(_borderView);
            make.top.equalTo(_borderView);
            make.bottom.equalTo(_borderView);
        }];
        
        _buttonTitleLabel = [[UILabel alloc]init];
        _buttonTitleLabel.font = DEFAULT_FONT(14);
        _buttonTitleLabel.textColor = TEXT_COLOR;
        [_dateSelectButton addSubview:_buttonTitleLabel];
        [_buttonTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_dateSelectButton).offset(15);
            make.right.equalTo(_dateSelectButton);
            make.top.equalTo(_dateSelectButton);
            make.bottom.equalTo(_dateSelectButton);
        }];
//        [_dateSelectButton addTarget:self action:@selector(dateSelectedClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

//- (void)dateSelectedClick:(UIButton *)button {
//    
//    if (self.dateButtonClickCallBack) {
//        self.dateButtonClickCallBack(button.selected);
//    }
//    
//}

@end
