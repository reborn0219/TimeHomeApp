//
//  RedPacketPresenters.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/11/3.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RedPacketPresenters.h"

@implementation RedPacketPresenters
/**
 获取广告（红包）
 */
+ (void)getRedEnvelopeWithType:(NSString *)type andCommunityid:(NSString *)communityid updataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/getredenvelope",kNewRedPaket_URL];
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"type":type,@"communityid":communityid};
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
            NSLog(@"json=%@",dicJson);
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
 展现广告（车库消息需要调用）
 */
+ (void)showAdvertWithUpdataViewBlock:(UpDateViewsBlock)updataViewBlock {
    NSString * url=[NSString stringWithFormat:@"%@/showadvert",kNewRedPaket_URL];
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,
                           @"internettype":[AppDelegate getNetWorkStates],
                           @"appsofttype":@"1"};
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
            NSLog(@"json=%@",dicJson);
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
 抢(领取)红包
 */
+ (void)receiveRedEnvelopeWithUserticketid:(NSString *)userticketid updataViewBlock:(UpDateViewsBlock)updataViewBlock {
    NSString * url=[NSString stringWithFormat:@"%@/receiveredenvelope",kNewRedPaket_URL];
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"userticketid":userticketid};
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
            NSInteger errcode=[[dicJson objectForKey:@"errcode"] intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"json=%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(dicJson,SucceedCode);
            }
            else//返回操作失败
            {
                updataViewBlock(dicJson,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
        }
    }];
}


/**
 查看红包详情
 */
+ (void)getRedEnvlopeinfoWithUserticketid:(NSString *)ticketid updataViewBlock:(UpDateViewsBlock)updataViewBlock {
    ticketid = [NSString stringWithFormat:@"%@",ticketid];
    NSString * url=[NSString stringWithFormat:@"%@/getredenvelopeinfo",kNewRedPaket_URL];
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"id":ticketid};
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
            NSLog(@"json=%@",dicJson);
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
 分享红包
 */
+ (void)shareRedEnvelopeWithUserticketid:(NSString *)advid andTicketid:(NSString *)ticketid updataViewBlock:(UpDateViewsBlock)updataViewBlock {
    NSString * url=[NSString stringWithFormat:@"%@/shareredenvelope",kNewRedPaket_URL];
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,
                           @"internettype":[AppDelegate getNetWorkStates],
                           @"appsofttype":@"1",
                           @"ticketid":ticketid,@"advid":advid};
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
            NSLog(@"json=%@",dicJson);
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
@end
