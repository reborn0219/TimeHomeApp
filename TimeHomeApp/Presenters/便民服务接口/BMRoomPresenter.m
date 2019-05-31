//
//  BMRoomPresenter.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BMRoomPresenter.h"
#import "UserPublishRoom.h"

@implementation BMRoomPresenter
///搜索二手房产信息（/serresidence/getappsearchresidence）
/*
 {
 ”token”:”1231“
 ,”sertype”:1
 ,”cityid”:123
 ,”countyid”:123
 ,”moneybegin”:1200
 ,”moneyend”:2000
 ,”bedroom”:5
 ,”livingroom”:1
 ,”toilef”:1
 ,”title”:”sdkfj”
 ,”orderby”:”newness desc”
 ,“page”:1
 }
 */
+(void)getAppSearchResidence:(UpDateViewsBlock)block withInfo:(NSDictionary *)infoDic
{
    NSString * url=[NSString stringWithFormat:@"%@/serresidence/getappsearchresidence",SERVER_URL];
    
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
                NSLog(@"%@",dicJson);
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
///获得用户的房产信息（/serresidence/getuserresidence）
+(void)getUserResidence:(UpDateViewsBlock)block withPage:(NSString *)page
{
    NSString * url=[NSString stringWithFormat:@"%@/serresidence/getuserresidence",SERVER_URL];
    
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
        else if(resultCode==TOKENInvalid)//登录失效
        {
            block(data,resultCode);
        }
    }];

}
///添加出售出租房产交易信息（/serresidence /addresidence）
/*
 “token”:”1502531323”
 ,”sertype”:1
 ,“countyid”:122
 ,“communityname”:”金谈固小区”
 ,”mapx”:123.12
 ,”mapy”:13.22
 ,”address”:”地址”
 ,”title”:”大三室”
 ,”description”:”还很新”
 ,”area”:98.2
 ,”floornum”:23
 ,”allfloornum”:31
 ,“bedroom”:2
 ,”livingroom”:1
 ,”toilef”:1
 ,”decorattype”:1
 ,“buildyear”:2015
 ,”facetype”:1
 ,”housetype”:1
 ,”propertyyear”:30
 ,“isinhand”:1
 ,”money”:1000.0
 ,”linkman”:”dsfssd”
 ,”linkphone”:”123456789”
 ,”flag”:1
 ,"picids":”232,213”
 
 */
+(void)addResidence:(UpDateViewsBlock)block withInfo:(NSDictionary *)infoDic
{
    NSString * url=[NSString stringWithFormat:@"%@/serresidence/addresidence",SERVER_URL];
    
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
                
                block(errmsg,SucceedCode);
                
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
///修改出售出租房产交易信息（/serresidence/changeresidence）
/*
 “token”:”1502531323”
 ,”id”:”1”
 ,“countyid”:122
 ,“communityname”:”金谈固小区”
 ,”mapx”:123.12
 ,”mapy”:13.22
 ,”address”:”地址”
 ,”title”:”大三室”
 ,”description”:”还很新”
 ,”area”:98.2
 ,”floornum”:23
 ,”allfloornum”:31
 ,“bedroom”:2
 ,”livingroom”:1
 ,”toilef”:1
 ,”decorattype”:1
 ,“buildyear”:2015
 ,”facetype”:1
 ,”housetype”:1
 ,”propertyyear”:30
 ,“isinhand”:1
 ,”money”:1000.0
 ,”linkman”:”dsfssd”
 ,”linkphone”:”123456789”
 ,”flag”:1
 ,"picids":”232,213”
 
 */
+(void)changeResidence:(UpDateViewsBlock)block withInfo:(NSDictionary *)infoDic
{
    NSString * url=[NSString stringWithFormat:@"%@/serresidence/changeresidence",SERVER_URL];
    
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
                
                block(errmsg,SucceedCode);
                
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
///删除出租出售房产交易信息（/serresidence/removeresidence）
+(void)removeResidence:(UpDateViewsBlock)block withID:(NSString *)residenceID
{
    if ([XYString isBlankString:residenceID]) {
        block(@"数据异常，请联系物业",FailureCode);
        return;
    }
    
    NSString * url=[NSString stringWithFormat:@"%@/serresidence/removeresidence",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"id":residenceID};
    
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
//                UserData *userData = [UserData mj_objectWithKeyValues:[dicJson objectForKey:@"map"]];
                block(errmsg,SucceedCode);
                
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
///搜索求购求租房产信息（/serresidencewant/getappsearchresidencewant）
/*
 {
 ”token”:”1231“
 ,”sertype”:1
 ,”cityid”:123
 ,”countyid”:123
 ,”moneybegin”:1200
 ,”moneyend”:2000
 ,”bedroom”:5
 ,”livingroom”:1
 ,”title”:”sdkfj”
 ,”orderby”:”newness desc”
 ,“page”:1
 }
 */
+(void)getAppSearchResidenceWant:(UpDateViewsBlock)block withInfo:(NSDictionary *)infoDic
{
    NSString * url=[NSString stringWithFormat:@"%@/serresidencewant/getappsearchresidencewant",SERVER_URL];
    
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
///添加求租求购房产交易信息（/serresidencewant/addresidencewant）
/*
 “token”:”1502531323”
 “sertype”:2
 ,”countyid”:3
 ,”title”:”大三室”
 ,”description”:”还很新”
 ,“bedroom”:2
 ,”livingroom”:1
 ,”area”:98.2
 ,”moneybegin”:1000
 ,”moneyend”:2000
 ,”linkman”:”dsfssd”
 ,”linkphone”:”123456789”
 ,”flag”:1
 
 */
+(void)addResidenceWant:(UpDateViewsBlock)block withInfo:(NSDictionary *)infoDic
{
    NSString * url=[NSString stringWithFormat:@"%@/serresidencewant/addresidencewant",SERVER_URL];
    
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
///添加求租求购房产交易信息（/serresidencewant/changeresidencewant）
/*
 “token”:”1502531323”
 ,”id”:”1”
 ,”countyid”:3
 ,”title”:”大三室”
 ,”description”:”还很新”
 ,“bedroom”:2
 ,”livingroom”:1
 ,”area”:98.2
 ,”moneybegin”:1000
 ,”moneyend”:2000
 ,”linkman”:”dsfssd”
 ,”linkphone”:”123456789”
 ,”flag”:1
 
 */
+(void)changeResidenceWant:(UpDateViewsBlock)block withInfo:(NSDictionary *)infoDic
{
    NSString * url=[NSString stringWithFormat:@"%@/serresidencewant/changeresidencewant",SERVER_URL];
    
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
///删除求租求购房产交易信息（/serresidencewant/removeresidencewant）
+(void)removeResidenceWant:(UpDateViewsBlock)block withID:(NSString *)wantID
{
    if ([XYString isBlankString:wantID]) {
        block(@"数据异常，请联系物业",FailureCode);
        return;
    }
    
    NSString * url=[NSString stringWithFormat:@"%@/serresidencewant/removeresidencewant",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"id":wantID};
    
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
//                UserData *userData = [UserData mj_objectWithKeyValues:[dicJson objectForKey:@"map"]];
                block(errmsg,SucceedCode);
                
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
