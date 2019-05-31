//
//  L_MyGivenPeopleListTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_MyGivenPeopleListTVC.h"

@implementation L_MyGivenPeopleListTVC

- (void)setModel:(L_MyFollowersModel *)model {
    
    _model = model;
    /** 头像 */
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.userpicurl] placeholderImage:kHeaderPlaceHolder];
    /** 昵称 */
    _nickNameLabel.text = [XYString IsNotNull:model.nickname];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.backgroundColor = BLACKGROUND_COLOR;
    self.contentView.backgroundColor = BLACKGROUND_COLOR;
    
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 22.f;
    
    _bottomLineView.hidden = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
