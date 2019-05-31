//
//  RaiN_NewRegisterAlert.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/8/4.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RaiN_NewRegisterAlert : UIViewController

+(instancetype)shareNewRegisterAlert;

-(void)showInVC:(UIViewController *)VC withTitle:(NSString *)title andCancelBtn:(NSString *)cancelBtn andRegisterBtn:(NSString *)registerBtn;

@property (nonatomic,copy)ViewsEventBlock block;

-(void)dismiss;
@end
