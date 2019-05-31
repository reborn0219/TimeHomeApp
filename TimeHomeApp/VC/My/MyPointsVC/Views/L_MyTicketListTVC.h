//
//  L_MyTicketListTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_MyCertificateModel.h"

@interface L_MyTicketListTVC : UITableViewCell

@property (nonatomic, strong) L_MyCertificateModel *model;

/**
 图片宽度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImageViewWidthLayoutConstraint;

/**
 商品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *leftGoodImageView;

/**
 类型名称
 */
@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;

/**
 可用卡券
 */
@property (weak, nonatomic) IBOutlet UILabel *usedTicketLabel;

@end
