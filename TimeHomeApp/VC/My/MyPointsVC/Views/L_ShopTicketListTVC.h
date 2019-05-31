//
//  L_ShopTicketListTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/7/18.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_CouponListModel.h"

@interface L_ShopTicketListTVC : UITableViewCell

@property (nonatomic, copy) ViewsEventBlock buttonsCallBack;

/**
 名称
 */
@property (weak, nonatomic) IBOutlet UILabel *name_Label;

/**
 有效期
 */
@property (weak, nonatomic) IBOutlet UILabel *time_Label;

/**
 去使用按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *use_Button;

@property (nonatomic, strong) L_CouponListModel *model;

@end
