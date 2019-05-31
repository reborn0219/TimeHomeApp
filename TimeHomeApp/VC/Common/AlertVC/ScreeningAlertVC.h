//
//  ScreeningAlertVC.h
//  TimeHomeApp
//
//  Created by UIOS on 16/3/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface ScreeningAlertVC : BaseViewController

@property (weak, nonatomic) IBOutlet UIButton *btn_1;
@property (weak, nonatomic) IBOutlet UIButton *btn_2;
@property (weak, nonatomic) IBOutlet UIButton *btn_3;
- (IBAction)screeningAction:(id)sender;
@property (nonatomic,copy)ViewsEventBlock block;
-(void)setFirstSelected:(NSInteger)tag;
+(instancetype)shareScreeningVC;
-(void)showInVC:(UIViewController *)VC;
-(void)dismiss;
@end
