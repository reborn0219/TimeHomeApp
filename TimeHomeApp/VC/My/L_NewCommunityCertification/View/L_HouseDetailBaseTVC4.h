//
//  L_HouseDetailBaseTVC4.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/8.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_PowerListModel.h"

@interface L_HouseDetailBaseTVC4 : UITableViewCell

/**
 名字
 */
@property (weak, nonatomic) IBOutlet UILabel *name_Label;

/**
 手机号
 */
@property (weak, nonatomic) IBOutlet UILabel *phoneNum_Label;

@property (weak, nonatomic) IBOutlet UIView *secondLine;

/**
 租期
 */
@property (weak, nonatomic) IBOutlet UILabel *rentTime_Label;

@property (nonatomic, strong) L_PowerListModel *model;

@property (nonatomic, copy) ViewsEventBlock selectBlock;

@end
