//
//  CommonAlertVC.m
//  TimeHomeApp
//
//  Created by us on 16/2/26.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CommonAlertVC.h"

@interface CommonAlertVC ()
{
    
}

@end

@implementation CommonAlertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
#pragma mark -------初始化--------------


-(void)initView
{
    self.btn_Cancel.layer.borderWidth = 1;
    [self.btn_Cancel.layer setMasksToBounds:YES];
    self.btn_Cancel.layer.borderColor = [UIColorFromRGB(0x595353) CGColor];
}
/**
 *  返回实例
 *
 *  @return return value description
 */
+(CommonAlertVC *)getInstance
{
    CommonAlertVC * alertVC= [[CommonAlertVC alloc] initWithNibName:@"CommonAlertVC" bundle:nil];
    return alertVC;
}
/**
 *  单例方法
 *
 *  @return return value  返回类实例
 */
+ (CommonAlertVC *)sharedCommonAlertVC {
    static CommonAlertVC * sharedCommonAlertVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCommonAlertVC = [[self alloc] initWithNibName:@"CommonAlertVC" bundle:nil];
    });
    return sharedCommonAlertVC;
}



#pragma mark -------事件处理--------------
/**
 *  确认事件
 *
 *  @param sender sender description
 */
- (IBAction)btn_OkClike:(id)sender {
    if(self.eventCallBack)
    {
        self.eventCallBack(nil,sender,ALERT_OK);
    }
    [self dismissAlert];
}
/**
 *  取消事件
 *
 *  @param sender sender description
 */
- (IBAction)btn_CancelClike:(UIButton *)sender {
    if(self.eventCallBack)
    {
        self.eventCallBack(nil,sender,ALERT_CANCEL);
    }
    [self dismissAlert];
}

#pragma mark----------------显示和隐藏------------------
/**
 *  显示
 *
 *  @param parent parent description
 */
-(void)ShowAlert:(UIViewController *)parent
{
    if (self.isBeingPresented) {
        return;
    }
    self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    /**
     *  根据系统版本设置显示样式
     */
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle=UIModalPresentationOverFullScreen;
    }
    else{
        self.modalPresentationStyle=UIModalPresentationCustom;
    }

    [parent presentViewController:self animated:NO completion:^{
        
    }];

}


/**
 *  显示
 *
 *  @param parent    parent 父VC
 *  @param title     title 提示标题
 *  @param msg       msg  提示内容
 *  @param text      左Button文字
 *  @param otherText 右Button文字
 */
-(void)ShowAlert:(UIViewController *)parent Title:(NSString *) title Msg:(NSString *)msg oneBtn:(NSString *)text otherBtn:(NSString *)otherText
{
    if (self.isBeingPresented) {
        return;
    }
    self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    /**
     *  根据系统版本设置显示样式
     */
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle=UIModalPresentationOverFullScreen;
    }
    else{
        self.modalPresentationStyle=UIModalPresentationCustom;
    }
    [parent presentViewController:self animated:NO completion:^{
        
    }];
    
    self.lab_Title.text=title;
    self.lab_ContentText.text=msg;
    [self.btn_Cancel setTitle:text forState:UIControlStateNormal];
    [self.btn_Ok setTitle:otherText forState:UIControlStateNormal];

}
/**
 *  显示
 *
 *  @param parent             parent 父VC
 *  @param title              title 提示标题
 *  @param attributeMsg       attributeMsg  提示内容
 *  @param text               左Button文字
 *  @param otherText          右Button文字
 */
-(void)ShowAlert:(UIViewController *)parent Title:(NSString *) title AttributeMsg:(NSMutableAttributedString *)attributeMsg oneBtn:(NSString *)text otherBtn:(NSString *)otherText
{
    if (self.isBeingPresented) {
        return;
    }
    self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    /**
     *  根据系统版本设置显示样式
     */
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle=UIModalPresentationOverFullScreen;
    }
    else{
        self.modalPresentationStyle=UIModalPresentationCustom;
    }
    [parent presentViewController:self animated:NO completion:^{
        
    }];
    self.lab_Title.text = title;
    self.lab_ContentText.attributedText = attributeMsg;
    [self.btn_Cancel setTitle:text forState:UIControlStateNormal];
    [self.btn_Ok setTitle:otherText forState:UIControlStateNormal];
    
}


/**
 *  隐藏显示
 */
-(void)dismissAlert
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    } ];
}

@end
