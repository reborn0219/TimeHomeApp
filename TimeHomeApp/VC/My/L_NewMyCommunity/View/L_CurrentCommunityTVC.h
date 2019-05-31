//
//  L_CurrentCommunityTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/29.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserCommunity.h"
#import "UserCertlistModel.h"

@interface L_CurrentCommunityTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftBottomLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightBottomLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightBottomImg;

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

/**
 当前小区
 */
@property (nonatomic, strong) UserCommunity *userCommunityModel;

/**
 已认证社区
 */
//@property (nonatomic, strong) UserCertlistModel *userCertlistModel;

@end
