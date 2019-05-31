//
//  L_WithdrawMoneyViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_WithdrawMoneyViewController.h"
#import "AppPayPresenter.h"

#import "L_NewMinePresenters.h"

#import "RegularUtils.h"
#import "UserPointAndMoneyPresenters.h"

@interface L_WithdrawMoneyViewController () <UITextFieldDelegate>
{
    NSInteger selectIndex;
    AppDelegate *appdelegate;
}

@property (weak, nonatomic) IBOutlet UIImageView *firstSelectView;
@property (weak, nonatomic) IBOutlet UIImageView *secondSelectView;

/**
 内容
 */
@property (weak, nonatomic) IBOutlet UILabel *content_Label;

/**
 余额
 */
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;


/**
 支付宝
 */
@property (weak, nonatomic) IBOutlet UIView *firstPayBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstPayBgViewHeightConstraint;

@end

@implementation L_WithdrawMoneyViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *appDlgt = GetAppDelegates;
    [appDlgt markStatistics:YuE];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    AppDelegate *appDlgt = GetAppDelegates;
    [appDlgt addStatistics:@{@"viewkey":YuE}];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initForSomeviews];               //初始化一些view
}

/**
 初始化一些view
 */
- (void)initForSomeviews {
    
    selectIndex = 2;
    _secondSelectView.image = [UIImage imageNamed:@"选中图标"];
    
    appdelegate = GetAppDelegates;
    _moneyLabel.text = [NSString stringWithFormat:@"%.2f",appdelegate.userData.balance.floatValue];
    
    /** 隐藏支付宝 */
    _firstPayBgViewHeightConstraint.constant = 0.;
    _firstPayBgView.hidden = YES;
    
    _content_Label.text = @"*1.单次提现最高额为200元，余额不足200元的全额提现；\n2.单日提现次数最多为3次；\n3.单次提现时间间隔为1分钟，1分钟内不能重复提现。\n4.如果您的微信账户没有实名认证，则无法进行提现，敬请知晓";
    
}

- (IBAction)payButtonDidTouch:(UIButton *)sender {
    
    if (sender.tag == selectIndex) {
        return;
    }
    
    selectIndex = sender.tag;

    if (sender.tag == 1) {
        NSLog(@"支付宝");
        _firstSelectView.image = [UIImage imageNamed:@"选中图标"];
        _secondSelectView.image = [UIImage imageNamed:@"未选中图标"];

    }else {
        NSLog(@"微信支付");
        _firstSelectView.image = [UIImage imageNamed:@"未选中图标"];
        _secondSelectView.image = [UIImage imageNamed:@"选中图标"];
    }
    
}
//参数一：range,要被替换的字符串的range，如果是新键入的那么就没有字符串被替换，range.lenth=0,第二个参数：替换的字符串，即键盘即将键入或者即将粘贴到textfield的string
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (string.length == 0) {
        return YES;
    }
    //第一个参数，被替换字符串的range，第二个参数，即将键入或者粘贴的string，返回的是改变过后的新str，即textfield的新的文本内容
    NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //正则表达式
    NSString *regex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$";
    return [self isValid:checkStr withRegex:regex];
    
}
//检测改变过的文本是否匹配正则表达式，如果匹配表示可以键入，否则不能键入
- (BOOL) isValid:(NSString*)checkStr withRegex:(NSString*)regex {
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicte evaluateWithObject:checkStr];
}
/**
 提现
 */
- (IBAction)withDrawMoney:(UIButton *)sender {
    
    [self.view endEditing:YES];
    @WeakObj(self);
    if (appdelegate.userData.balance.floatValue<=0) {
        
        [self showToastMsg:@"余额不足" Duration:3.0];
        return;
    }
    
    
    NSLog(@"提现");
    if (selectIndex==1) {
        
        //支付宝
//        [AppPayPresenter doAlipayPay];

    }else {
        
        //微信支付
        NSLog(@"提现到微信");
        
        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
        
        [L_NewMinePresenters cashBalanceListWithPaytype:102 UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if (resultCode == SucceedCode) {

                    [selfWeak getUserIntergelAndAccount];
                    
//                    [selfWeak showToastMsg:@"提现成功！" Duration:3.0];

                }else {
                    [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];

                    [selfWeak showToastMsg:data Duration:3.0];
                    
                }
                
            });
            
        }];
        
    }
    
}

/**
 *  获得用户的积分和余额
 */
- (void)getUserIntergelAndAccount {
    
//    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];

    [UserPointAndMoneyPresenters getIntegralBalanceUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];

            [self showToastMsg:@"提现成功！" Duration:3.0];

            if(resultCode == SucceedCode)
            {
                _moneyLabel.text = [NSString stringWithFormat:@"%.2f",appdelegate.userData.balance.floatValue];
            }
            
        });
        
    }];
}
@end
