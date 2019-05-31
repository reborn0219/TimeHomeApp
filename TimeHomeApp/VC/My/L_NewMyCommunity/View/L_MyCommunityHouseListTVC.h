//
//  L_MyCommunityHouseListTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/30.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OwnerResidence.h"

typedef void(^ButtonTouchBlock)(NSInteger index);
@interface L_MyCommunityHouseListTVC : UITableViewCell

@property (nonatomic, copy) ButtonTouchBlock buttonTouchBlock;

@property (nonatomic, strong) OwnerResidence *residenceModel;

/**
 type 1.租赁中 2.出租 3.已出租 4.认证中 5.认证失败
 */
@property (nonatomic, assign) NSInteger type;

/**
 社区名称
 */
@property (weak, nonatomic) IBOutlet UILabel *communityNameLabel;

/**
 租赁状态
 */
@property (weak, nonatomic) IBOutlet UILabel *rentStateLabel;

/**
 房产地址
 */
@property (weak, nonatomic) IBOutlet UILabel *houseAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel1;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel2;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel3;

/**
 昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

/**
 租期至
 */
@property (weak, nonatomic) IBOutlet UILabel *rentToDateLabel;

/**
 电话
 */
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;

/**
 租期
 */
@property (weak, nonatomic) IBOutlet UILabel *rentDateRangeLabel;

/**
 移除
 */
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

/**
 续租
 */
@property (weak, nonatomic) IBOutlet UIButton *rentButton;

/**
 下方分割线
 */
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end
