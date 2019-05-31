//
//  L_GarageTimeSetTVC1.h
//  TimeHomeApp
//
//  Created by 世博 on 2016/12/28.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SwitchOnCallBack)(BOOL isOn);
@interface L_GarageTimeSetTVC1 : UITableViewCell


/**
 开关回调
 */
@property (nonatomic, copy) SwitchOnCallBack switchOnCallBack;
/**
 左边标题
 */
@property (weak, nonatomic) IBOutlet UILabel *leftTitle_Label;

/**
 右边开关
 */
@property (weak, nonatomic) IBOutlet UISwitch *right_Switch;

@end
