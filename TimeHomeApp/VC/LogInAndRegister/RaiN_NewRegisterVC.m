//
//  RaiN_NewRegisterVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/8/4.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RaiN_NewRegisterVC.h"
#import "WebViewVC.h"
#import "RegularUtils.h"//正则工具类
#import "LogInPresenter.h"//登录接口类
#import "PerfectInforVC.h"//完善资料
#import "MainTabBars.h"//首页tabbar
#import "THMyInfoPresenter.h"
@interface RaiN_NewRegisterVC ()
{
    LogInPresenter * logInPresenter;
    //倒计时
    dispatch_source_t _timer;
    __block int timeout;
}

@end

@implementation RaiN_NewRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTF.keyboardType = UIKeyboardTypeNumberPad;
    self.passWordTF.keyboardType = UIKeyboardTypeASCIICapable;
    _secretBtn.selected = NO;
    _passWordTF.secureTextEntry=YES;
    [_secretBtn setImage:[UIImage imageNamed:@"登录注册_密码不可见"] forState:UIControlStateNormal];
    
    logInPresenter=[LogInPresenter new];
    
    if (![XYString isBlankString:_thePhoneNumber]) {
        self.phoneTF.text = _thePhoneNumber;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
}

#pragma mark ---- 网络请求相关
/**
 获取验证码
 */
- (void)getCodeNet {
    
    if(![RegularUtils isPhoneNum:self.phoneTF.text])//验证手机号正确
    {
        
        [self showToastMsg:@"手机号不正确,请重新输入" Duration:5];
        return;
    }
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self];
    [logInPresenter getCAPTCHAForPhoneNum:self.phoneTF.text type:@"0" andPlatform:@"" andAccount:@"" upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            if(resultCode==SucceedCode)
            {
                [self Countdown];
                [selfWeak showToastMsg:[NSString stringWithFormat:@"验证码短信已发送至%@",selfWeak.phoneTF.text] Duration:3.0f];
            }
            else
            {
                
                if ([data isKindOfClass:[NSArray class]]) {
                    [selfWeak showToastMsg:(NSString *)data[0] Duration:3.0f];
                    
                    if ([data[1] isEqualToString:@"10008"]) {
                        
                    }else {
                        
                    }
                }else if([data isKindOfClass:[NSString class]]) {
                    
                    [selfWeak showToastMsg:(NSString *)data Duration:5.0];
                }
                
                
                
            }
        });
        
        
    }];
    
}


/**
 检查验证码
 */
- (void)checkCodeNet {
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self];
    [logInPresenter checkVerificodeForPhoneNum:_phoneTF.text verificode:self.codeTF.text upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            if(resultCode==SucceedCode)
            {
                [selfWeak registerNet];//注册
            }
            else
            {
                if ([data isKindOfClass:[NSString class]]) {
                    [selfWeak showToastMsg:(NSString *)data Duration:5.0];
                }else {
                    [selfWeak showToastMsg:data[@"errmsg"] Duration:5.0];
                }
                
            }
        });
    }];
}


/**
 注册接口
 */
- (void)registerNet {
    
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self];
    
    [logInPresenter registerForPhoneNum:self.phoneTF.text Pw:self.passWordTF.text verificode:self.codeTF.text upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [indicator stopAnimating];
            
            if(resultCode == SucceedCode)
            {
                
                //--------------------------------------------------
                //注册成功，登录请求
                THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
                [indicator startAnimating:self];
                [logInPresenter logInForAcc:self.phoneTF.text Pw:self.passWordTF.text upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [indicator stopAnimating];
                        if(resultCode==SucceedCode)
                        {
                            AppDelegate *appdelegate = GetAppDelegates;
                            
                            NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:WIDGET_GROUP_ID];
                            [shared setObject:appdelegate.userData.token forKey:@"widget"];
                            [shared synchronize];
                            /**
                             *  性别，小区为空跳转到完善资料界面
                             */
                            if (appdelegate.userData.sex.intValue == 0 || [appdelegate.userData.communityid isEqualToString:@"0"] || [XYString isBlankString:appdelegate.userData.communityid]) {
                                
                                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LogInRegister" bundle:nil];
                                PerfectInforVC * regVC=[sb instantiateViewControllerWithIdentifier:@"PerfectInforVC"];
                                regVC.theCommunityName = appdelegate.userData.communityname;
                                regVC.theCommunityID = appdelegate.userData.communityid;
                                [self.navigationController pushViewController:regVC animated:YES];
                                
                            }else{
                                
                                UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainTabBar" bundle:nil];
                                MainTabBars * MainTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBars"];
                                AppDelegate * appdelegate=GetAppDelegates;
                                appdelegate.window.rootViewController=MainTabBar;
                                
                                CATransition * animation =  [AnimtionUtils getAnimation:2 subtag:2];
                                [MainTabBar.view.window.layer addAnimation:animation forKey:nil];
                            }
                            
                        }
                        else
                        {
                            
                            [self showToastMsg:(NSString *)data Duration:5.0];
                        }
                    });
                    
                }];
                //--------------------------------------------------
            }
            else
            {
                
                [self showToastMsg:(NSString *)data Duration:5.0];
            }
            
        });
        
    }];
}

#pragma mark ------ 按钮点击事件
/**
 退出当前页面
 */
- (IBAction)closeVCClick:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"LogInRegister" bundle:nil];
    UINavigationController *loginVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"navLogIn"];
    AppDelegate *appdelegate = GetAppDelegates;
    appdelegate.window.rootViewController = loginVC;
    CATransition * animation =  [AnimtionUtils getAnimation:5 subtag:0];
    [loginVC.view.window.layer addAnimation:animation forKey:nil];
}
/**
 服务条款
 */
- (IBAction)userAgreementBtnClick:(id)sender {
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    webVc.url=@"http://times.usnoon.com:88/cmpapp/xiyie/index.html";
    webVc.title = @"使用条款和隐私政策";
    [self.navigationController pushViewController:webVc animated:YES];
}

/**
 明文密文切换
 */
- (IBAction)secretbtnClick:(id)sender {
    UIButton *button = sender;
    button.selected=!button.selected;

    if(button.selected)
    {
        self.passWordTF.secureTextEntry=NO;
        [sender setImage:[UIImage imageNamed:@"登录注册_密码可见"] forState:UIControlStateNormal];
    }else
    {
        self.passWordTF.secureTextEntry=YES;
        [button setImage:[UIImage imageNamed:@"登录注册_密码不可见"] forState:UIControlStateNormal];
    }

}

/**
 获取验证码
 */
- (IBAction)getCodeBtnClick:(id)sender {
    if (self.phoneTF.text.length == 0) {
        [self showToastMsg:@"请先输入手机号" Duration:3.0f];
        return;
    }
    [self getCodeNet];
    
}

/**
 注册按钮
 */
- (IBAction)registerBtnClick:(id)sender {
    
    //----调试------
//    AppDelegate *appdelegate = GetAppDelegates;
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LogInRegister" bundle:nil];
//    PerfectInforVC * regVC=[sb instantiateViewControllerWithIdentifier:@"PerfectInforVC"];
//    regVC.theCommunityName = appdelegate.userData.communityname;
//    regVC.theCommunityID = appdelegate.userData.communityid;
//    [self.navigationController pushViewController:regVC animated:YES];
//    return;
    //----调试------
    
    [self.view endEditing:YES];

    ///手机号
    if (self.phoneTF.text.length == 0) {
        [self showToastMsg:@"请先输入手机号" Duration:3.0f];
        return;
    }
    if(![RegularUtils isPhoneNum:self.phoneTF.text])//验证手机号正确
    {
        [self showToastMsg:@"手机号不正确,请重新输入" Duration:5];
        return;
    }
    
    ////密码
    if (self.passWordTF.text.length == 0) {
        [self showToastMsg:@"请先输入密码" Duration:3.0f];
        return;
    }
    NSString * regex  = @"[A-Z0-9a-z!@#$%^&*.~/\\{\\}|()'\"?><,.`\\+-=_\\[\\]:;]+";
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL b = [predicte evaluateWithObject:self.passWordTF.text];
    if (!b||(self.passWordTF.text.length!=6)) {
        [self showToastMsg:@"请输入正确的密码格式！" Duration:5];
        return;
    }
    
    
    ///验证码
    if (self.codeTF.text.length == 0) {
        [self showToastMsg:@"请先输入验证码" Duration:3.0f];
        return;
    }
    if(self.codeTF.text.length!=4)
    {
        [self showToastMsg:@"请输入4位验证码!" Duration:5];
        return;
    }
    
    [self checkCodeNet];
    
}

- (IBAction)phoneTFEditChange:(id)sender {
    UITextField *tf = sender;
    UITextRange * selectedRange = tf.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(tf.text.length >= 11)
        {
            tf.text = [tf.text substringToIndex:11];
        }
    }
}
- (IBAction)passWordTFEditChange:(id)sender {
    UITextField *tf = sender;
    UITextRange * selectedRange = tf.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(tf.text.length >= 6)
        {
            tf.text = [tf.text substringToIndex:6];
        }
    }
}
- (IBAction)codeTFEditChange:(id)sender {
//    UITextField *tf = sender;
//    UITextRange * selectedRange = tf.markedTextRange;
//    if(selectedRange == nil || selectedRange.empty){
//        if(tf.text.length >= 4)
//        {
//            tf.text = [tf.text substringToIndex:4];
//        }
//    }
}
#pragma mark ---- 点击空白，取消第一响应
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}




#pragma mark ----- 按钮倒计时相关
-(void)Countdown
{
    timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                self.getCodeBtn.titleLabel.text = [NSString stringWithFormat:@"(%@)等待发送",strTime];
                [self.getCodeBtn setTitle:[NSString stringWithFormat:@"(%@)等待发送",strTime] forState:UIControlStateNormal];
                [self.getCodeBtn setTitle:[NSString stringWithFormat:@"(%@)等待发送",strTime] forState:UIControlStateDisabled];
                
                self.getCodeBtn.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}

@end
