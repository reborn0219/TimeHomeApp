//
//  SysPresenter.m
//  YouLifeApp
//
//  Created by us on 15/11/2.
//  Copyright © 2015年 us. All rights reserved.
//

#import "SysPresenter.h"

@implementation SysPresenter

//
///发送错误内容
-(void) saveAppError:(NSString *)Content
{
    if([Content containsString:@"JPUSH"])
    {
        return;
    }
    
    NSString * url=[NSString stringWithFormat:@"%@/errorlog/adderrorlog",SERVER_URL];
//    NSString * heard=[NSString stringWithFormat:@"Token=%@&SourceType=%@&Title=%@&Content=%@",delegateApp.userData.token,@"1",@"com.usnoon.050804.YouLifeApp",Content];
    NSDictionary * param=@{@"token":@"1",@"sourcetype":@"2",@"title":@"com.usnoon.050804.YouLifeApp",@"content":Content};
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    [dataController executeCommand:command className:@"NetSynCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
    }];
}


///打电话
-(void) callMobileNum:(NSString *)mobileNum superview:(UIView *) superView;
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",mobileNum]];
    UIWebView *phoneCallWebView;
    if ( !phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [superView addSubview:phoneCallWebView];
    [superView bringSubviewToFront:phoneCallWebView];
}

+ (void)callPhoneStr:(NSString*)phoneStr withVC:(UIViewController *)selfvc {
    
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (phoneStr.length >= 10) {
        NSString *str2 = [[UIDevice currentDevice] systemVersion];
        if ([str2 compare:@"10.2" options:NSNumericSearch] == NSOrderedDescending || [str2 compare:@"10.2" options:NSNumericSearch] == NSOrderedSame)
        {
            NSString* PhoneStr = [NSString stringWithFormat:@"telprompt://%@",phoneStr];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PhoneStr] options:@{} completionHandler:^(BOOL success) {
                NSLog(@"phone success");
            }];
            
        }else {
            NSMutableString* str1 = [[NSMutableString alloc]initWithString:phoneStr];// 存在堆区，可变字符串
            if (phoneStr.length == 10) {
                [str1 insertString:@"-"atIndex:3];// 把一个字符串插入另一个字符串中的某一个位置
                [str1 insertString:@"-"atIndex:7];// 把一个字符串插入另一个字符串中的某一个位置
            }else {
                [str1 insertString:@"-"atIndex:3];// 把一个字符串插入另一个字符串中的某一个位置
                [str1 insertString:@"-"atIndex:8];// 把一个字符串插入另一个字符串中的某一个位置
            }
            NSString * str = [NSString stringWithFormat:@"是否拨打电话\n%@",str1];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message: nil preferredStyle:UIAlertControllerStyleAlert];
            // 设置popover指向的item
            alert.popoverPresentationController.barButtonItem = selfvc.navigationItem.leftBarButtonItem;
            // 添加按钮
            [alert addAction:[UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                NSLog(@"点击了呼叫按钮10.2下");
                NSString* PhoneStr = [NSString stringWithFormat:@"tel://%@",phoneStr];
                if ([PhoneStr hasPrefix:@"sms:"] || [PhoneStr hasPrefix:@"tel:"]) {
                    UIApplication * app = [UIApplication sharedApplication];
                    if ([app canOpenURL:[NSURL URLWithString:PhoneStr]]) {
                        [app openURL:[NSURL URLWithString:PhoneStr]];
                    }
                }
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                NSLog(@"点击了取消按钮");
            }]];
            [selfvc presentViewController:alert animated:YES completion:nil];
            
        }
        
    }else {
        
        NSString * str = [NSString stringWithFormat:@"是否拨打电话\n%@",phoneStr];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message: nil preferredStyle:UIAlertControllerStyleAlert];
        // 设置popover指向的item
        alert.popoverPresentationController.barButtonItem = selfvc.navigationItem.leftBarButtonItem;
        // 添加按钮
        [alert addAction:[UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            NSLog(@"点击了呼叫按钮10.2下");
            NSString* PhoneStr = [NSString stringWithFormat:@"tel://%@",phoneStr];
            if ([PhoneStr hasPrefix:@"sms:"] || [PhoneStr hasPrefix:@"tel:"]) {
                UIApplication * app = [UIApplication sharedApplication];
                if ([app canOpenURL:[NSURL URLWithString:PhoneStr]]) {
                    [app openURL:[NSURL URLWithString:PhoneStr]];
                }
            }
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"点击了取消按钮");
        }]];
        [selfvc presentViewController:alert animated:YES completion:nil];
        
    }
    
}

@end
