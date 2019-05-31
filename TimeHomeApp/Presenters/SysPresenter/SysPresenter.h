//
//  SysPresenter.h
//  YouLifeApp
//
//  Created by us on 15/11/2.
//  Copyright © 2015年 us. All rights reserved.
//
/**
 异常收集发送类
 **/
#import "BasePresenters.h"

@interface SysPresenter : BasePresenters

///发送错误内容
-(void) saveAppError:(NSString *)Content;


///打电话 弹出慢
//-(void) callMobileNum:(NSString *)mobileNum superview:(UIView *) superView;

//打电话 弹出快
+ (void)callPhoneStr:(NSString*)phoneStr withVC:(UIViewController *)selfvc;

@end
