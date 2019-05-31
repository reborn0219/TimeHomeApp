//
//  BMReplacePresenter.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BMReplacePresenter.h"

@implementation BMReplacePresenter

///获得二手置换物品类型（/usedtype/getusedtype）
+(void)getUsedType:(UpDateViewsBlock)block
{
    NSString * url=[NSString stringWithFormat:@"%@/usedtype/getusedtype",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]initWithCapacity:0];
    [param setObject:appDelegate.userData.token forKey:@"token"];
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
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
                NSArray *userData =[dicJson objectForKey:@"list"];
                block(userData,SucceedCode);
                
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];

}

///搜索二手置换信息（/usedinfo/getappsearchusedinfo）
/*
 {
 “token”:”1502531323”
 ,”cityid”:123
 ,”countyid”:123
 ,”newness”:9
 ,”name”:”sdkfj”
 ,”typeid”:”12“
 ,”orderby”:”newness desc”
 ,”page”:1
 
 */
+(void)getAppSearchusedInfo:(UpDateViewsBlock)block withInfo:(NSDictionary *)infoDic
{
    NSString * url=[NSString stringWithFormat:@"%@/usedinfo/getappsearchusedinfo",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]initWithDictionary:infoDic];
    [param setObject:appDelegate.userData.token forKey:@"token"];
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
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
                NSArray * array=[UserPublishRoom mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
                block(array,SucceedCode);
                
            }
            else//返回操作失败
            {
                NSDictionary *dic=@{@"errcode":[dicJson objectForKey:@"errcode"],@"errmsg":errmsg};
                block(dic,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];

}
///获得用户二手置换信息（/usedinfo/getuserusedinfo）
+(void)getUserusedInfo:(UpDateViewsBlock)block withPage:(NSString *)page
{
    NSString * url=[NSString stringWithFormat:@"%@/usedinfo/getuserusedinfo",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"page":page};

    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
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
                NSLog(@"dicJson===%@",dicJson);
                NSMutableArray *array = [UserPublishRoom mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
                block(array,SucceedCode);
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];

}
///添加二手置换信息（/usedinfo/addusedinfo）
/*
 {
 “token”:”1502531323”
 ,”typeid”:”12“
 ,”countyid”:13
 ,”mapx”:123.3
 ,”mapy”:12.32
 ,”address”:”ksjfdid”
 ,”newness”:9
 ,”name”:”123456789”
 ,”description”:”132sdfs”
 ,”money”:21.36
 ,”linkman”:” 李召”
 ,”linkphone”:” 1383838438”
 ,”flag”:1
 ,”picids”:”232,232”
 }
 */
+(void)addUsedInfo:(UpDateViewsBlock)block withInfo:(NSDictionary *)infoDic
{
    NSString * url=[NSString stringWithFormat:@"%@/usedinfo/addusedinfo",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]initWithDictionary:infoDic];
    [param setObject:appDelegate.userData.token forKey:@"token"];
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
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
                UserData *userData = [UserData mj_objectWithKeyValues:[dicJson objectForKey:@"map"]];
                block(userData,SucceedCode);
                
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];

}

///修改二手置换信息（/usedinfo/changeusedinfo）
/*
 {
 “token”:”1502531323”
 ,”id”:“1”
 ,”typeid”:”12“
 ,”countyid”:13
 ,”mapx”:123.3
 ,”mapy”:12.32
 ,”address”:”ksjfdid”
 ,”newness”:9
 ,”name”:”123456789”
 ,”description”:”132sdfs”
 ,”money”:21.36
 ,”linkman”:”李召”
 ,”linkphone”:” 1383838438”
 ,”flag”:1
 ,”picids”:”232,232”
 }
 */
+(void)changeUsedInfo:(UpDateViewsBlock)block withInfo:(NSDictionary *)infoDic
{
    NSString * url=[NSString stringWithFormat:@"%@/usedinfo/changeusedinfo",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]initWithDictionary:infoDic];
    [param setObject:appDelegate.userData.token forKey:@"token"];
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
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
                UserData *userData = [UserData mj_objectWithKeyValues:[dicJson objectForKey:@"map"]];
                block(userData,SucceedCode);
                
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];

}
///删除二手置换信息（/usedinfo/removeusedinfo）
+(void)removeUsedInfo:(UpDateViewsBlock)block withID:(NSString *)replaceID
{
    if ([XYString isBlankString:replaceID]) {
        block(@"数据异常，请联系物业",FailureCode);
        return;
    }
    
    NSString * url=[NSString stringWithFormat:@"%@/usedinfo/removeusedinfo",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"id":replaceID};
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
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
                UserData *userData = [UserData mj_objectWithKeyValues:[dicJson objectForKey:@"map"]];
                block(userData,SucceedCode);
                
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];

}


@end
