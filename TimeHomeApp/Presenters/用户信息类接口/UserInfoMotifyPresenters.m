//
//  UserInfoMotifyPresenters.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "UserInfoMotifyPresenters.h"

@implementation UserInfoMotifyPresenters

/**
 *  获得用户标签列表
 */
+ (void)getUserSelfTagUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/userselftag/getuserselftag",SERVER_URL];
    
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
                NSLog(@"%@",dicJson);
                NSArray *array = [THTags mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
//                AppDelegate *appDelegate = GetAppDelegates;
//                NSString *selfTag = @"";
//                for (THTags *tag in array) {
//                    selfTag = [selfTag stringByAppendingFormat:@"%@  ",tag.name];
//                }
//                selfTag = [XYString IsNotNull:selfTag];
//                appDelegate.userData.selftag = selfTag;
//                [appDelegate saveContext];
                
                NSString *selfTag = @"";
                for (THTags *tag in array) {
                    selfTag = [selfTag stringByAppendingFormat:@"%@  ",tag.name];
                }
                AppDelegate *appDelegate = GetAppDelegates;
                appDelegate.userData.selftag = selfTag;
                [appDelegate saveContext];
                
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
/**
 *  获得系统标签列表
 */
+ (void)getSystemSelfTagUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/userselftag/getsysselftag",SERVER_URL];
    
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
                NSLog(@"%@",dicJson);

                NSArray *array = [THTags mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
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
/**
 *  添加用户系统标签
 */
+ (void)addSelfTagName:(NSString *)name UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/userselftag/addselftag",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"name":name};
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
                
                THTags *tags = [[THTags alloc]init];
                tags.theID = [dicJson objectForKey:@"id"];
                tags.name = name;
                updataViewBlock(tags,SucceedCode);
                
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
 *  保存用户设置的标签
 */
+ (void)saveUserSelfTagids:(NSArray *)tagArray UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    /**
     *  字符串拼接逗号
     */
    NSString *tagids = @"";
    NSString *seltTag = @"";
    for (THTags *tags in tagArray) {
        tagids = [tagids stringByAppendingFormat:@"%@,",tags.theID];
        seltTag = [seltTag stringByAppendingFormat:@"%@,",tags.name];
    }
    if (tagids.length > 0) {
        tagids = [tagids substringToIndex:tagids.length - 1];
        seltTag = [seltTag substringToIndex:seltTag.length - 1];
    }
    
    NSString * url=[NSString stringWithFormat:@"%@/userselftag/saveuserselftag",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;

    NSDictionary * param = @{@"token":appDelegate.userData.token,@"tagids":tagids};
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
                appDelegate.userData.selftag = seltTag;
                [appDelegate saveContext];
                
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
 *  修改用户备注
 */
+ (void)saveRemarkNameUserID:(NSString *)userid name:(NSString *)name UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/user/saveremarkname",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"userid":userid,@"name":name};
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
                updataViewBlock(@"设置备注成功！",SucceedCode);
                
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
 *  添加用户举报
 */
+ (void)addUserReportUserID:(NSString *)userid type:(NSString *)type UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/userreport/adduserreport",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"userid":userid,@"type":type};
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
@end
