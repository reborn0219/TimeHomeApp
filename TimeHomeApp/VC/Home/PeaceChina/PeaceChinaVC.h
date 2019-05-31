//
//  PeaceChinaVC.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2017/4/11.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"

@interface PeaceChinaVC : THBaseViewController
@property (weak, nonatomic) IBOutlet UIButton *jingwuBtn;
@property (weak, nonatomic) IBOutlet UIButton *dangzhengBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhihuiBtn;
- (IBAction)gotoNextVc:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgLayout_bottom;
- (IBAction)touchDownAction:(UIButton *)sender;

@end
