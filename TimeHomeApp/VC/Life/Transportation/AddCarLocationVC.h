//
//  AddCarLocationVC.h
//  TimeHomeApp
//
//  Created by us on 16/3/14.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "CarListModel.h"

@interface AddCarLocationVC : THBaseViewController
////设备IMEI号
@property (weak, nonatomic) IBOutlet UITextField *TF_IMEI;
///车牌
@property (weak, nonatomic) IBOutlet UITextField *TF_CarNum;
///编辑时的数据
@property(strong,nonatomic) CarListModel * carModle;
@end
