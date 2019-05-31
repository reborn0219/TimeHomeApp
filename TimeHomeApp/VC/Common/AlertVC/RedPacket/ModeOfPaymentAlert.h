//
//  ModeOfPaymentAlert.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/2/13.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModeOfPaymentAlert : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (weak, nonatomic) IBOutlet UIButton *weChatBtn;
@property (weak, nonatomic) IBOutlet UIButton *balanceBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (nonatomic,copy)NSString *moneyStr;

@property (nonatomic,copy)ViewsEventBlock block;
+(instancetype)sharePaymentVC;
-(void)show:(UIViewController * )VC;
-(void)dismiss;
@end
