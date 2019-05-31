//
//  RaiN_AddFamilyVC.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/8/11.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"

@interface RaiN_AddFamilyVC : THBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (nonatomic,strong)NSArray *msgArr;
@property (nonatomic,copy)NSString *theID;

@end
