//
//  ZSY_PhoneNumberBinding.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_PhoneNumberBinding.h"
#import "RegularUtils.h"
#import "LogInPresenter.h"
#import "MySettingAndOtherLogin.h"
#import "THMyInfoPresenter.h"
#import "PerfectInforVC.h"
#import "MainTabBars.h"
#import "AppSystemSetPresenters.h"
#import "AppDelegate+JPush.h"
#import "PAOtherLogInRequest.h"
#import "PAH5UrlManager.h"

@interface ZSY_PhoneNumberBinding ()<UITextFieldDelegate>
{
    //倒计时
    LogInPresenter * logInPresenter;
    dispatch_source_t _timer;
    __block int timeout;
    /**
     判断当前手机号是否绑定
     */
    BOOL isBinding;
    
}
@end

@implementation ZSY_PhoneNumberBinding

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    isBinding = NO;
    _captchaCodTF.enabled = NO;
    _password_TF.enabled = NO;
    
    self.navigationController.navigationBarHidden = NO;
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
    //如果从发帖页面推出，则销毁这个页面
    if ([_IDStr isEqualToString:@"postPush"]) {
        NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
        
        [navigationArray removeObjectAtIndex: 1];  // 移除指定的controller
        self.navigationController.viewControllers = navigationArray;
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BLACKGROUND_COLOR;
    self.navigationItem.title = @"绑定手机号";
    
    /** 密码 */
    _passWordBgView.layer.borderColor = TEXT_COLOR.CGColor;
    _passWordBgView.layer.borderWidth = 1.0;

    _password_TF.delegate = self;
    [_password_TF addTarget:self action:@selector(TF_PWChangeEvent:) forControlEvents:UIControlEventEditingChanged];
    _password_TF.keyboardType = UIKeyboardTypeASCIICapable;

    
    /**
     手机号
     */
    _phoneNumberBGView.layer.borderWidth = 1.0;
    _phoneNumberBGView.layer.borderColor = TEXT_COLOR.CGColor;
    _phoneNumberBGView.backgroundColor = BLACKGROUND_COLOR;
    
    _phoneNumberTF.backgroundColor = [UIColor clearColor];
    _phoneNumberTF.delegate = self;
    _phoneNumberTF.keyboardType = UIKeyboardTypePhonePad;
    
    [_phoneNumberTF addTarget:self action:@selector(TF_PhoneChangeEvent:) forControlEvents:UIControlEventEditingChanged];
    
    /**
     验证码
     */
    _codTfBgView.layer.borderWidth = 1.0;
    _codTfBgView.layer.borderColor = TEXT_COLOR.CGColor;
    _codTfBgView.backgroundColor = BLACKGROUND_COLOR;
    
    _captchaCodTF.delegate = self;
    _captchaCodTF.backgroundColor = [UIColor clearColor];
    _captchaCodTF.keyboardType = UIKeyboardTypePhonePad;
    
    /**
     发送验证码
     */
    _fasong.backgroundColor = kNewRedColor;
    
    /**
     收不到验证码
     */
    [_DoNotGetButton setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    _DoNotGetButton.hidden = YES;
    /**
     绑定
     */
    _bindingButton.userInteractionEnabled = NO;
    [_bindingButton setBackgroundColor:(UIColorFromRGB(0xb7b8b9))];
}
///发送验证码
- (IBAction)sendButton:(id)sender {
    
    if ([XYString isBlankString:_phoneNumberTF.text]) {
        [self showToastMsg:@"手机号不能为空,请重新输入" Duration:3.0];
        
        return;
    }
    if(![RegularUtils isPhoneNum:_phoneNumberTF.text])//验证手机号正确
    {
        [self showToastMsg:@"手机号不正确,请重新输入" Duration:3.0];
        return;
    }
    NSLog(@"发送验证码");
    
    /**
     *type     2是为第三方验证短信
     *Platform 平台类型 1QQ 2微信 3微博
     *Account  用户昵称(第三方)
     **/
    logInPresenter=[LogInPresenter new];
    NSLog(@"%@",logInPresenter);
//     = [[LogInPresenter alloc] init];
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self];
    [self Countdown];
    
    NSLog(@"%@",_phoneNumberTF.text);
    NSLog(@"%@",_type);
    NSLog(@"%@",_thirdName);
    
    @WeakObj(self)
    [logInPresenter getNewCAPTCHAForPhoneNum:_phoneNumberTF.text type:@"2" andPlatform:_type andAccount:_thirdName upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [indicator stopAnimating];
            
            if(resultCode==SucceedCode) {
                
                _captchaCodTF.enabled = YES;
                _password_TF.enabled = YES;

                [selfWeak showToastMsg:@"验证码已发送成功" Duration:3.0];
                
            }else {


//                if ([data isKindOfClass:[NSArray class]]) {
//                    [selfWeak showToastMsg:(NSString *)data[0] Duration:3.0f];
//                    if ([data[1] isEqualToString:@"10008"]) {
//                        
//                        dispatch_source_cancel(_timer);
//                        //手机号已经绑定
//                        isBinding = YES;
//                        _fasong.userInteractionEnabled = NO;
//                        [_fasong setBackgroundColor:(UIColorFromRGB(0xb7b8b9))];
//                        [_fasong setTitle:@"发送验证码" forState:UIControlStateNormal];
//                        _bindingButton.userInteractionEnabled = YES;
//                        [_bindingButton setBackgroundColor:kNewRedColor];
//                        _password_TF.text = @"";
//                        _password_TF.enabled = NO;
//                        _captchaCodTF.enabled = NO;
//                        
//                        
//                    }else {
//                        
//                    }
//                }else if([data isKindOfClass:[NSString class]]) {
//                    
//                    [selfWeak showToastMsg:(NSString *)data Duration:3.0];
//                }

                NSLog(@"%@",data);
            }
        });
    }];
}

//绑定
- (IBAction)bindingClick:(id)sender {

    [self.view endEditing:YES];
    
    if (!isBinding) {
        
        if ([XYString isBlankString:_captchaCodTF.text]) {
            [self showToastMsg:@"验证码不能为空,请重新输入" Duration:3.0];
            return;
        }
        
        if ([XYString isBlankString:_password_TF.text]) {
            [self showToastMsg:@"密码不能为空,请重新输入" Duration:3.0];
            return;
        }
        
        if (_password_TF.text.length != 6) {
            [self showToastMsg:@"请输正确的6位密码!" Duration:3.0];
            return;
        }
        
        NSString * regex  = @"[A-Z0-9a-z!@#$%^&*.~/\\{\\}|()'\"?><,.`\\+-=_\\[\\]:;]+";
        NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        BOOL b = [predicte evaluateWithObject:_password_TF.text];
        if (!b || (_password_TF.text.length!=6)) {
            _password_TF.text=@"";
            [self showToastMsg:@"请输入正确的密码格式！" Duration:3.0];
            return;
        }
        
    }
    
    if ([XYString isBlankString:_phoneNumberTF.text]) {
        [self showToastMsg:@"手机号不能为空,请重新输入" Duration:3.0];
        
        return;
    }
    if(![RegularUtils isPhoneNum:_phoneNumberTF.text])//验证手机号正确
    {
        [self showToastMsg:@"手机号不正确,请重新输入" Duration:3.0];
        return;
    }
    
    NSString *codStr = [XYString IsNotNull:_captchaCodTF.text];
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    
    [MySettingAndOtherLogin addNewOtherBindingWithType:_type AndThifdToken:_thirdToken AndPhone:_phoneNumberTF.text AndPassword:_password_TF.text andThirdid:_thirdID andAccount:_thirdName AndVerificode:codStr AndUnionID:@"" AndUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (resultCode == SucceedCode) {
                
                [self otherLogin];
                
            }else {
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                [self showToastMsg:(NSString *)data Duration:3.0];
            }
        });
        
    }];
    
}
//密码
- (void)TF_PWChangeEvent:(UITextField *)sender {
    
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>=6)
        {
            sender.text=[sender.text substringToIndex:6];
        }
    }
    
}
//手机号
- (void)TF_PhoneChangeEvent:(UITextField *)sender {
    
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
    
        if(sender.text.length>=11) {
            
            sender.text=[sender.text substringToIndex:11];
            
        }else {
            
            _fasong.userInteractionEnabled = YES;
            [_fasong setBackgroundColor:kNewRedColor];
            [_fasong setTitle:@"发送验证码" forState:UIControlStateNormal];
            
            _password_TF.enabled = NO;
            _captchaCodTF.enabled = NO;
            
            _password_TF.text = @"";
            _captchaCodTF.text = @"";
            
            isBinding = NO;
            
            _bindingButton.userInteractionEnabled = NO;
            [_bindingButton setBackgroundColor:(UIColorFromRGB(0xb7b8b9))];
        }
        
    }
    
}
#pragma mark -- textFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (isBinding) {
        return;
    }
    if (_phoneNumberTF.text.length > 0 && _captchaCodTF.text.length >= 4 && ![XYString isBlankString:_password_TF.text]) {
        _bindingButton.userInteractionEnabled = YES;
        [_bindingButton setBackgroundColor:kNewRedColor];
    }else {
        [_bindingButton setBackgroundColor:(UIColorFromRGB(0xb7b8b9))];
        _bindingButton.userInteractionEnabled = NO;
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}

#pragma mark -- 完善资料
- (void)otherLogin {
    
//    [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
//    
//    UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"LogInRegister" bundle:nil];
//    PerfectInforVC *regVC = [myStoryBoard instantiateViewControllerWithIdentifier:@"PerfectInforVC"];
//    regVC.type = self.type;
//    regVC.thirdName = self.thirdName;
//    regVC.thirdToken = self.thirdToken;
//    regVC.thirdID = self.thirdID;
//    regVC.isFromThirdBinding = YES;
//    [self.navigationController pushViewController:regVC animated:YES];
//    return;
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSLog(@"%@",appDelegate.userData.userpic);
    NSLog(@"%@",appDelegate.userData.nickname);
    NSLog(@"%d",appDelegate.userData.sex.intValue);
    NSLog(@"%@",appDelegate.userData.birthday);
    NSLog(@"%@",appDelegate.userData.communityid);
    

    if (!isBinding){

        [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];

        UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"LogInRegister" bundle:nil];
        PerfectInforVC *regVC = [myStoryBoard instantiateViewControllerWithIdentifier:@"PerfectInforVC"];
        regVC.type = self.type;
        regVC.thirdName = self.thirdName;
        regVC.thirdToken = self.thirdToken;
        regVC.thirdID = self.thirdID;
        regVC.isFromThirdBinding = YES;
        [self.navigationController pushViewController:regVC animated:YES];
        
    }else {
        
        PAOtherLogInRequest * req = [[PAOtherLogInRequest alloc]initWithToken:self.thirdToken  thirdID:self.thirdID Account:self.thirdName Type:self.type];
        @WeakObj(self);
        [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
            
            
            NSLog(@"返回数据：%@",responseModel.data);
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
                    
                }
            /**
             *  性别，小区为空跳转到完善资料界面
             */
            if (appDelegate.userData.sex.intValue == 0 || [appDelegate.userData.communityid isEqualToString:@"0"] || [XYString isBlankString:appDelegate.userData.communityid]) {
                UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"LogInRegister" bundle:nil];
                PerfectInforVC *regVC = [myStoryBoard instantiateViewControllerWithIdentifier:@"PerfectInforVC"];
                regVC.type = self.type;
                regVC.thirdName = self.thirdName;
                regVC.thirdToken = self.thirdToken;
                regVC.thirdID = self.thirdID;
                regVC.isFromThirdBinding = YES;
                [self.navigationController pushViewController:regVC animated:YES];
                
            }else{
                
                UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainTabBar" bundle:nil];
                MainTabBars * MainTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBars"];
                appDelegate.window.rootViewController=MainTabBar;
                
                ///绑定标签
                [AppSystemSetPresenters getBindingTag];
                
                CATransition * animation =  [AnimtionUtils getAnimation:2 subtag:2];
                [MainTabBar.view.window.layer addAnimation:animation forKey:nil];
            }
            }
        } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
            
            NSLog(@"权限获取失败");
            [selfWeak showToastMsg:@"登录失败！" Duration:5.0];
            AppDelegate * appdelegate = GetAppDelegates;
            [appdelegate setTags:nil error:nil];
            appdelegate.userData.token = @"";
            [appdelegate saveContext];
            
        }];
    }
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
                [self.fasong setTitle:@"重发验证码" forState:UIControlStateNormal];
                self.fasong.userInteractionEnabled = YES;
                [_fasong setBackgroundColor:kNewRedColor];

            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                _fasong.userInteractionEnabled = NO;
                [_fasong setBackgroundColor:(UIColorFromRGB(0xb7b8b9))];
                
                self.fasong.titleLabel.text = [NSString stringWithFormat:@"发送中(%@)",strTime];
                [self.fasong setTitle:[NSString stringWithFormat:@"发送中(%@)",strTime] forState:UIControlStateNormal];
                [self.fasong setTitle:[NSString stringWithFormat:@"发送中(%@)",strTime] forState:UIControlStateDisabled];
                
                self.fasong.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}

@end
