//
//  OrdinaryAddMoneyAlert.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/2/10.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrdinaryAddMoneyAlert : UIViewController

///TF
@property (weak, nonatomic) IBOutlet UIView *theNumberBG;
@property (weak, nonatomic) IBOutlet UITextField *theNumberTF;
@property (weak, nonatomic) IBOutlet UIView *theMoneyBG;
@property (weak, nonatomic) IBOutlet UITextField *theMoneyTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *theMoneyTFToRight;
@property (weak, nonatomic) IBOutlet UIView *moneyButtonBG;

@property (weak, nonatomic) IBOutlet UIButton *randomBtn;
@property (weak, nonatomic) IBOutlet UIButton *fixedBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *showMessageLabel;

@property (nonatomic,copy)ViewsEventBlock block;
+(instancetype)shareAddMoneyVC;
-(void)show:(UIViewController * )VC;
-(void)dismiss;


/**
 是否是随机金额
 0是 1否
 */
@property (nonatomic,copy)NSString *isRandom;
@end
