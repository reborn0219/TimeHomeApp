//
//  ShakePassageVC.h
//  TimeHomeApp
//
//  Created by us on 16/2/26.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  摇摇通行功能
 */
#import "BaseViewController.h"

@interface ShakePassageVC : THBaseViewController
/**
 *  开始执行
 */
@property(nonatomic,assign)BOOL isStart;
- (IBAction)backAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end
