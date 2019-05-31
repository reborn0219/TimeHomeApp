//
//  LogInPresenter.m
//  TimeHomeApp
//
//  Created by us on 16/3/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "LogInPresenter.h"
#import "RegularUtils.h"
#import "EncryptUtils.h"
#import "MsgAlertView.h"
#import "LoginVC.h"
#import "THIndicatorVC.h"
#import "NetWorks.h"
#import "MainTabBars.h"
#import "AppSystemSetPresenters.h"
#import "AppDelegate+JPush.h"
#import "THMyInfoPresenter.h"
#import "PAUser.h"
#import "PAH5UrlManager.h"
#import "PAUserLogInRequest.h"

@implementation LogInPresenter

/**
 用户登录接口
 */
-(void)logInForAcc:(NSString *)acc Pw:(NSString *)passWord upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    if ([XYString isBlankString:acc]) {
        updataViewBlock(@"手机号不能为空,请重新输入",FailureCode);
        return;
    }
    if(![RegularUtils isPhoneNum:acc])//验证手机号正确
    {
        updataViewBlock(@"手机号不正确,请重新输入",FailureCode);
        return;
    }
    if([passWord isEqualToString:@""])
    {
        updataViewBlock(@"请输入您的密码!",FailureCode);
        return;
    }
    if(passWord.length!=6)
    {
        updataViewBlock(@"请输正确的6位密码!",FailureCode);
        return;
    }
    PAUserLogInRequest *api = [[PAUserLogInRequest alloc]initWithLogInAccout:acc passWord:[EncryptUtils md5HexDigest:passWord]];
    [api requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        
        NSLog(@"返回数据：%@",responseModel.data);
        AppDelegate *appdelegate = GetAppDelegates;
        //保存用户信息
        if (responseModel.data) {
            
            PAUser *user = [PAUser yy_modelWithJSON:responseModel.data];
            [[PAH5UrlManager sharedPAH5UrlManager]saveUrls:user.urllink];
            
            if (user) {
               
                [[PAUserManager sharedPAUserManager]integrationUserData:user];

                NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setObject:user.userinfo.opid forKey:@"PAUserOpId"];
                [userDefault synchronize];
                
                appdelegate.userData.taglist = user.taglist;
                appdelegate.isupgrade = user.userinfo.isupgrade;
                appdelegate.userData.accPhone = appdelegate.userData.phone;
                appdelegate.userData.passWord = passWord;
                appdelegate.userData.isLogIn = [[NSNumber alloc]initWithBool:YES];
                [appdelegate saveContext];
                [appdelegate setMsgSaveName];
                
                //今天插件的Token
                NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:WIDGET_GROUP_ID];
                [shared setObject:appdelegate.userData.token forKey:@"widget"];
                [shared synchronize];
                
                
                
                updataViewBlock(responseModel.msg,SucceedCode);
            }
            
        }else{//返回操作失败
        
        AppDelegate *appDelegate = GetAppDelegates;
        appDelegate.userData.isLogIn = [[NSNumber alloc]initWithBool:NO];
        [appDelegate saveContext];
        
       }
        
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        NSLog(@"权限获取失败");
        
        if (error.code == 10004) {
            
            updataViewBlock(@(error.code),FailureCode);

        }else{
            AppDelegate *appDelegate = GetAppDelegates;
            appDelegate.userData.isLogIn = [[NSNumber alloc]initWithBool:NO];
            [appDelegate saveContext];
            updataViewBlock([error.userInfo objectForKey:@"NSLocalizedDescription"],FailureCode);
        }
       
        
        
    }];
    
}

/**
 发送短信验证码
 */
-(void)getCAPTCHAForPhoneNum:(NSString*)PhoneNum type:(NSString *) Type andPlatform:(NSString *)platform andAccount:(NSString *)account upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    
    NSString * url=[NSString stringWithFormat:@"%@/user/sendverificode",SERVER_URL];
    NSDictionary * param=@{@"phone":PhoneNum,@"type":Type,@"platform":platform,@"account":account};
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(errmsg,SucceedCode);
            }
            else//返回操作失败
            {
                NSArray *arr = @[errmsg,[NSString stringWithFormat:@"%ld",errcode]];
                updataViewBlock(arr,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
        }
    }];
}
/**
 验证短信验证码接口
 */
-(void)checkVerificodeForPhoneNum:(NSString*)PhoneNum verificode:(NSString *) verificode upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    if(![RegularUtils isPhoneNum:PhoneNum])//验证手机号正确
    {
        updataViewBlock(@"手机号不正确,请重新输入",FailureCode);
        return;
    }
    if([verificode isEqualToString:@""])
    {
        updataViewBlock(@"验证码不能为空!",FailureCode);
        return;
    }
    if(verificode.length!=4)
    {
        updataViewBlock(@"请输入4位验证码!",FailureCode);
        return;
    }
    //
    NSString * url=[NSString stringWithFormat:@"%@/user/checkverificode",SERVER_URL];
    NSDictionary * param=@{@"phone":PhoneNum,@"verificode":verificode};
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(errmsg,SucceedCode);
            }
            else//返回操作失败
            {
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
        }
    }];
    
}
/**
 用户注册接口
 */
-(void)registerForPhoneNum:(NSString*)PhoneNum Pw:(NSString*) passWord verificode:(NSString *)verificode upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    if(![RegularUtils isPhoneNum:PhoneNum])//验证手机号正确
    {
        updataViewBlock(@"手机号不正确,请重新输入",FailureCode);
        return;
    }
    if([passWord isEqualToString:@""])
    {
        updataViewBlock(@"密码不能为空!",FailureCode);
        return;
    }
    if(passWord.length!=6)
    {
        updataViewBlock(@"请输正确的6位密码!",FailureCode);
        return;
    }
    //
    NSString * url=[NSString stringWithFormat:@"%@/user/regist",SERVER_URL];
    NSDictionary * param=@{@"phone":PhoneNum,@"password":passWord,@"verificode":verificode};
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            
            NSLog(@"%@",dicJson);
            
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(errmsg,SucceedCode);
            }
            else//返回操作失败
            {
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
        }
        
    }];
    
}

/**
 用户密码找回接口
 */
-(void)findPWForPhoneNum:(NSString*)PhoneNum Pw:(NSString*) passWord verificode:(NSString *) verificode upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    
    NSString * url=[NSString stringWithFormat:@"%@/user/findpassword",SERVER_URL];
    NSDictionary * param=@{@"phone":PhoneNum,@"verificode":verificode,@"password":passWord};
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(errmsg,SucceedCode);
                //                AppDelegate * appdelegate = GetAppDelegates;
                //                appdelegate.userData.passWord = passWord;
                //                [appdelegate saveContext];
                
            }
            else//返回操作失败
            {
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
        }
    }];
    
}
/**
 修改用户密码接口
 */
-(void)changePassword:(NSString*)password upDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    if ([XYString isBlankString:password]) {
        updataViewBlock(@"新密码不能为空",FailureCode);
        return;
    }
    
    NSString * url=[NSString stringWithFormat:@"%@/user/changepassword",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"password":password};
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            NSLog(@"%@",dicJson);
            appDelegate.userData.passWord = password;
            [appDelegate saveContext];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(@"密码修改成功",SucceedCode);
            }
            else//返回操作失败
            {
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
        }
    }];
    
}

///重新登录断判
+(void)ReLogInFor:(NSData *)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
        //“errcode”:0
        //,”errmsg”:””
        NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
        
        if ([dicJson objectForKey:@"code"]) {
            errcode = [[dicJson objectForKey:@"code"]intValue];
        }
        
        if(errcode==10000)///登录失效
        {
            AppDelegate *appDlt=GetAppDelegates;
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            MsgAlertView * alertView=[MsgAlertView sharedMsgAlertView];
            
            [appDlt setTags:nil error:nil];
            appDlt.userData.isLogIn = [[NSNumber alloc]initWithBool:NO];
            [appDlt saveContext];
            
            [alertView showMsgViewForMsg:@"登录失效了,请重新登录" btnOk:@"重新登录" btnCancel:@"返回登录页" blok:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                if(index==100)
                {
                    if (appDlt.userData.isRememberPw.boolValue) {
                        ///记住密码
                        LogInPresenter *logInPresenter=[LogInPresenter new];
                        [logInPresenter logInForAcc:appDlt.userData.accPhone Pw:appDlt.userData.passWord upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                if(resultCode==SucceedCode)
                                {
                                    [AppDelegate showToastMsg:@"登录成功!" Duration:5.0];
                                    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainTabBar" bundle:nil];
                                    
                                    AppDelegate * appdelegate = GetAppDelegates;
                                    
                                    [AppSystemSetPresenters getBindingTag];
                                    
                                    MainTabBars * MainTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBars"];
                                    appdelegate.window.rootViewController=MainTabBar;
                                    MainTabBar.tabBarController.tabBar.hidden = NO;
                                    MainTabBar.hidesBottomBarWhenPushed = NO;
                                    
                                }else{
                                    
                                    [AppDelegate showToastMsg:@"登录失败了!" Duration:5.0];
                                    //退出登录
                                    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"LogInRegister" bundle:nil];
                                    UINavigationController *loginVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"navLogIn"];
                                    AppDelegate * appdelegate = GetAppDelegates;
                                    [appdelegate setTags:nil error:nil];
                                    appdelegate.userData.token = @"";
                                    [appdelegate saveContext];
                                    appdelegate.window.rootViewController = loginVC;
                                    
                                    CATransition * animation =  [AnimtionUtils getAnimation:2 subtag:0];
                                    [loginVC.view.window.layer addAnimation:animation forKey:nil];
                                    
                                }
                                
                            });
                        }];
                        
                    }else {
                        //未记住密码
                        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"LogInRegister" bundle:nil];
                        //                    LoginVC *loginVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"LoginVC"];
                        UINavigationController *loginVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"navLogIn"];
                        
                        AppDelegate * appdelegate = GetAppDelegates;
                        [appdelegate setTags:nil error:nil];
                        appdelegate.userData.isLogIn=[[NSNumber alloc]initWithBool:NO];
                        appdelegate.userData.token = @"";
                        [appdelegate saveContext];
                        
                        appdelegate.window.rootViewController = loginVC;
                        
                        CATransition * animation =  [AnimtionUtils getAnimation:2 subtag:0];
                        [loginVC.view.window.layer addAnimation:animation forKey:nil];
                    }
                    
                }
                else
                {
                    //退出登录
                    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"LogInRegister" bundle:nil];
                    //                    LoginVC *loginVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"LoginVC"];
                    UINavigationController *loginVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"navLogIn"];
                    
                    AppDelegate * appdelegate = GetAppDelegates;
                    [appdelegate setTags:nil error:nil];
                    appdelegate.userData.isLogIn=[[NSNumber alloc]initWithBool:NO];
                    appdelegate.userData.token = @"";
                    [appdelegate saveContext];
                    
                    appdelegate.window.rootViewController = loginVC;
                    
                    CATransition * animation =  [AnimtionUtils getAnimation:2 subtag:0];
                    [loginVC.view.window.layer addAnimation:animation forKey:nil];
                }
                
            }];
            
        }
        
    });
}

#pragma mark - TEMP:适配YTKNetwork 重新登录

///重新登录断判
+(void)ReLogInForYTKNetwork
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
        MsgAlertView * alertView=[MsgAlertView sharedMsgAlertView];
     
        [alertView showMsgViewForMsg:@"登录失效了,请重新登录"
                               btnOk:@"重新登录" btnCancel:@"返回登录页"
                                blok:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                                    
            AppDelegate *appDlt = GetAppDelegates;
                                    
            if(index==100)
            {
                if (appDlt.userData.isRememberPw.boolValue) { ///记住密码
                   
                    LogInPresenter *logInPresenter=[LogInPresenter new];
                    
                    [logInPresenter logInForAcc:appDlt.userData.accPhone
                                             Pw:appDlt.userData.passWord
                                upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                                    
                        dispatch_async(dispatch_get_main_queue(), ^{
                           
                            if(resultCode==SucceedCode)
                            {
                                
                                [AppDelegate showToastMsg:@"登录成功!" Duration:5.0];
                                UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainTabBar" bundle:nil];
                                AppDelegate * appdelegate = GetAppDelegates;
                                [AppSystemSetPresenters getBindingTag];
                                MainTabBars * MainTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBars"];
                                appdelegate.window.rootViewController=MainTabBar;
                                MainTabBar.tabBarController.tabBar.hidden = NO;
                                MainTabBar.hidesBottomBarWhenPushed = NO;
                                
                            }else{
                                [AppDelegate showToastMsg:@"登录失败了!" Duration:5.0];
                                //退出登录
                                UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"LogInRegister" bundle:nil];
                                UINavigationController *loginVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"navLogIn"];
                                AppDelegate * appdelegate = GetAppDelegates;
                                [appdelegate setTags:nil error:nil];
                                appdelegate.userData.token = @"";
                                [appdelegate saveContext];
                                appdelegate.window.rootViewController = loginVC;
                                
                                CATransition * animation =  [AnimtionUtils getAnimation:2 subtag:0];
                                [loginVC.view.window.layer addAnimation:animation forKey:nil];
                                
                            }
                            
                        });
                    }];
                    
                }else {
                    //未记住密码
                    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"LogInRegister" bundle:nil];
                    //                    LoginVC *loginVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"LoginVC"];
                    UINavigationController *loginVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"navLogIn"];
                    
                    AppDelegate * appdelegate = GetAppDelegates;
                    [appdelegate setTags:nil error:nil];
                    appdelegate.userData.isLogIn=[[NSNumber alloc]initWithBool:NO];
                    appdelegate.userData.token = @"";
                    [appdelegate saveContext];
                    
                    appdelegate.window.rootViewController = loginVC;
                    
                    CATransition * animation =  [AnimtionUtils getAnimation:2 subtag:0];
                    [loginVC.view.window.layer addAnimation:animation forKey:nil];
                }
                
            }
            else
            {
                //退出登录
                UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"LogInRegister" bundle:nil];
                //                    LoginVC *loginVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"LoginVC"];
                UINavigationController *loginVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"navLogIn"];
                
                AppDelegate * appdelegate = GetAppDelegates;
                [appdelegate setTags:nil error:nil];
                appdelegate.userData.isLogIn=[[NSNumber alloc]initWithBool:NO];
                appdelegate.userData.token = @"";
                [appdelegate saveContext];
                
                appdelegate.window.rootViewController = loginVC;
                
                CATransition * animation =  [AnimtionUtils getAnimation:2 subtag:0];
                [loginVC.view.window.layer addAnimation:animation forKey:nil];
            }
            
        }];
        
    });
}

/**
 发送短信验证码
 */
-(void)getNewCAPTCHAForPhoneNum:(NSString*)PhoneNum type:(NSString *) Type andPlatform:(NSString *)platform andAccount:(NSString *)account upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    
    NSString * url=[NSString stringWithFormat:@"%@/user/newsendverificode",SERVER_URL];
    NSDictionary * param=@{@"phone":PhoneNum,@"type":Type,@"platform":platform,@"account":account};
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(errmsg,SucceedCode);
            }
            else//返回操作失败
            {
                NSArray *arr = @[errmsg,[NSString stringWithFormat:@"%ld",errcode]];
                updataViewBlock(arr,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
        }
    }];
}

@end
