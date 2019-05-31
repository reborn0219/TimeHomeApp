//
//  BindingCarVC.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/7/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  绑定设备
 **/

#import "BaseViewController.h"

@interface BindingCarVC : THBaseViewController

//车牌号
@property (weak, nonatomic) IBOutlet UIView *scaningView;
@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
//别名
@property (weak, nonatomic) IBOutlet UILabel *carOtherName;

//第一个输入框
@property (weak, nonatomic) IBOutlet UITextField *firstTX;

//第二个输入框后的按钮
@property (weak, nonatomic) IBOutlet UIButton *downButton;


//绑定按钮
@property (weak, nonatomic) IBOutlet UIButton *bindButton;

@property (weak, nonatomic) IBOutlet UIView *firstView;

@property (weak, nonatomic) IBOutlet UIView *secondBgView;

@property (nonatomic,copy)NSString *carOtherNameStr;
@property (nonatomic,copy)NSString *carNameStr;
@property (nonatomic,copy)NSString *uCarID;
@end
