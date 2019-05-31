//
//  FindPWVC.m
//  TimeHomeApp
//
//  Created by us on 16/2/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "FindPWVC.h"
#import "LogInPresenter.h"
#import "RegularUtils.h"
#import "ZSY_LoginHelp.h"
@interface FindPWVC ()
{
    LogInPresenter * logInPresenter;
    //倒计时
    dispatch_source_t _timer;
    __block int timeout;
}
/**
 *  账号
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_Account;


/**
 *  验证码
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_VerCode;
/**
 *  密码
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_PassWord;

/**
 *  获取验这证码按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_GetVerCode;
/**
 *  显示密码按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_ShowPw;
///提交
@property (weak, nonatomic) IBOutlet UIButton *btn_SumbitEvent;

@end

@implementation FindPWVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.TF_PassWord.placeholder = @"6位密码(数字、字母、特殊符号)";
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
    ///数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate markStatistics:DengLu];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ///数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":DengLu}];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    
    
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
}
#pragma mark -------初始化---------

-(void)initView
{
    logInPresenter=[LogInPresenter new];
    
    UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.TF_Account.leftViewMode = UITextFieldViewModeAlways;
    self.TF_Account.leftView = leftview;
    leftview.userInteractionEnabled=NO;

    UIView *leftview1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.TF_VerCode.leftViewMode = UITextFieldViewModeAlways;
    self.TF_VerCode.leftView = leftview1;
    leftview.userInteractionEnabled=NO;
    
    UIView *leftview2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.TF_PassWord.leftViewMode = UITextFieldViewModeAlways;
    self.TF_PassWord.leftView = leftview2;
    leftview.userInteractionEnabled=NO;

}



#pragma mark -------事件处理---------
/**
 *  账号输入改变
 *
 *  @param sender <#sender description#>
 */
- (IBAction)TF_AccChange:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>=11)
        {
            sender.text=[sender.text substringToIndex:11];
        }
    }
}
/**
 *  获取验证码事件
 *
 *  @param sender <#sender description#>
 */

- (IBAction)btn_GetVerCodeEvent:(UIButton *)sender {
    if(![RegularUtils isPhoneNum:self.TF_Account.text])//验证手机号正确
    {
        [self showToastMsg:@"手机号不正确,请重新输入" Duration:5];
        return;
    }
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self];
    [self Countdown];
    @WeakObj(self);
    [logInPresenter getCAPTCHAForPhoneNum:self.TF_Account.text type:@"1" andPlatform:@"" andAccount:@"" upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            if(resultCode==SucceedCode)
            {
                [selfWeak showToastMsg:(NSString *)data Duration:5.0];
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
 *  验证码输入改变
 *
 *  @param sender <#sender description#>
 */
- (IBAction)TF_VerCodeChange:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>=4)
        {
            sender.text=[sender.text substringToIndex:4];
        }
    }

}

/**
 *  密码输入改变
 *
 *  @param sender <#sender description#>
 */
- (IBAction)TF_PWChange:(UITextField *)sender {
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(sender.text.length>6)
        {
            sender.text=[sender.text substringToIndex:6];
        }
    }
}
/**
 *  显示密码
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_ShowPWEvent:(UIButton *)sender {
    self.btn_ShowPw.selected=!self.btn_ShowPw.selected;
    if(sender.selected)
    {
        self.TF_PassWord.secureTextEntry=NO;
        [sender setImage:[UIImage imageNamed:@"登录注册_密码可见"] forState:UIControlStateNormal];
    }
    else
    {
        self.TF_PassWord.secureTextEntry=YES;
        [sender setImage:[UIImage imageNamed:@"登录注册_密码不可见"] forState:UIControlStateNormal];
    }

}
/**
 *  提交事件
 *
 *  @param sender
 */
- (IBAction)btn_Submit:(UIButton *)sender {
    
    NSString * regex  = @"[A-Z0-9a-z!@#$%^&*.~/\\{\\}|()'\"?><,.`\\+-=_\\[\\]:;]+";
    
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL b = [predicte evaluateWithObject:self.TF_PassWord.text];
    
    if (!b||(self.TF_PassWord.text.length!=6)) {
        self.TF_PassWord.text = @"";
        [self showToastMsg:@"请输入正确的密码格式！" Duration:5];
        return;
    }

    
    if(![RegularUtils isPhoneNum:self.TF_Account.text])//验证手机号正确
    {
        [self showToastMsg:@"手机号不正确,请重新输入" Duration:5];
        return;
    }
    if([self.TF_VerCode.text isEqualToString:@""])
    {
        [self showToastMsg:@"验证码不能为空!" Duration:5];
        return;
    }
    if(self.TF_VerCode.text.length!=4)
    {
        [self showToastMsg:@"请输入4位验证码!" Duration:5];
        return;
    }
    
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self];
    @WeakObj(self);
    [logInPresenter findPWForPhoneNum:self.TF_Account.text Pw:self.TF_PassWord.text verificode:self.TF_VerCode.text upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [indicator stopAnimating];
            if(resultCode==SucceedCode)
            {
                [selfWeak showToastMsg:@"密码找回成功,请重新登录!" Duration:5.0];
                [selfWeak.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                if (![XYString isBlankString:data]) {
                    [selfWeak showToastMsg:(NSString *)data Duration:5.0];
                }
            }
            
        });

    }];
    
}

/**
 帮助与反馈
 */
- (IBAction)helpAndFaceBack:(id)sender {
    ZSY_LoginHelp *help = [[ZSY_LoginHelp alloc] init];
    [self.navigationController pushViewController:help animated:YES];
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
                [self.btn_GetVerCode setTitle:@"重发验证码" forState:UIControlStateNormal];
                self.btn_GetVerCode.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                self.btn_GetVerCode.titleLabel.text = [NSString stringWithFormat:@"发送中(%@)",strTime];
                [self.btn_GetVerCode setTitle:[NSString stringWithFormat:@"发送中(%@)",strTime] forState:UIControlStateNormal];
                [self.btn_GetVerCode setTitle:[NSString stringWithFormat:@"发送中(%@)",strTime] forState:UIControlStateDisabled];
                
                self.btn_GetVerCode.userInteractionEnabled = NO;
                
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
