//
//  ModifyVehicleVC.h
//  TimeHomeApp
//
//  Created by 优思科技 on 16/8/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "LS_CarInfoModel.h"

@interface ModifyVehicleVC : THBaseViewController
@property (weak, nonatomic) IBOutlet UIView *view_zero;
@property (weak, nonatomic) IBOutlet UIView *view_three;
@property (weak, nonatomic) IBOutlet UIView *view_two;
@property (weak, nonatomic) IBOutlet UIView *view_one;
- (IBAction)ScanningAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *scanningTF;
@property (nonatomic , strong) LS_CarInfoModel * LS_CIFML;
@property (weak, nonatomic) IBOutlet UILabel *cardLb;
@property (weak, nonatomic) IBOutlet UILabel *aliseLb;

@end
