//
//  BMSpacePresenter.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BMSpacePresenter.h"

@implementation BMSpacePresenter
///搜索出租出售车位交易信息（/sercarrental/getappsearchcarrental）
/*
 {
 “token”:”1502531323”
 ,”sertype”:1
 ,”cityid”:123
 ,”countyid”:123
 ,”moneybegin”:10
 ,”moneyend”:50,”fixed”:1
 ,”underground”:1
 ,”name”:”sdkfj”
 ,”orderby”:”money desc”
 ,”page”:1
 }
 */
+(void)getAppSearchCarrental:(UpDateViewsBlock)block withInfo:(NSDictionary *)InfoDic
{
    NSString * url=[NSString stringWithFormat:@"%@/sercarrental/getappsearchcarrental",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]initWithDictionary:InfoDic];
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
            NSLog(@"dicJson11====%@",dicJson);
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                NSMutableArray *array = [UserPublishCar mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
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
///我发布的车位（/sercarrental/getusercarrental）
+(void)getUserCarrental:(UpDateViewsBlock)block withPage:(NSString *)page
{
    NSString * url=[NSString stringWithFormat:@"%@/sercarrental/getusercarrental",SERVER_URL];
    
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
                NSLog(@"%@",dicJson);
                NSMutableArray *array = [UserPublishCar mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
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
///添加出租出售车位交易信息（/sercarrental/addcarrental）
/*
 “token”:”1502531323”
 ,”sertype”:1
 ,”countyid”:123
 ,”communityname”:”金谈固小区”
 ,”mapx”:12.33
 ,”mapy”:32.3
 ,”address”:”河北省石家庄”
 ,”title”:”好用车位”
 ,”description”,”很好”
 ,”fixed”:0
 ,”underground”:1
 ,”money”:”200.0”
 ,”linkman”:”df到访”
 ,”linkphone”:”143838338”
 ,”picids”:”2321,34”
 ,”flag”:1
 
 */
+(void)addCarrental:(UpDateViewsBlock)block withInfo:(NSDictionary *)InfoDic
{
    NSString * url=[NSString stringWithFormat:@"%@/sercarrental/addcarrental",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]initWithDictionary:InfoDic];
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
///修改出租出售车位交易信息（/sercarrental/changecarrental）
/*
 {
 “token”:”1502531323”
 ,”id”:”1”
 ,”countyid”:123
 ,”communityname”:”金谈固小区”
 ,”mapx”:12.33
 ,”mapy”:32.3
 ,”address”:”河北省石家庄”
 ,”title”:”好用车位”
 ,”description”,”很好”
 ,”fixed”:0
 ,”underground”:1
 ,”money”:”200.0”
 ,”linkman”:”df到访”
 ,”linkphone”:”143838338”
 ,”picids”:”2321,34”
 ,”flag”:1
 
 */
+(void)changeCarrental:(UpDateViewsBlock)block withInfo:(NSDictionary *)InfoDic
{
    NSString * url=[NSString stringWithFormat:@"%@/sercarrental/changecarrental",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]initWithDictionary:InfoDic];
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
///删除出租出售车位交易信息（/sercarrental/removecarrental）
+(void)removeCarrental:(UpDateViewsBlock)block withID:(NSString *)carrentalID
{
    if ([XYString isBlankString:carrentalID]) {
        block(@"数据异常，请联系物业",FailureCode);
        return;
    }
    
    NSString * url=[NSString stringWithFormat:@"%@/sercarrental/removecarrental",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"id":carrentalID};

    
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
///搜索求购求租车位交易信息（/sercarrentalwant/getappsearchcarrentalwant）
/*
 “token”:”1502531323”
 ,”sertype”:1
 ,”cityid”:123
 ,”countyid”:123
 ,”moneybegin”:10
 ,”moneyend”:50
 ,”name”:”sdkfj”
 ,”orderby”:”moneybegin desc”
 ,”page”:1
 
 */
+(void)getAppSearchCarrentalWant:(UpDateViewsBlock)block withInfo:(NSDictionary *)InfoDic
{
    NSString * url=[NSString stringWithFormat:@"%@/sercarrentalwant/getappsearchcarrentalwant",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]initWithDictionary:InfoDic];
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
            NSLog(@"dicJson==%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                NSMutableArray *array = [UserPublishCar mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
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
///添加求租求购车位交易信息（/sercarrentalwant/addcarrentalwant）
/*
 “token”:”1502531323”
 ,”sertype”:2
 ,”countyid”:123
 ,”title”:”好用车位”
 ,”description”,”很好”
 ,”fixed”:0
 ,”underground”:1
 ,”moneybegin”:”200.0”
 ,”moneyend”:”250.0”
 ,”linkman”:”df到访”
 ,”linkphone”:”143838338”
 ,”flag”:1
 
 */
+(void)addCarrentalWant:(UpDateViewsBlock)block withInfo:(NSDictionary *)InfoDic
{
    NSString * url=[NSString stringWithFormat:@"%@/sercarrentalwant/addcarrentalwant",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]initWithDictionary:InfoDic];
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
///修改求租求购车位交易信息（/sercarrentalwant/changecarrentalwant）
/*
 “token”:”1502531323”
 ,”id”:”2”
 ,”countyid”:123
 ,”title”:”好用车位”
 ,”description”,”很好”
 ,”fixed”:0
 ,”underground”:1
 ,”moneybegin”:”200.0”
 ,”moneyend”:”250.0”
 ,”linkman”:”df到访”
 ,”linkphone”:”143838338”
 ,”flag”:1
 
 */
+(void)changeCarrentalWant:(UpDateViewsBlock)block withInfo:(NSDictionary *)InfoDic
{
    NSString * url=[NSString stringWithFormat:@"%@/sercarrentalwant/changecarrentalwant",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]initWithDictionary:InfoDic];
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
///删除求租求购车位交易信息（/sercarrentalwant/removecarrentalwant）
+(void)removeCarrentalWant:(UpDateViewsBlock)block withID:(NSString *)wantID
{
    if ([XYString isBlankString:wantID]) {
        block(@"数据异常，请联系物业",FailureCode);
        return;
    }
    
    NSString * url=[NSString stringWithFormat:@"%@/sercarrentalwant/removecarrentalwant",SERVER_URL];
    
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
