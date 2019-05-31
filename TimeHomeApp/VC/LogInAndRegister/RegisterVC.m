//
//  RegisterVC.m
//  TimeHomeApp
//
//  Created by us on 16/2/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RegisterVC.h"
#import "PerfectInforVC.h"
#import "LogInPresenter.h"
#import "RegularUtils.h"
#import "MainTabBars.h"
#import "L_NewPointPresenters.h"

@interface RegisterVC ()
{
    LogInPresenter * logInPresenter;
    //倒计时
    dispatch_source_t _timer;
    __block int timeout;

}
/**
 *  输入手机号
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_InputPhone;

/**
 *  输入验证码
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_InputVerifCode;
/**
 *  设置密码
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_SettingPW;
/**
 *  第二步进度展示
 */
@property (weak, nonatomic) IBOutlet UIView *view_LineOne;
/**
 *  第三步进度展示
 */
@property (weak, nonatomic) IBOutlet UIView *view_LineTwo;
/**
 *  第一步展示
 */
@property (weak, nonatomic) IBOutlet UIImageView *img_One;
/**
 *  第二步展示
 */
@property (weak, nonatomic) IBOutlet UIImageView *img_Two;
/**
 *  第三步展示
 */
@property (weak, nonatomic) IBOutlet UIImageView *img_Three;
/**
 *  输入提示
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Prompt;

/**
 *  内容输入
 */
@property (weak, nonatomic) IBOutlet UITextField *tf_Content;
/**
 *  按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_Go;

/**
 *  重发验证码
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_ReSendVerCode;
/**
 *  重发按钮宽度，用于隐藏
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nslay_ReSendWidth;
/**
 *  输入框右边距，用于隐藏
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_Right;

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [super.navigationController setNavigationBarHidden:NO animated:TRUE];
    if (_setup==1)
    {
        [self Countdown];
    }
//    [TalkingData trackPageBegin:@"zhuceye"];
    ///数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate markStatistics:ZhuCeYe];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [TalkingData trackPageEnd:@"zhuceye"];
    ///数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":ZhuCeYe}];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
    
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":ZhuCeYe}];

}

#pragma mark -------初始化---------

-(void)initView
{
    
    logInPresenter=[LogInPresenter new];
    
    UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.tf_Content.leftViewMode = UITextFieldViewModeAlways;
    self.tf_Content.leftView = leftview;
    leftview.userInteractionEnabled=NO;
    self.btn_Go.userInteractionEnabled=NO;
    self.btn_Go.backgroundColor=UIColorFromRGB(0xf1f1f1);
    if(_setup==0)
    {
        
        self.btn_ReSendVerCode.hidden=YES;
        self.nslay_ReSendWidth.constant=0;
        self.nsLay_Right.constant=0;
        self.tf_Content.keyboardType=UIKeyboardTypePhonePad;
    }
    else if (_setup==1)
    {
        [self Countdown];
         self.tf_Content.keyboardType=UIKeyboardTypePhonePad;
        
        self.lab_InputPhone.textColor=UIColorFromRGB(0x595353);
        
        self.lab_InputVerifCode.textColor=UIColorFromRGB(0xab2121);
        self.img_Two.image=[UIImage imageNamed:@"注册登录_步骤定位"];
        self.view_LineOne.backgroundColor=UIColorFromRGB(0xab2121);
        self.lab_Prompt.text=[NSString stringWithFormat:@"验证码短信已发送至%@",self.phoneNum==nil?@"":self.phoneNum];
        self.btn_ReSendVerCode.hidden=NO;
        [self.btn_Go setTitle:@"下一步" forState:UIControlStateNormal];
    }
    else if (_setup==2)
    {
        self.tf_Content.keyboardType=UIKeyboardTypeASCIICapable;
        self.tf_Content.secureTextEntry=YES;
        self.lab_InputPhone.textColor=UIColorFromRGB(0x595353);
        self.lab_InputVerifCode.textColor=UIColorFromRGB(0x595353);
        
        self.btn_ReSendVerCode.hidden=YES;
        self.nslay_ReSendWidth.constant=0;
        self.nsLay_Right.constant=0;
        
        self.img_Two.image=[UIImage imageNamed:@"注册登录_步骤定位"];
        self.view_LineOne.backgroundColor=UIColorFromRGB(0xab2121);
        
        self.lab_SettingPW.textColor=UIColorFromRGB(0xab2121);
        self.img_Three.image=[UIImage imageNamed:@"注册登录_步骤定位"];
        self.view_LineTwo.backgroundColor=UIColorFromRGB(0xab2121);
        self.lab_Prompt.text=@"登录密码需要设置为6位数字、字母或特殊符号";
        [self.btn_Go setTitle:@"注 册" forState:UIControlStateNormal];
    }
    
    
}

#pragma mark -------事件处理---------
/**
 *  输入变化
 *
 *  @param sender <#sender description#>
 */
- (IBAction)TF_ContentChangeEvent:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(_setup==0)//输入手机号
    {
        if(selectedRange == nil || selectedRange.empty){
            if(sender.text.length>=11)
            {
                self.btn_Go.userInteractionEnabled=YES;
                self.btn_Go.backgroundColor=UIColorFromRGB(0xab2121);
                sender.text=[sender.text substringToIndex:11];
            }
            else
            {
                self.btn_Go.userInteractionEnabled=NO;
                self.btn_Go.backgroundColor=UIColorFromRGB(0xf1f1f1);
            }
        }
    }
    else if (_setup==1)//输验证码
    {
        if(selectedRange == nil || selectedRange.empty){
            if(sender.text.length>=4)
            {
                self.btn_Go.userInteractionEnabled=YES;
                self.btn_Go.backgroundColor=UIColorFromRGB(0xab2121);
                sender.text=[sender.text substringToIndex:4];
            }
            else
            {
                self.btn_Go.userInteractionEnabled=NO;
                self.btn_Go.backgroundColor=UIColorFromRGB(0xf1f1f1);
            }
        }

    }
    else if (_setup==2)//输入密码
    {
        if(selectedRange == nil || selectedRange.empty){
            if(sender.text.length>=6)
            {
                
                self.btn_Go.userInteractionEnabled=YES;
                self.btn_Go.backgroundColor=UIColorFromRGB(0xab2121);
                sender.text=[sender.text substringToIndex:6];
            }
            else
            {
                self.btn_Go.userInteractionEnabled=NO;
                self.btn_Go.backgroundColor=UIColorFromRGB(0xf1f1f1);
            }
        }
      
    }

}

/**
 *  下一步，完成事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_GoEvent:(UIButton *)sender {
    @WeakObj(self);
//    PerfectInforVC * regVC=[selfWeak.storyboard instantiateViewControllerWithIdentifier:@"PerfectInforVC"];
//    [selfWeak.navigationController pushViewController:regVC animated:YES];
//    return;
//    if(_setup==0)
//    {
//        [self Countdown];
//        self.phoneNum=selfWeak.tf_Content.text;
//        self.tf_Content.text=@"";
//        self.tf_Content.keyboardType=UIKeyboardTypePhonePad;
//        
//        self.lab_InputPhone.textColor=UIColorFromRGB(0x595353);
//        
//        self.lab_InputVerifCode.textColor=UIColorFromRGB(0xab2121);
//        self.img_Two.image=[UIImage imageNamed:@"注册登录_步骤定位"];
//        self.view_LineOne.backgroundColor=UIColorFromRGB(0xab2121);
//        
//        self.lab_Prompt.text=[NSString stringWithFormat:@"验证码短信已发送至%@",self.phoneNum==nil?@"":self.phoneNum];
//        self.btn_ReSendVerCode.hidden=NO;
//        self.nslay_ReSendWidth.constant=110;
//        self.nsLay_Right.constant=5;
//        [self.btn_Go setTitle:@"下一步" forState:UIControlStateNormal];
//        self.setup=1;
//        
//        self.btn_Go.userInteractionEnabled=NO;
//        self.btn_Go.backgroundColor=UIColorFromRGB(0xf1f1f1);
//        NSLog(@"phoneNum==%@",self.phoneNum);
//    }
//    else if(_setup==1)
//    {
//        self.verifiCode=selfWeak.tf_Content.text;
//        self.tf_Content.text=@"";
//        self.tf_Content.secureTextEntry=YES;
//        self.lab_InputPhone.textColor=UIColorFromRGB(0x595353);
//        self.lab_InputVerifCode.textColor=UIColorFromRGB(0x595353);
//        
//        self.btn_ReSendVerCode.hidden=NO;
//        self.nslay_ReSendWidth.constant=0;
//        self.nsLay_Right.constant=0;
//        
//        self.img_Two.image=[UIImage imageNamed:@"注册登录_步骤定位"];
//        self.view_LineOne.backgroundColor=UIColorFromRGB(0xab2121);
//        
//        self.lab_SettingPW.textColor=UIColorFromRGB(0xab2121);
//        self.img_Three.image=[UIImage imageNamed:@"注册登录_步骤定位"];
//        self.view_LineTwo.backgroundColor=UIColorFromRGB(0xab2121);
//        self.lab_Prompt.text=@"登录密码需要设置为6位数字或字符";
//        [self.btn_Go setTitle:@"注 册" forState:UIControlStateNormal];
//        
//        self.setup=2;
//        self.btn_Go.userInteractionEnabled=NO;
//        self.btn_Go.backgroundColor=UIColorFromRGB(0xf1f1f1);
//        NSLog(@"phoneNum==%@",self.phoneNum);
//    }
//    else if(_setup==2)
//    {
//        NSLog(@"phoneNum==%@",self.phoneNum);
//        if(![RegularUtils isPhoneNum:self.phoneNum])//验证手机号正确
//        {
//            [self showToastMsg:@"手机号不正确,请重新输入" Duration:5];
//            return;
//        }
//    }
//    return;
    [self.view endEditing:YES];
    
    if(_setup==0)//输入手机号
    {
        if(![RegularUtils isPhoneNum:self.tf_Content.text])//验证手机号正确
        {
            self.tf_Content.text=@"";
            self.btn_Go.userInteractionEnabled=NO;
            self.btn_Go.backgroundColor=UIColorFromRGB(0xf1f1f1);
            [self showToastMsg:@"手机号不正确,请重新输入" Duration:5];
            return;
        }
        THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
        [indicator startAnimating:self];
        [logInPresenter getCAPTCHAForPhoneNum:self.tf_Content.text type:@"0" andPlatform:@"" andAccount:@"" upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
                if(resultCode==SucceedCode)
                {
                    [self Countdown];
                    self.phoneNum=selfWeak.tf_Content.text;
                    self.tf_Content.text=@"";
                    self.tf_Content.keyboardType=UIKeyboardTypePhonePad;
                    
                    self.lab_InputPhone.textColor=UIColorFromRGB(0x595353);
                    
                    self.lab_InputVerifCode.textColor=UIColorFromRGB(0xab2121);
                    self.img_Two.image=[UIImage imageNamed:@"注册登录_步骤定位"];
                    self.view_LineOne.backgroundColor=UIColorFromRGB(0xab2121);
                    
                    self.lab_Prompt.text=[NSString stringWithFormat:@"验证码短信已发送至%@",self.phoneNum==nil?@"":self.phoneNum];
                    self.btn_ReSendVerCode.hidden=NO;
                    self.nslay_ReSendWidth.constant=110;
                    self.nsLay_Right.constant=5;
                    [self.btn_Go setTitle:@"下一步" forState:UIControlStateNormal];
                    self.setup=1;
                    
                    self.btn_Go.userInteractionEnabled=NO;
                    self.btn_Go.backgroundColor=UIColorFromRGB(0xf1f1f1);
//                    RegisterVC * regVC=[selfWeak.storyboard instantiateViewControllerWithIdentifier:@"RegisterVC"];
//                    regVC.setup=1;
//                    regVC.phoneNum=selfWeak.tf_Content.text;
//                    [selfWeak.navigationController pushViewController:regVC animated:YES];
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
    }else if (_setup==1)//输入验证码
    {
        if(self.tf_Content.text.length!=4)
        {
            self.tf_Content.text=@"";
            self.btn_Go.userInteractionEnabled=NO;
            self.btn_Go.backgroundColor=UIColorFromRGB(0xf1f1f1);
            [self showToastMsg:@"请输入4位验证码!" Duration:5];
            return;
        }
        THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
        [indicator startAnimating:self];
        [logInPresenter checkVerificodeForPhoneNum:_phoneNum verificode:self.tf_Content.text upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {

            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
                if(resultCode==SucceedCode)
                {
//                    RegisterVC * regVC=[selfWeak.storyboard instantiateViewControllerWithIdentifier:@"RegisterVC"];
//                    regVC.setup=2;
//                    regVC.phoneNum=_phoneNum;
//                    regVC.verifiCode=selfWeak.tf_Content.text;
//                    [selfWeak.navigationController pushViewController:regVC animated:YES];
                    self.verifiCode=selfWeak.tf_Content.text;
                    self.tf_Content.text=@"";
                    self.tf_Content.secureTextEntry=YES;
                    self.lab_InputPhone.textColor=UIColorFromRGB(0x595353);
                    self.lab_InputVerifCode.textColor=UIColorFromRGB(0x595353);
                    
                    self.btn_ReSendVerCode.hidden=NO;
                    self.nslay_ReSendWidth.constant=0;
                    self.nsLay_Right.constant=0;
                    
                    self.img_Two.image=[UIImage imageNamed:@"注册登录_步骤定位"];
                    self.view_LineOne.backgroundColor=UIColorFromRGB(0xab2121);
                    
                    self.lab_SettingPW.textColor=UIColorFromRGB(0xab2121);
                    self.img_Three.image=[UIImage imageNamed:@"注册登录_步骤定位"];
                    self.view_LineTwo.backgroundColor=UIColorFromRGB(0xab2121);
                    self.lab_Prompt.text=@"登录密码需要设置为6位数字或字符";
                    [self.btn_Go setTitle:@"注 册" forState:UIControlStateNormal];
                    
                    self.setup=2;
                    self.btn_Go.userInteractionEnabled=NO;
                    self.btn_Go.backgroundColor=UIColorFromRGB(0xf1f1f1);

                }
                else
                {
                    [selfWeak showToastMsg:(NSString *)data Duration:5.0];
                }
            });
        }];

    }
    else if (_setup==2)//开始注册功能
    {
        self.tf_Content.keyboardType = UIKeyboardTypeASCIICapable;
        NSString * regex  = @"[A-Z0-9a-z!@#$%^&*.~/\\{\\}|()'\"?><,.`\\+-=_\\[\\]:;]+";
        NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        BOOL b = [predicte evaluateWithObject:self.tf_Content.text];
        if (!b||(self.tf_Content.text.length!=6)) {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
            
            self.tf_Content.text=@"";
            self.btn_Go.userInteractionEnabled=NO;
            self.btn_Go.backgroundColor=UIColorFromRGB(0xf1f1f1);
            [self showToastMsg:@"请输入正确的密码格式！" Duration:5];
            return;
        }
        
        THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
        [indicator startAnimating:self];
        [logInPresenter registerForPhoneNum:self.phoneNum Pw:self.tf_Content.text verificode:_verifiCode upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {

            dispatch_async(dispatch_get_main_queue(), ^{
                
                [indicator stopAnimating];
                if(resultCode==SucceedCode)
                {
                    
                    //--------------------------------------------------
                    //注册成功，登录请求
                    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
                    [indicator startAnimating:self];
                    [logInPresenter logInForAcc:_phoneNum Pw:self.tf_Content.text upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {

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
                                    
                                    PerfectInforVC * regVC=[selfWeak.storyboard instantiateViewControllerWithIdentifier:@"PerfectInforVC"];
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
}

/**
 *  验证码重发
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_ReSendEvent:(UIButton *)sender {
    
        THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
        [indicator startAnimating:self];
        [self Countdown];
        [logInPresenter getCAPTCHAForPhoneNum:_phoneNum type:@"0" andPlatform:@"" andAccount:@"" upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            [indicator stopAnimating];
            if(resultCode==SucceedCode)
            {
                [self showToastMsg:(NSString *)data Duration:5.0];
            }
            else
            {
                [self showToastMsg:(NSString *)data Duration:5.0];
            }
        }];
    
}


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
                [self.btn_ReSendVerCode setTitle:@"重发验证码" forState:UIControlStateNormal];
                self.btn_ReSendVerCode.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                self.btn_ReSendVerCode.titleLabel.text = [NSString stringWithFormat:@"重发(%@)",strTime];
                [self.btn_ReSendVerCode setTitle:[NSString stringWithFormat:@"重发(%@)",strTime] forState:UIControlStateNormal];
                [self.btn_ReSendVerCode setTitle:[NSString stringWithFormat:@"重发(%@)",strTime] forState:UIControlStateDisabled];
                
                self.btn_ReSendVerCode.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
