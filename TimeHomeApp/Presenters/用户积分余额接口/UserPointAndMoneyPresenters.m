//
//  UserPointAndMoneyPresenters.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "UserPointAndMoneyPresenters.h"

@implementation UserPointAndMoneyPresenters

/**
 *  获得用户的积分和余额
 */
+ (void)getIntegralBalanceUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/balance/getbalance",SERVER_URL_New];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
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
            
            NSLog(@"用户的积分和余额==%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                /**
                 *  保存用户的积分和余额
                 */
                
                dispatch_async(dispatch_get_main_queue(), ^{
#warning 需要在主线程
                    AppDelegate *appDelegate = GetAppDelegates;
                    appDelegate.userData.integral = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"integral"]];
                    appDelegate.userData.balance = [NSString stringWithFormat:@"%@",[[dicJson objectForKey:@"map"] objectForKey:@"balance"]];
                    [appDelegate saveContext];
                    
                });
                
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
 *  获得积分和等级规则
 */
+ (void)getIntegralRuleUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/integral/getintegralrule",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token};
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
                appDelegate.userData.activedays = [NSString stringWithFormat:@"%@",[dicJson objectForKey:@"activedays"]];
                appDelegate.userData.upgradedays = [NSString stringWithFormat:@"%@",[dicJson objectForKey:@"upgradedays"]];
                appDelegate.userData.leveldays = [NSString stringWithFormat:@"%@",[dicJson objectForKey:@"leveldays"]];

                [appDelegate saveContext];
                NSLog(@"%@",dicJson);
                updataViewBlock(appDelegate.userData,SucceedCode);
                
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
 *  用户签到
 */
+ (void)addSignLogUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    NSString * url=[NSString stringWithFormat:@"%@/signlog/addsignlog",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token};
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
            NSLog(@"json===%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(dicJson,SucceedCode);
                
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
 *  获得今天是否可签到
 */
+ (void)isSignUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/signlog/issign",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token};
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
            NSLog(@"json=isSignUpDataViewBlock=%@",dicJson);
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
 *  用户签到日志
 */
+ (void)getMonthSignLogMonth:(NSString *)month UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/signlog/getmonthsignlog",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"month":month};
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
 *  用户积分日志
 */
+ (void)getIntegralLogPage:(NSString *)page UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    NSString * url=[NSString stringWithFormat:@"%@/integral/getintegrallog",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"page":page};
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
            NSLog(@"dicJson==%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                /**
                 *  积分日志数组
                 */
                NSArray *array = [UserIntergralLog mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
                updataViewBlock(array,SucceedCode);
                
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
@end
