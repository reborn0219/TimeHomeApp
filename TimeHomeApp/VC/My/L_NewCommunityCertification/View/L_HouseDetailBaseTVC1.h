//
//  L_HouseDetailBaseTVC1.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_HouseInfoModel.h"

@interface L_HouseDetailBaseTVC1 : UITableViewCell

/**
 认证状态
 */
@property (weak, nonatomic) IBOutlet UIImageView *state_ImageView;


/**
 小区名称
 */
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
 身份
 */
@property (weak, nonatomic) IBOutlet UILabel *state_Label;

/**
 底部左标题
 */
@property (weak, nonatomic) IBOutlet UILabel *bottomLeftTitle_Label;

/**
 底部右标题
 */
@property (weak, nonatomic) IBOutlet UILabel *bottomRightTitle_Label;

@property (nonatomic, strong) L_HouseInfoModel *model;
@property (nonatomic, assign) CertificationType certificationType;

@end
