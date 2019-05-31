//
//  HDActivityPresenter.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "HDActivityPresenter.h"


@implementation HDActivityPresenter

///获得开展中的活动列表（/activity/gettopactivitinglist）请求参数：token 15021
+(void)getTopactivitingList:(UpDateViewsBlock)block
{
    NSString * url=[NSString stringWithFormat:@"%@/activity/gettopactivitinglist",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token};
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
            NSLog(@"dicJson==%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                NSArray * array=[dicJson objectForKey:@"list"];
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
///获得开展中的活动列表（/activity/getactivitinglist）请求参数：token 15021
+(void)getActivitingListFor:(NSString *)page  updataBlock:(UpDateViewsBlock)block{
    NSString * url=[NSString stringWithFormat:@"%@/activity/getactivitinglist",SERVER_URL];
    
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
//            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"json===%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                NSArray * arr=[UserActivity mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
                block(arr,SucceedCode);
                
            }
            else//返回操作失败
            {
                block(dicJson,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];

}
///我参加的活动（/activity/getuseractivity）请求参数：token 15021 page  1
+(void)getActivitingListPage:(NSInteger)page WithBlock:(UpDateViewsBlock)block{
    
    NSString * url=[NSString stringWithFormat:@"%@/activity/getuseractivity",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"page":[NSString stringWithFormat:@"%ld",(long)page]};
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
                NSMutableArray *array = [UserActivity mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
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

@end
