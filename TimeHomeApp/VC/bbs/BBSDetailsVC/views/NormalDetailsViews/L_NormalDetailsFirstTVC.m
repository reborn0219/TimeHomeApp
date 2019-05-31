//
//  L_NormalDetailsFirstTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NormalDetailsFirstTVC.h"

@implementation L_NormalDetailsFirstTVC

- (void)setModel:(L_NormalInfoModel *)model {
    _model = model;
    
    [_headerButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.userpicurl] forState:UIControlStateNormal placeholderImage:kHeaderPlaceHolder];
    
    _nickNameLabel.text = [XYString IsNotNull:model.nickname];
    
    if ([model.sex isEqualToString:@"2"]) {
        _sexBgView.backgroundColor = WOMEN_COLOR;
        _sexBgImageView.image = [UIImage imageNamed:@"邻圈_女"];

    }else {

        _sexBgView.backgroundColor = MAN_COLOR;
        _sexBgImageView.image = [UIImage imageNamed:@"邻圈_男"];
    }
    
    //年龄
    if (![XYString isBlankString:model.age]) {
        _ageLabel.text = [NSString stringWithFormat:@"%@",model.age];
    }else {
        _ageLabel.text = @"0";
    }
    
    _timeLabel.text = [XYString IsNotNull:model.releasetime];
    
    if ([model.isme isEqualToString:@"0"]) {
        
        _addAttentionButton.hidden = NO;
        if ([model.isuserfollow isEqualToString:@"0"]) {
            
            [_addAttentionButton setTitleColor:kNewRedColor forState:UIControlStateNormal];
            _addAttentionButton.layer.borderColor = kNewRedColor.CGColor;
            [_addAttentionButton setTitle:@"+  关注" forState:UIControlStateNormal];
            
        }else {
            
            [_addAttentionButton setTitleColor:NEW_GRAY_COLOR forState:UIControlStateNormal];
            _addAttentionButton.layer.borderColor = NEW_GRAY_COLOR.CGColor;
            [_addAttentionButton setTitle:@"已关注" forState:UIControlStateNormal];

        }
        
    }else {
        
        _addAttentionButton.hidden = YES;
        
    }
    
}

- (IBAction)allButtonsDidTouch:(UIButton *)sender {
    
    //1.头像点击 2.加关注点击
    if (self.allButtonsDidTouchBlock) {
        self.allButtonsDidTouchBlock(sender.tag);
    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    _addAttentionButton.hidden = YES;
    _nickNameLabel.text = @"";
    _ageLabel.text = @"";
    _timeLabel.text = @"";

    _headerButton.layer.cornerRadius = 22;
    [_headerButton setBackgroundImage:kHeaderPlaceHolder forState:UIControlStateNormal];
    _headerButton.clipsToBounds = YES;
    
    _sexBgView.layer.cornerRadius = 8;
    _sexBgView.clipsToBounds = YES;
    
    _addAttentionButton.layer.borderWidth = 2;
    _addAttentionButton.layer.borderColor = kNewRedColor.CGColor;
    _addAttentionButton.layer.cornerRadius = 13;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
