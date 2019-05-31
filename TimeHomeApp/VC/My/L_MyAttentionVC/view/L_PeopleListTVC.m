//
//  L_PeopleListTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_PeopleListTVC.h"

@implementation L_PeopleListTVC

- (void)tapHeadImage:(UITapGestureRecognizer *)sender {
    
//    NSLog(@"点击头像");
    if (self.headImageViewDidTouchBlock) {
        self.headImageViewDidTouchBlock();
    }
}


- (void)setModel:(L_MyFollowersModel *)model {
    _model = model;
    
    /** 头像 */
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.userpicurl] placeholderImage:kHeaderPlaceHolder];
    /** 昵称 */
    _nickNameLabel.text = [XYString IsNotNull:model.nickname];
    
    /** 性别 */
    if ([model.sex isEqualToString:@"1"]) {
        //男
        _sexBgView.backgroundColor = MAN_COLOR;
        _sexImageView.image = [UIImage imageNamed:@"邻圈_男"];
    }else {
        _sexBgView.backgroundColor = WOMEN_COLOR;
        _sexImageView.image = [UIImage imageNamed:@"邻圈_女"];
    }
    
    /** 年龄 */
    _ageLabel.text = [XYString IsNotNull:model.age];
    
}

/**
 关注，取消关注
 */
- (IBAction)attentionButtonDidClick:(UIButton *)sender {
    
    if (self.attentionButtonDidTouchBlock) {
        self.attentionButtonDidTouchBlock();
    }

}

- (void)awakeFromNib {
    [super awakeFromNib];

    _attentionButton.layer.borderWidth = 1;
    _attentionButton.layer.cornerRadius = 10;

    _sexBgView.layer.cornerRadius = 8;
    
    _attentionButton.layer.borderColor = TITLE_TEXT_COLOR.CGColor;
    [_attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
    [_attentionButton setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
    
    _headImageView.layer.cornerRadius = 22.f;
    _headImageView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadImage:)];
    _headImageView.userInteractionEnabled = YES;
    [_headImageView addGestureRecognizer:tap];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
