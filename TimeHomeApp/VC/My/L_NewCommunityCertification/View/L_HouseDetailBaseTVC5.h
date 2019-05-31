//
//  L_HouseDetailBaseTVC5.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/8.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_HouseInfoModel.h"

@interface L_HouseDetailBaseTVC5 : UITableViewCell

/**
 社区名称
 */
@property (weak, nonatomic) IBOutlet UILabel *authorizationStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *communityName_Label;

/**
 地址
 */
@property (weak, nonatomic) IBOutlet UILabel *address_Label;

/**
 房屋
 */
@property (weak, nonatomic) IBOutlet UILabel *house_Label;

/**
 授权方式
 */
@property (weak, nonatomic) IBOutlet UILabel *authoryStyle_Label;

/**
 授权时间
 */
@property (weak, nonatomic) IBOutlet UILabel *time_Label;

/**
 授权人
 */
@property (weak, nonatomic) IBOutlet UILabel *people_Label;

/**
 手机号码
 */
@property (weak, nonatomic) IBOutlet UILabel *phone_Label;


@property (nonatomic, strong) L_HouseInfoModel *model;

/**
 出租 18+30 共享 18
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;

/**
 出租日期标题
 */
@property (weak, nonatomic) IBOutlet UILabel *chuzuTitle_Label;

/**
 出租日期
 */
@property (weak, nonatomic) IBOutlet UILabel *chuzuDate_Label;


@end
