//
//  LoginVC.m
//  TimeHomeApp
//
//  Created by us on 16/2/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "LoginVC.h"
#import "MainTabBars.h"
#import "PerfectInforVC.h"
#import "FindPWVC.h"
#import "RegisterVC.h"
#import "LogInPresenter.h"
#import "RegularUtils.h"
#import "GCD.h"
#import "AppSystemSetPresenters.h"
#import "DateUitls.h"
#import "THMyInfoPresenter.h"
#import "SharePresenter.h"
#import "UIButtonImageWithLable.h"
#import "ZSY_ProblemsLoggingVC.h"
#import "ZSY_LoginHelp.h"
#import "PostingVC.h"
#import "AppDelegate.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "ZSY_PhoneNumberBinding.h"
#import "MySettingAndOtherLogin.h"
#import "PAPopupTool.h"
#import "NetworkMonitoring.h"
#import "AppDelegate+JPush.h"
#import "PAOtherLogInRequest.h"
#import "PAH5UrlManager.h"

// 导入头文件
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

#import "AppPayPresenter.h"
#import "ChatPresenter.h"
#import "Gam_Chat.h"
#import "XMMessage.h"
#import "DateUitls.h"
#import "DataOperation.h"


#import "RaiN_NewRegisterAlert.h"//账号未注册弹框
#import "RaiN_NewRegisterVC.h"//新版注册页面
#import "SubmittedToExamineAlert.h"
#import "RaiN_FamilyAuthorizationListVC.h"
#import "RaiN_TheQrCodeAlert.h"

#import "PANoticeManager.h"

@interface LoginVC ()
{
    LogInPresenter * logInPresenter;
    
    //qq
    TencentOAuth *tencentOAuth;
    NSArray *permissions;
    
    
    ///动画相关
    NSTimer *timer;
    float leftnum;
    BOOL leftStartIsShow;
    float leftnum1;
    BOOL leftStartIsShow1;
    float rightnum;
    BOOL rightStartIsShow;
    float rightnum1;
    BOOL rightStartIsShow1;
    
    float topCloudNum;
    float leftCloudNum;
    float rightCloudNum;
    
    BOOL isTopCloudBoundary;
    BOOL isLeftCloudBoundary;
    BOOL isRightCloudBoundary;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *third_bottom_layout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *login_top_layout;
@property (copy, nonatomic) void (^requestForUserInfoBlock)();
/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *img_Avatar;
/**
 *  账号=手机号
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_Account;
/**
 *  密码
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_PassWord;
/**
 *  记住密码
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_RememberPw;



/**
 第三方登录按钮是否已经点击
 */
@property (assign, nonatomic)BOOL theButtonIsClick;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.TF_PassWord.placeholder = @"请输入密码";//6位(数字、字母、特殊符号)
    [self initView];
    [self clearPassWord];
    [self whetherUerInput];
    //注册通知 (来自appdelegate的通知，用来更改白天或者晚上的UI展示)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkTheTime:) name:@"checkTheTime" object:nil];
    
}

- (void)checkTheTime:(NSNotification *)text{
    [self setUpUI];
    
}
#pragma mark ----- 改版登录蓝色主题页面的UI设置 包括动画
- (void)setUpUI {
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    _loginButton.layer.cornerRadius = 44/2;
    _loginButton.layer.masksToBounds = YES;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *nowtimeStr = [formatter stringFromDate:datenow];
    NSString *startStr = [NSString stringWithFormat:@"%@06:00:00",[nowtimeStr substringToIndex:11]];
    NSString *endStr = [NSString stringWithFormat:@"%@18:00:00",[nowtimeStr substringToIndex:11]];
    
    BOOL isBeyond =  [DateUitls validateWithStartTime:startStr withExpireTime:endStr];
    if (isBeyond == YES) {
        //白天
        _eveningView.hidden = YES;
        _daysView.hidden = NO;
        
        [timer invalidate];
        timer = nil;
        
        topCloudNum = 80;
        isTopCloudBoundary = NO;
        leftCloudNum = 25;
        rightCloudNum = 25;
        timer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(daysAnimation) userInfo:nil repeats:YES];
        
    }else {
        //晚上
        
        [timer invalidate];
        timer = nil;
        
        _eveningView.hidden = NO;
        _daysView.hidden = YES;
        
        _leftStart.alpha = 1;
        leftStartIsShow = YES;
        leftnum = 1.00;
        
        _leftStart1.alpha = 1;
        leftStartIsShow1 = YES;
        leftnum1 = 1.00;
        
        _rightStrat.alpha = 1;
        rightStartIsShow = YES;
        rightnum = 1.00;
        
        _rightStrat1.alpha = 1;
        rightStartIsShow1 = YES;
        rightnum1 = 1.00;
        timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(eveningAnimation) userInfo:nil repeats:YES];
    }
}

#pragma mark ----- 图片动画
- (void)daysAnimation {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ///顶部的云
            _topCloudToLeft.constant = _topCloudToLeft.constant+=0.16;
            if (_topCloudToLeft.constant > SCREEN_WIDTH) {
                _topCloudToLeft.constant = -55;
            }
            ///左边的云
            _leftCloudToLeft.constant = _leftCloudToLeft.constant += 0.08;
            if (_leftCloudToLeft.constant > SCREEN_WIDTH) {
                _leftCloudToLeft.constant = -51;
            }
            
            if (isLeftCloudBoundary == NO) {
                leftCloudNum = leftCloudNum + 0.08;
                _leftCloudToLeft.constant = leftCloudNum;
                
                
                if (_leftCloudToLeft.constant >= SCREEN_WIDTH) {
                    _leftCloudToLeft.constant = -51;
                    leftCloudNum = -51;
                }
                if (CGRectGetMaxX(_leftCloud.frame) >= CGRectGetMinX(_loginLogo.frame) && CGRectGetMinX(_leftCloud.frame) <= CGRectGetMaxX(_loginLogo.frame) && CGRectGetMinX(_leftCloud.frame) <= CGRectGetMinX(_loginLogo.frame)) {
                    isLeftCloudBoundary = YES;
                }
                
                
            }else {
                leftCloudNum = leftCloudNum - 0.08;
                _leftCloudToLeft.constant = leftCloudNum;
                
                if (_leftCloudToLeft.constant < -51) {
                    _leftCloudToLeft.constant = SCREEN_WIDTH;
                    leftCloudNum = SCREEN_WIDTH;
                }
                
                if (CGRectGetMinX(_leftCloud.frame) <= CGRectGetMaxX(_loginLogo.frame) && CGRectGetMaxX(_leftCloud.frame) >= CGRectGetMaxX(_loginLogo.frame) &&CGRectGetMinX(_leftCloud.frame) >= CGRectGetMinX(_loginLogo.frame)) {
                    isLeftCloudBoundary = NO;
                }
            }
            
            ///右边的云
            rightCloudNum = rightCloudNum + 0.1;
            _rightCloudToRight.constant = _rightCloudToRight.constant+=0.1;
            if (_rightCloudToRight.constant > SCREEN_WIDTH) {
                _rightCloudToRight.constant = -38;
            }
        });
    });
    
}
- (void)eveningAnimation {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ///左边的星星
            if (leftStartIsShow == YES) {
                leftnum=leftnum-0.01;
                _leftStart.alpha = leftnum;
                if (leftnum <= 0) {
                    leftStartIsShow = NO;
                    leftnum = 0.00;
                }
            }else {
                leftnum+=0.01;
                _leftStart.alpha = leftnum;
                if (leftnum >= 1) {
                    leftnum = 1.00;
                    leftStartIsShow = YES;
                }
            }
            
            if (leftStartIsShow1 == YES) {
                leftnum1=leftnum1-0.016;
                _leftStart1.alpha = leftnum1;
                if (leftnum1 <= 0) {
                    leftStartIsShow1 = NO;
                    leftnum1 = 0.00;
                }
            }else {
                leftnum1+=0.016;
                _leftStart1.alpha = leftnum1;
                if (leftnum1 >= 1) {
                    leftnum1 = 1.00;
                    leftStartIsShow1 = YES;
                }
            }
            
            
            ///右边的星星
            if (rightStartIsShow == YES) {
                rightnum=rightnum-0.014;
                _rightStrat.alpha = rightnum;
                if (rightnum <= 0) {
                    rightStartIsShow = NO;
                    rightnum = 0.00;
                }
            }else {
                rightnum+=0.014;
                _rightStrat.alpha = rightnum;
                if (rightnum >= 1) {
                    rightnum = 1.00;
                    rightStartIsShow = YES;
                }
            }
            
            if (rightStartIsShow1 == YES) {
                rightnum1=rightnum1-0.008;
                _rightStrat1.alpha = rightnum1;
                if (rightnum1 <= 0) {
                    rightStartIsShow1 = NO;
                    rightnum1 = 0.00;
                }
            }else {
                rightnum1+=0.008;
                _rightStrat1.alpha = rightnum1;
                if (rightnum1 >= 1) {
                    rightnum1 = 1.00;
                    rightStartIsShow1 = YES;
                }
            }
        });
    });
}

// 超过60天未登录 清除密码
- (void)clearPassWord{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *isClearPW = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"clearPassWord"]];
    
    if ([isClearPW isEqualToString:@"1"]) {
        AppDelegate *appdele = GetAppDelegates;
        appdele.userData.passWord = @"";
        _TF_PassWord.text = @"";
        [userDefaults setObject:@"0" forKey:@"clearPassWord"];
        [userDefaults synchronize];
        [appdele saveContext];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    _theButtonIsClick = NO;
    //第三方登录按钮可点击
    _btn1.userInteractionEnabled = YES;
    _btn2.userInteractionEnabled = YES;
    _btn3.userInteractionEnabled = YES;
    [super.navigationController setNavigationBarHidden:YES animated:YES];
    AppDelegate * appdelegate = GetAppDelegates;
    
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:WIDGET_GROUP_ID];
    [shared setObject:@"" forKey:@"widget"];
    [shared synchronize];
    
    /*
    if (![appdelegate.userData.isGuide boolValue]) {
        [self performSegueWithIdentifier:@"toguide" sender:self];
    }
     */
    ///数据统计
    [appdelegate markStatistics:DengLu];
//    [TalkingData trackPageBegin:@"denglu"];
    
    [self setUpUI];
    
    [PAPopupTool sharePAPopupTool].popupNumbers = @1;
    [[NetworkMonitoring shareMonitoring]needCallBack:^(id  _Nullable data, ResultCode resultCode) {
    
        if (resultCode == SucceedCode) {
            
            [[PAPopupTool sharePAPopupTool]dissmissView];

        }else
        {
            [[PAPopupTool sharePAPopupTool]showNotNetworkView];

        }
    }];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [TalkingData trackPageEnd:@"denglu"];
    ///数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":DengLu}];

}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [timer invalidate];
    timer = nil;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    /** rootViewController不允许侧滑 */
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}

#pragma mark---------初始化---------
-(void)initView
{
    
    ///ipad 上隐藏第三方登录
    if ((SCREEN_WIDTH*480.0f) == (SCREEN_HEIGHT*320.0f)) {
        
        _login_top_layout.constant = 10;
        _third_bottom_layout.constant = - 300;
        
    }else
    {
        _login_top_layout.constant = 25;
        _third_bottom_layout.constant = 20;
    }
    
    logInPresenter=[LogInPresenter new];
    AppDelegate * appdelegate = GetAppDelegates;
    if (appdelegate.userData.isRememberPw == nil) {
        appdelegate.userData.isRememberPw = @YES;
        [appdelegate saveContext];
    }
    self.btn_RememberPw.selected=[appdelegate.userData.isRememberPw boolValue];
    
    if(self.btn_RememberPw.selected)
    {
        [self.btn_RememberPw setImage:[UIImage imageNamed:@"dl_icon_jmm_s"] forState:UIControlStateNormal];
        self.TF_PassWord.text=appdelegate.userData.passWord;
    }
    else
    {
        [self.btn_RememberPw setImage:[UIImage imageNamed:@"dl_icon_jmm_n"] forState:UIControlStateNormal];
    }
    if (![XYString isBlankString:appdelegate.userData.accPhone]) {
        self.TF_Account.text = appdelegate.userData.accPhone;
    }else {
        self.TF_PassWord.text = @"";
    }
    self.TF_PassWord.keyboardType = UIKeyboardTypeASCIICapable;
    
    
}
#pragma mark---------事件处理---------
/**
 *  账号输入改变事件
 *
 *  @param sender
 */
- (IBAction)TF_AccountChangeEvent:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>=11)
        {
            sender.text=[sender.text substringToIndex:11];
        }
    }
    [self whetherUerInput];
}

- (IBAction)TF_PWChangeEvent:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>=6)
        {
            sender.text=[sender.text substringToIndex:6];
        }
    }
    [self whetherUerInput];
}
#pragma mark - 判断账号密码是否输入

-(BOOL)whetherUerInput
{
    if ([XYString isBlankString:self.TF_PassWord.text]||[XYString isBlankString:self.TF_Account.text]) {
        
        [self.loginButton  setBackgroundColor:UIColorFromRGB(0x7DBDFF)];

        return YES;
    }else
    {
        
        [self.loginButton  setBackgroundColor:UIColorFromRGB(0x2D82E3)];

        return NO;
    }
}
/**
 *  显示明文密码
 *
 *  @param sender
 */
- (IBAction)btn_ShowPWEvent:(UIButton *)sender {
    
    sender.selected=!sender.selected;
    if(sender.selected)
    {
        self.TF_PassWord.secureTextEntry=NO;
        [sender setImage:[UIImage imageNamed:@"登录注册_密码可见"] forState:UIControlStateNormal];
    }else
    {
        self.TF_PassWord.secureTextEntry=YES;
        [sender setImage:[UIImage imageNamed:@"登录注册_密码不可见"] forState:UIControlStateNormal];
    }
    
}

/**
 *  记住密码事件
 *
 *  @param sender
 */

- (IBAction)btn_RememberPWEvent:(UIButton *)sender {
    
    //    PostingVC *pos = [[PostingVC alloc] init];
    //    [self.navigationController pushViewController:pos animated:NO];
    AppDelegate * appdelegate = GetAppDelegates;
    self.btn_RememberPw.selected=[appdelegate.userData.isRememberPw boolValue];
    self.btn_RememberPw.selected=!self.btn_RememberPw.selected;
    if(self.btn_RememberPw.selected)
    {
        AppDelegate *appdele = GetAppDelegates;
        appdele.userData.isRememberPw = @YES;
        [appdele saveContext];
        [self.btn_RememberPw setImage:[UIImage imageNamed:@"dl_icon_jmm_s"] forState:UIControlStateNormal];
    }
    else
    {
        AppDelegate *appdele = GetAppDelegates;
        appdele.userData.isRememberPw = @NO;
        appdele.userData.passWord = @"";
        [appdele saveContext];
        [self.btn_RememberPw setImage:[UIImage imageNamed:@"dl_icon_jmm_n"] forState:UIControlStateNormal];
    }
    
}
/**
 *  忘记密码
 *
 *  @param sender
 */
- (IBAction)btn_FindPWEvent:(UIButton *)sender {
    FindPWVC * find=[self.storyboard instantiateViewControllerWithIdentifier:@"FindPWVC"];
    [self.navigationController pushViewController:find animated:YES];
    
    
    //    ZSY_ProblemsLoggingVC *problemsLogging = [ZSY_ProblemsLoggingVC shareProblemsLoggingVC];
    //    [problemsLogging show:self];
    //
    //    @WeakObj(self)
    //    problemsLogging.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
    //    {
    //
    //        if (index == 1) {
    //            //手机号重置密码
    //            NSLog(@"手机号重置密码");
    //            FindPWVC * find=[self.storyboard instantiateViewControllerWithIdentifier:@"FindPWVC"];
    //            [selfWeak.navigationController pushViewController:find animated:YES];
    //
    //        }else if (index == 2) {
    //            //帮助反馈
    //            NSLog(@"帮助反馈");
    //            ZSY_LoginHelp *help = [[ZSY_LoginHelp alloc] init];
    //            [selfWeak.navigationController pushViewController:help animated:YES];
    //
    //        }
    //    };
    
    
}
#pragma mark - 登录事件
/**
 *  登录事件
 *
 *  @param sender
 */
- (IBAction)btn_LogInEvent:(UIButton *)sender {
    
    //    RaiN_TheQrCodeAlert *alert = [RaiN_TheQrCodeAlert shareRaiN_TheQrCodeAlert];
    //    [alert showInVC:self WithData:nil];
    //    return;
    
    AppDelegate * appdelegate = GetAppDelegates;
    appdelegate.userData.isRememberPw=[[NSNumber alloc]initWithBool:self.btn_RememberPw.selected];
    [appdelegate saveContext];
    @WeakObj(self);
    
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
    [indicator startAnimating:self];
    [logInPresenter logInForAcc:self.TF_Account.text Pw:self.TF_PassWord.text upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            
            if(resultCode==SucceedCode)
            {
                AppDelegate *appDelegate = GetAppDelegates;
                
                NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:WIDGET_GROUP_ID];
                [shared setObject:appDelegate.userData.token forKey:@"widget"];
                [shared synchronize];
                
                ///调试完善资料
                //                appDelegate.userData.communityid = @"";
                //                appDelegate.userData.communityname = @"";
                
                [self getNowTime];//获取当前的系统时间并保存
                
                /**
                 *  性别，小区为空跳转到完善资料界面
                 */
                if (appDelegate.userData.sex.intValue == 0 || [appDelegate.userData.communityid isEqualToString:@"0"] || [XYString isBlankString:appDelegate.userData.communityid]) {
                    
                    PerfectInforVC * regVC=[selfWeak.storyboard instantiateViewControllerWithIdentifier:@"PerfectInforVC"];
                    regVC.theCommunityName = appdelegate.userData.communityname;
                    regVC.theCommunityID = appdelegate.userData.communityid;
                    [selfWeak.navigationController pushViewController:regVC animated:YES];
                    [selfWeak getChatRecord];
                    
                }else{
                    
                    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainTabBar" bundle:nil];
                    MainTabBars * MainTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBars"];
                    appDelegate.window.rootViewController=MainTabBar;
                    ///绑定标签
                    [AppSystemSetPresenters getBindingTag];
                    CATransition * animation =  [AnimtionUtils getAnimation:2 subtag:2];
                    [MainTabBar.view.window.layer addAnimation:animation forKey:nil];
                    ///edit by ls 2016.12.8
                    [selfWeak getChatRecord];

                }
                
            }else if(resultCode==FailureCode) {
                
                if ([data isKindOfClass:[NSString class]]) {
                    
                    AppDelegate * appdelegate = GetAppDelegates;
                    [appdelegate setTags:nil error:nil];
                    appdelegate.userData.token = @"";
                    
                    [appdelegate saveContext];
                    
                    [selfWeak showToastMsg:(NSString *)data Duration:5.0];
                    
                }else if([data isKindOfClass:[NSNumber class]]){
                    
                    //未注册弹框处理
                    if ([data integerValue] == 10004) {
                        
                        RaiN_NewRegisterAlert *registerAlert = [RaiN_NewRegisterAlert shareNewRegisterAlert];
                        [registerAlert showInVC:self withTitle:@"" andCancelBtn:@"" andRegisterBtn:@""];
                        registerAlert.block = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                            if (index == 0) {
                                //注册
                                
                                RaiN_NewRegisterVC *newRegister = [[RaiN_NewRegisterVC alloc] init];
                                newRegister.thePhoneNumber = _TF_Account.text;
                                UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:newRegister];
                                AppDelegate *appdelegate = GetAppDelegates;
                                appdelegate.window.rootViewController = nvc;
                                CATransition * animation =  [AnimtionUtils getAnimation:5 subtag:2];//7(0) 5(2)
                                [nvc.view.window.layer addAnimation:animation forKey:nil];
                                NSLog(@"注册");
                            }
                        };
                        
                    }
                }
            }
        });
        
    }];
    
}
/**
 *  注册事件
 *
 *  @param sender
 */
- (IBAction)btn_RegisterEvent:(UIButton *)sender {
    
    RaiN_NewRegisterVC *newRegister = [[RaiN_NewRegisterVC alloc] init];
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:newRegister];
    AppDelegate *appdelegate = GetAppDelegates;
    
    appdelegate.window.rootViewController = nvc;
    
    CATransition * animation =  [AnimtionUtils getAnimation:5 subtag:2];//7(0) 5(2)
    [nvc.view.window.layer addAnimation:animation forKey:nil];
    
}

#pragma mark  --- 第三方登录事件处理

#pragma mark ----- 微博
- (IBAction)weiboClick:(id)sender {
    
    if (_theButtonIsClick) {
        return;
    }
    NSLog(@"微博登录");
    [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
    _theButtonIsClick = YES;
    _btn1.userInteractionEnabled = NO;
    @WeakObj(self);
    
    
    [ShareSDK getUserInfo : SSDKPlatformTypeSinaWeibo onStateChanged :^( SSDKResponseState state, SSDKUser *user, NSError *error) {
        
        [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
        
        _theButtonIsClick = NO;
        _btn1.userInteractionEnabled = YES;
        NSLog(@"-----");
        if (state == SSDKResponseStateSuccess ) {
            
            NSString *tokenStr = [XYString IsNotNull:user.credential.token];
            NSString *uidStr = [XYString IsNotNull:user.uid];
            NSString *nameStr = [XYString IsNotNull:user.nickname];
            [selfWeak showToastMsg:@"授权成功" Duration:3.0];
            
            /**
             第三方登录
             @param type 第三方类型
             @param token 第三方token
             @param ThirdID 第三方id
             @param Account 第三方昵称
             */
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [selfWeak otherLoginWithtokenStr:tokenStr uidStr:uidStr nameStr:nameStr type:@"3" SSDKUser:user];
              
            });
            
            NSLog ( @"uid=%@" ,user. uid );
            NSLog ( @"token=%@" ,user. credential . token );
            NSLog ( @"nickname=%@" ,user. nickname );
            NSLog ( @"gender=%ld" ,(unsigned long)user.gender);
            NSLog ( @"birthday=%@" ,user.birthday);
            NSLog ( @"%@" ,user. credential );
            
        }else if(state == SSDKResponseStateCancel){
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            [selfWeak showToastMsg:@"您已取消授权" Duration:3.0];
            
        }else if (state == SSDKResponseStateFail) {
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            [selfWeak showToastMsg:@"授权失败" Duration:3.0];
            
        }else {
            NSLog(@"----%ld-",state);
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
        }
        
        
    }];
    
}


#pragma mark ----- QQ
- (IBAction)QQClick:(id)sender {
    if (_theButtonIsClick) {
        return;
    }
    NSLog(@"QQ登录");
    [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
    _theButtonIsClick = YES;
    _btn2.userInteractionEnabled = NO;
    @WeakObj(self);
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    
    [ShareSDK getUserInfo : SSDKPlatformTypeQQ onStateChanged :^( SSDKResponseState state, SSDKUser *user, NSError *error) {
        _theButtonIsClick = NO;
        _btn2.userInteractionEnabled = YES;
        NSLog(@"%ld-----",state);
        if (state == SSDKResponseStateSuccess ) {
            
            NSString *tokenStr = [XYString IsNotNull:user.credential.token];
            NSString *uidStr = [XYString IsNotNull:user.uid];
            NSString *nameStr = [XYString IsNotNull:user.nickname];
            [selfWeak showToastMsg:@"授权成功" Duration:3.0];
            
            /**
             第三方登录
             @param type 第三方类型
             @param token 第三方token
             @param ThirdID 第三方id
             @param Account 第三方昵称
             */
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self otherLoginWithtokenStr:tokenStr uidStr:uidStr nameStr:nameStr type:@"1" SSDKUser:user];
                
            });
            
            NSLog ( @"uid=%@" ,user.uid );
            NSLog ( @"nickname=%@" ,user.nickname );
            NSLog ( @"gender=%ld" ,user.gender);
            NSLog ( @"birthday=%@" ,user.birthday);
            NSLog ( @"token=%@" ,user.credential.token );
            NSLog ( @"token=%@" ,user.credential.rawData);
        }else if(state == SSDKResponseStateCancel) {
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            [selfWeak showToastMsg:@"您已取消授权" Duration:3.0];
            
        }else if (state == SSDKResponseStateFail) {
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            [selfWeak showToastMsg:@"授权失败" Duration:3.0];
            
        }else {
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
        }
        
    }];
}


#pragma mark ----- 微信

- (IBAction)weixinClick:(id)sender {
    //微信
    if (_theButtonIsClick) {
        return;
    }
    [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
    NSLog(@"微信登录");
    _theButtonIsClick = YES;
    _btn2.userInteractionEnabled = NO;
    @WeakObj(self);
    [ShareSDK getUserInfo : SSDKPlatformTypeWechat onStateChanged :^( SSDKResponseState state, SSDKUser *user, NSError *error) {
        _theButtonIsClick = NO;
        _btn2.userInteractionEnabled = YES;
        if (state == SSDKResponseStateSuccess ) {
            
            NSString *tokenStr = [XYString IsNotNull:user.credential.token];
            NSString *uidStr = [XYString IsNotNull:user.uid];
            NSString *nameStr = [XYString IsNotNull:user.nickname];
            [selfWeak showToastMsg:@"授权成功" Duration:3.0];
            
            NSLog ( @"uid=%@" ,user. uid );
            NSLog ( @"%@" ,user. credential );
            NSLog ( @"token=%@" ,user. credential . token );
            NSLog ( @"nickname=%@" ,user. nickname );
            NSLog ( @"nickname=%ld" ,user.gender);
            NSLog ( @"nickname=%@" ,user.birthday);
            
            /**
             第三方登录
             @param type 第三方类型
             @param token 第三方token
             @param ThirdID 第三方id
             @param Account 第三方昵称
             */
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self otherLoginWithtokenStr:tokenStr uidStr:uidStr nameStr:nameStr type:@"2" SSDKUser:user];

                
            });
            
            
        }else if(state == SSDKResponseStateCancel){
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            [selfWeak showToastMsg:@"您已取消授权" Duration:3.0];
            
        }else if (state == SSDKResponseStateFail) {
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            [selfWeak showToastMsg:@"授权失败" Duration:3.0];
            
        }else {
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
        }
    }];
}

#pragma mark -- 判断是否需要完善资料
- (void)otherLoginWithtokenStr:(NSString *)tokenStr uidStr:(NSString *)uidStr nameStr:(NSString *)nameStr type:(NSString *)type SSDKUser:(SSDKUser *)user {
    
    AppDelegate *appDelegate = GetAppDelegates;
    PAOtherLogInRequest * req = [[PAOtherLogInRequest alloc]initWithToken:tokenStr  thirdID:uidStr Account:nameStr Type:type];
    @WeakObj(self);
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        
        [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
        NSLog(@"返回数据：%@",responseModel.data);
        _btn1.userInteractionEnabled = YES;
        
        //保存用户信息
        if (responseModel.data) {
            
            
            PAUser *user = [PAUser yy_modelWithJSON:responseModel.data];
            [[PAH5UrlManager sharedPAH5UrlManager]saveUrls:user.urllink];
            
            if (user) {
                
                [[PAUserManager sharedPAUserManager]integrationUserData:user];
                appDelegate.userData.isLogIn = [[NSNumber alloc]initWithBool:YES];
                NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setObject:user.userinfo.opid?:@"" forKey:@"PAUserOpId"];
                [userDefault synchronize];
                appDelegate.userData.taglist = user.taglist;
                appDelegate.isupgrade = user.userinfo.isupgrade;
                [appDelegate saveContext];
                [appDelegate setMsgSaveName];
                //今天插件的Token
                NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:WIDGET_GROUP_ID];
                [shared setObject:appDelegate.userData.token forKey:@"widget"];
                [shared synchronize];
                
                //更新该社区的权限,调试期间先固定社区 "平安社区石家庄"
                //[[PAAuthorityManager sharedPAAuthorityManager]fetchAuthorityWithCommunityId:appDelegate.userData.communityid];
                
                /**
                 *  性别，小区为空跳转到完善资料界面
                 */
                if (appDelegate.userData.sex.intValue == 0 || [appDelegate.userData.communityid isEqualToString:@"0"] || [XYString isBlankString:appDelegate.userData.communityid]) {
                    
                    [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                    
                    
                    
                    [self getChatRecord];
                    
                    PerfectInforVC * regVC=[self.storyboard instantiateViewControllerWithIdentifier:@"PerfectInforVC"];
                    regVC.isFromThirdBinding = YES;
                    regVC.thirdToken = tokenStr;
                    regVC.thirdName = nameStr;
                    regVC.thirdID = uidStr;
                    regVC.type = type;
                    [self.navigationController pushViewController:regVC animated:YES];
                    
                }else {
                    
                    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainTabBar" bundle:nil];
                    MainTabBars * MainTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBars"];
                    appDelegate.window.rootViewController=MainTabBar;
                    
                    ///绑定标签
                    [AppSystemSetPresenters getBindingTag];
                    
                    CATransition * animation =  [AnimtionUtils getAnimation:2 subtag:2];
                    [MainTabBar.view.window.layer addAnimation:animation forKey:nil];
                    
                    [self getChatRecord];
                }
            }
        }
        
        
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        
        
        NSLog(@"权限获取失败");
        [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
        if (error.code == 10011) {
            //未绑定
            ZSY_PhoneNumberBinding *phoneNumber = [[ZSY_PhoneNumberBinding alloc] init];
            phoneNumber.type = type;
            phoneNumber.thirdName = user.nickname;
            phoneNumber.thirdID = user.uid;
            phoneNumber.thirdToken = tokenStr;
            
            if (![self.navigationController.childViewControllers[0] isKindOfClass:[ZSY_PhoneNumberBinding class]]) {
                
                [selfWeak.navigationController pushViewController:phoneNumber animated:YES];
            }
            
        }else{
//            [selfWeak showToastMsg:[error.userInfo objectForKey:@"NSLocalizedDescription"] Duration:3.0f];
        }
        
        
    }];
   
}
-(void)getChatRecord {
    
    AppDelegate * appDelegateTemp = GetAppDelegates;
    NSNumber * maxid = [[NSUserDefaults standardUserDefaults]objectForKey:appDelegateTemp.userData.userID];
    
    [ChatPresenter getUserGamSync:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode == SucceedCode)
            {
                NSArray * list = data;
                NSLog(@"---------%@",data);
                
                for (int i = 0;i<list.count ;i++) {
                    
                    NSDictionary * map  = [list objectAtIndex:i];
                    NSString * content = [map objectForKey:@"content"];
                    NSString * fileurl = [map objectForKey:@"fileurl"];
                    NSString * msgtype = [map objectForKey:@"msgtype"];
                    NSString * senduserid = [map objectForKey:@"senduserid"];
                    NSString * sendusername = [map objectForKey:@"sendusername"];
                    NSString * senduserpic = [map objectForKey:@"senduserpic"];
                    NSString * systime = [map objectForKey:@"systime"];
                    //                                NSString * type = [map objectForKey:@"type"];
                    NSDate * systime_date = [DateUitls DateFromString:systime DateFormatter:@"YYYY-MM-dd HH:mm:ss"];
                    
                    
                    Gam_Chat * GC = (Gam_Chat *)[[DataOperation sharedDataOperation]creatManagedObj:@"Gam_Chat"];
                    GC.chatID = senduserid;
                    GC.sendID = senduserid;
                    
                    GC.isFirstMsg = @(YES);
                    GC.systime = systime_date;
                    GC.headPicUrl = senduserpic;
                    
                    //
                    //                            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    //
                    //
                    //                            });
                    [[DataOperation sharedDataOperation] queryData:@"Gam_Chat" withHeadPicUrl:senduserpic andChatID:senduserid andnikeName:sendusername];
                    
                    
                    GC.isRead = @(NO);
                    GC.ownerType = @(XMMessageOwnerTypeOther);
                    GC.sendName = sendusername;
                    if(appDelegateTemp.userData!=nil&&appDelegateTemp.userData.userID!=nil)
                    {
                        GC.userID=appDelegateTemp.userData.userID;
                        GC.receiveID = appDelegateTemp.userData.userID;
                        
                    }
                    GC.msgType = @(msgtype.integerValue);
                    ///0 文字 1 照片 2 语音
                    if (msgtype.integerValue==0) {
                        GC.cellIdentifier = @"XMTextMessageCell";
                        GC.content = content;
                        
                    }
                    else if(msgtype.integerValue==1)
                    {
                        GC.cellIdentifier = @"XMImageMessageCell";
                        GC.contentPicUrl = fileurl;
                        GC.content = @"[图片]";
                        
                    }else if(msgtype.integerValue==2)
                    {
                        GC.cellIdentifier = @"XMVoiceMessageCell";
                        GC.voiceUrl = fileurl;
                        NSLog(@"录音文件－－－%@",fileurl);
                        GC.seconds = @(content.intValue);
                        GC.content = @"[语音]";
                        GC.voiceUnRead = @(YES);
                    }else if(msgtype.integerValue == 3)
                    {
                        
                        GC.cellIdentifier = @"XMMImageTextMessageCell";
                        GC.contentPicUrl = fileurl;
                        GC.content = content;
                    }else
                    {
                        GC.cellIdentifier = @"XMTextMessageCell";
                        GC.content = content;
                    }
                    
                    [[DataOperation sharedDataOperation]save];
                }
            }
        });
        
    } withMaxID:[NSString stringWithFormat:@"%@",maxid]];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:nil];
    
}


//MARK: - 获取当前时间
- (void)getNowTime {
    NSString *beginTimeStr = [DateUitls getTodayDateFormatter:@"yyyy-MM-dd HH:mm:ss"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:beginTimeStr forKey:@"beginLoginTime"];//保存登录时间
    [userDefaults synchronize];
}


@end

