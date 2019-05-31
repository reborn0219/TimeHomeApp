//
//  L_CurrentCommunityTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/29.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_CurrentCommunityTVC.h"

@implementation L_CurrentCommunityTVC

- (void)setUserCommunityModel:(UserCommunity *)userCommunityModel {
    
    _userCommunityModel = userCommunityModel;
    
    _leftTopLabel.text = [XYString IsNotNull:userCommunityModel.name];
    _leftBottomLabel.text = [XYString IsNotNull:userCommunityModel.address];
    
    /**
     *  0 认证中 1 认证成功 2 认证失败
     */
//    @property (nonatomic, strong) NSString * certstate;
    if (userCommunityModel.certstate.integerValue == 0) {
        _rightBottomLabel.text = @"未认证";
        _rightBottomImg.image = [UIImage imageNamed:@"业主认证-社区认证--未认证图标"];
    }else {
        _rightBottomLabel.text = @"已认证为业主";
        _rightBottomImg.image = [UIImage imageNamed:@"业主认证-社区认证--已认证业主图标"];
    }
    
    [self layoutIfNeeded];
    
    CGFloat height = CGRectGetMaxY(_bottomLineView.frame);
    
    userCommunityModel.height = height;
    
}

//- (void)setUserCertlistModel:(UserCertlistModel *)userCertlistModel {
//    
//    _userCertlistModel = userCertlistModel;
//    
//    _leftTopLabel.text = [XYString IsNotNull:userCertlistModel.name];
//    _leftBottomLabel.text = [XYString IsNotNull:userCertlistModel.address];
//    
//    /**
//     *  0 认证中 1 认证成功 2 认证失败
//     */
//    //    @property (nonatomic, strong) NSString * certstate;
//    if (userCertlistModel.certstate.integerValue == 0) {
//        _rightBottomLabel.text = @"未认证";
//        _rightBottomImg.image = [UIImage imageNamed:@"业主认证-社区认证--未认证图标"];
//    }else {
//        _rightBottomLabel.text = @"已认证为业主";
//        _rightBottomImg.image = [UIImage imageNamed:@"业主认证-社区认证--已认证业主图标"];
//    }
//    
//    [self layoutIfNeeded];
//    
//    CGFloat height = CGRectGetMaxY(_rightBottomLabel.frame);
//    
//    userCertlistModel.height = height + 20;
//}

- (void)awakeFromNib {
    [super awakeFromNib];

    _bottomLineView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
