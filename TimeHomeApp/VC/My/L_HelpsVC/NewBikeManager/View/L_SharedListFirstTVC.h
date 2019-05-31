//
//  L_SharedListFirstTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/22.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_BikeShareInfoModel.h"

typedef void(^DeleteButtonTouchBlock)();

@interface L_SharedListFirstTVC : UITableViewCell

@property (nonatomic, strong) L_BikeShareInfoModel *shareModel;

@property (nonatomic, copy) DeleteButtonTouchBlock deleteButtonTouchBlock;

/**
 共享人名称
 */
@property (weak, nonatomic) IBOutlet UILabel *sharedPeopleNameLabel;

/**
 共享手机号
 */
@property (weak, nonatomic) IBOutlet UILabel *sharedPeoplePhoneLabel;

/**
 发送权限时间
 */
@property (weak, nonatomic) IBOutlet UILabel *sendAuthTimeLabel;

@end
