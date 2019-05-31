//
//  L_MyHeaderInfoTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/14.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_MyHeaderInfoTVC.h"

@implementation L_MyHeaderInfoTVC


/**
 查看等级
 */
- (IBAction)rankButtonDidTouch:(UIButton *)sender {
    
    NSLog(@"查看等级");
    if (self.randButtonDidClick) {
        self.randButtonDidClick();
    }
}

/**
 签到
 */
- (IBAction)signonClick:(id)sender {
    NSLog(@"签到");
    if (self.signOnBlock) {
        self.signOnBlock();
    }
}

//传个人信息model
- (void)setModel:(UserData *)model {
    _model = model;
    
    //头像
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.userpic] placeholderImage:kHeaderPlaceHolder];
    
    //昵称
    if (![XYString isBlankString:model.nickname]) {
        _nameLabel.text = model.nickname;
    }else {
        _nameLabel.text =@"";
    }
    
    //电话
    if (![XYString isBlankString:model.phone]) {
        _phoneLabel.text = model.phone;
    }else {
        _phoneLabel.text = @"";
    }
    
    //等级
    if (![XYString isBlankString:model.level]) {
        _rankLabel.text = [NSString stringWithFormat:@"%@",model.level];
    }else {
        _rankLabel.text = @"0";
    }
    
    //性别
    if ([model.sex intValue] == 1) {
        //男
        _sexImageView.image = [UIImage imageNamed:@"邻圈_男"];
        _ageBackgroundView.backgroundColor = MAN_COLOR;
        
    }else if ([model.sex intValue] == 2) {
        //女
        _sexImageView.image = [UIImage imageNamed:@"邻圈_女"];
        _ageBackgroundView.backgroundColor = WOMEN_COLOR;
        
    }else {
        //其他
//        _sexImageView.image = [UIImage imageNamed:@""];
//        _ageBackgroundView.backgroundColor = [UIColor whiteColor];
        _sexImageView.image = [UIImage imageNamed:@"邻圈_男"];
        _ageBackgroundView.backgroundColor = MAN_COLOR;
    }
    
    //年龄
    if (![XYString isBlankString:model.age]) {
        _ageLabel.text = [NSString stringWithFormat:@"%@",model.age];
    }else {
        _ageLabel.text = @"0";
    }
    
    //业主认证，实名认证--------------------------------------------
    
    if (![XYString isBlankString:model.isowner]) {
        if ([model.isowner boolValue]) {
            _firstImageView.image = [UIImage imageNamed:@"我的-首页-业主认证图标"];
        }else {
            _firstImageView.image = [UIImage imageNamed:@"我的-首页-业主认证图标-灰"];
        }
    }
    
//    if (![XYString isBlankString:model.isvaverified]) {
//        if ([model.isvaverified boolValue]) {
//            _secondImageView.image = [UIImage imageNamed:@"我的-首页-实名认证图标"];
//        }else {
//            _secondImageView.image = [UIImage imageNamed:@"我的-首页-实名认证图标-灰"];
//        }
//    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _headImageView.layer.cornerRadius = 34.f;
    _headImageView.clipsToBounds = YES;
    
    _ageBackgroundView.layer.cornerRadius = 8.f;
    _ageBackgroundView.clipsToBounds = YES;
    
    if (iPhone4And5) {
        _firstLabel.font = DEFAULT_FONT(12);
        _secondLabel.font = DEFAULT_FONT(12);
    }
    
    _secondLabel.hidden = YES;
    _secondImageView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
