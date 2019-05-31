//
//  QuestionAddMoneyAlert.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/2/10.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionAddMoneyAlert : UIViewController

@property (weak, nonatomic) IBOutlet UIView *textFieldBG;
@property (weak, nonatomic) IBOutlet UITextField *moneyTf;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic,copy)ViewsEventBlock block;
+(instancetype)shareAddMoneyVC;
-(void)show:(UIViewController * )VC;
-(void)dismiss;
@end
