//
//  L_PopAlertView2.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/8.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface L_PopAlertView2 : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancel_Btn;

@property (nonatomic, copy) ViewsEventBlock selectButtonCallBack;

@property (weak, nonatomic) IBOutlet UILabel *msg_Label;

+ (L_PopAlertView2 *)getInstance;

- (void)showVC:(UIViewController *)parent withMsg:(NSString *)msg cellEvent:(ViewsEventBlock)eventCallBack;

@end
