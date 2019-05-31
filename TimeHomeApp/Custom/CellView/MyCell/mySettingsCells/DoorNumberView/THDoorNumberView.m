//
//  THDoorNumberView.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THDoorNumberView.h"

@interface THDoorNumberView ()



@end

@implementation THDoorNumberView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        [self setUp];
    
    }
    return self;
}

- (void)setUp {
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(WidthSpace(30), WidthSpace(45), 200, 20)];
//    _titleLabel.text = @"输入您家的门牌号信息";
    _titleLabel.font = DEFAULT_FONT(16);
    _titleLabel.textColor = TITLE_TEXT_COLOR;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_titleLabel];
    
    
    UIView *view = [[UIView alloc]init];
    [self addSubview:view];
    view.layer.borderColor = LINE_COLOR.CGColor;
    view.layer.borderWidth = 1.f;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(WidthSpace(30.f));
        make.right.equalTo(self).offset(-WidthSpace(30.f));
        make.top.equalTo(_titleLabel.mas_bottom).offset(WidthSpace(30));
        make.height.equalTo(@35);
    }];
    
    _doorNumTF = [[CustomTextFIeld alloc]init];
    _doorNumTF.font = DEFAULT_FONT(16);
    _doorNumTF.enablesReturnKeyAutomatically = YES;
    _doorNumTF.clearButtonMode = UITextFieldViewModeAlways;
    [view addSubview:_doorNumTF];
    [_doorNumTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10.f);
        make.right.equalTo(view).offset(-10);
        make.top.equalTo(view);
        make.bottom.equalTo(view);
    }];
    
    UIView *line = [[UIView alloc]init];
    [self addSubview:line];
    line.backgroundColor = LINE_COLOR;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(WidthSpace(30.f));
        make.right.equalTo(self).offset(-WidthSpace(30.f));
        make.top.equalTo(view.mas_bottom).offset(WidthSpace(50));
        make.height.equalTo(@1);
    }];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"显示在我的个人资料中";
    label2.font = DEFAULT_FONT(16);
    label2.textColor = TITLE_TEXT_COLOR;
    label2.textAlignment = NSTextAlignmentLeft;
    [self addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).offset(WidthSpace(30.f));
        make.width.equalTo(@200);
        make.top.equalTo(line);
        make.bottom.equalTo(self);
        
    }];

    _switchButton = [[UISwitch alloc] init];
//    [_switchButton setOn:NO];
    _switchButton.onTintColor = kNewRedColor;
    [_switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_switchButton];
    [_switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-WidthSpace(30.f));
        make.centerY.equalTo(label2.mas_centerY);
    }];
}

- (void)switchAction:(UISwitch *)switchButton {
    
    if (self.switchButtonCallBack) {
        self.switchButtonCallBack(switchButton.isOn);
    }
    
}


@end
