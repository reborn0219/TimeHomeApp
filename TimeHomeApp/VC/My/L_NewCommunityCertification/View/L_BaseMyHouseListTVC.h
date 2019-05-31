//
//  L_BaseMyHouseListTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/4.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_MyHouseListModel.h"
#import "PANewHouseModel.h"

@interface L_BaseMyHouseListTVC : UITableViewCell

/**
 社区名称
 */
@property (weak, nonatomic) IBOutlet UILabel *community_Label;

/**
 去授权按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *gotoAuthory_Btn;

/**
 地址
 */
@property (weak, nonatomic) IBOutlet UILabel *address_Label;

/**
 房屋
 */
@property (weak, nonatomic) IBOutlet UILabel *house_Label;

/**
 认证身份
 */
@property (weak, nonatomic) IBOutlet UILabel *authoryState_Label;
/**
 认证身份标题
 */
@property (weak, nonatomic) IBOutlet UILabel *authoryStateTitle_Label;

/**
 图片状态  审核中 已通过认证 无 未通过 已被授权
 */
@property (weak, nonatomic) IBOutlet UIImageView *rightState_ImageView;

@property (nonatomic, copy) ViewsEventBlock cellBtnDidClickBlock;
@property (nonatomic, strong) L_MyHouseListModel *model;

@property (nonatomic, assign) CertificationType certificationType;

@end



