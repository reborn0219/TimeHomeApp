//
//  THMotifyPwdTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMotifyPwdTVC.h"

@interface THMotifyPwdTVC ()

@property (nonatomic, strong) UIView *bgLineView;

@end

@implementation THMotifyPwdTVC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    _leftImage = [[UIImageView alloc]init];
    [self.contentView addSubview:_leftImage];
    [_leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView).offset(WidthSpace(46));
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        
    }];
    
    _rightLabel = [[UILabel alloc]init];
    _rightLabel.hidden = YES;
    _rightLabel.font = DEFAULT_FONT(14);
    _rightLabel.textColor = TEXT_COLOR;
    [self.contentView addSubview:_rightLabel];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_leftImage.mas_right).offset(12+10);
        make.centerY.equalTo(_leftImage.mas_centerY);
        make.right.equalTo(self.contentView).offset(-WidthSpace(50));
        
    }];
    
    _bgLineView = [[UIView alloc]init];
    [self.contentView addSubview:_bgLineView];
    _bgLineView.layer.borderColor = LINE_COLOR.CGColor;
    _bgLineView.layer.borderWidth = 1.f;
    [_bgLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftImage.mas_right).offset(12);
        make.right.equalTo(self.contentView).offset(-WidthSpace(50));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@35);
    }];
    
    _rightTextField = [[CustomTextFIeld alloc]init];
    _rightTextField.font = DEFAULT_FONT(15);
    _rightTextField.enablesReturnKeyAutomatically = YES;
    _rightTextField.clearButtonMode = UITextFieldViewModeAlways;
//    _rightTextField.delegate = self;
    [_bgLineView addSubview:_rightTextField];
    [_rightTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgLineView).offset(10.f);
        make.right.equalTo(_bgLineView).offset(-10);
        make.top.equalTo(_bgLineView);
        make.bottom.equalTo(_bgLineView);
    }];
    
}

- (void)setRightControlStyle:(RightControlStyle)rightControlStyle {
    
    _rightControlStyle = rightControlStyle;
    
    switch (rightControlStyle) {
        case RightControlStyleLabel:
        {
            _rightLabel.hidden = NO;
            _rightTextField.hidden = YES;
            _bgLineView.hidden = YES;
        }
            break;
        case RightControlStyleTextField:
        {
            _rightLabel.hidden = YES;
            _rightTextField.hidden = NO;
            _bgLineView.hidden = NO;
        }
            break;
        default:
            break;
    }
    
}

@end
