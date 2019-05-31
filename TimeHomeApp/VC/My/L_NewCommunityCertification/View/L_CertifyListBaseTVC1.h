//
//  L_CertifyListBaseTVC1.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/4.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_ResiListModel.h"

@interface L_CertifyListBaseTVC1 : UITableViewCell

/**
 姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *name_Label;

/**
 电话
 */
@property (weak, nonatomic) IBOutlet UILabel *phone_Label;

/**
 社区
 */
@property (weak, nonatomic) IBOutlet UILabel *community_Label;

/**
 房间
 */
@property (weak, nonatomic) IBOutlet UILabel *house_Label;

@property (nonatomic, strong) L_ResiListModel *model;

@end
