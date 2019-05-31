//
//  L_NewPointPresenters.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/16.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NewPointPresenters.h"

@implementation L_NewPointPresenters

#pragma mark - 上传积分信息（/integral/upduserintebytype）
/**
 上传积分信息（/integral/upduserintebytype）

 @param type 2 完善资料 11注册 12二轮车防盗资料完善 13查看新手使用指南 18分享帖子 19分享活动 20发帖子 21删除帖子
 @param content 18分享帖子 19分享活动 20发帖子 21删除帖子
 @param costinte 消耗积分，默认为0；因type为14，15，16没有规划，暂定用该字段为积分消耗分数，其他类型都为0
 @param updataViewBlock
 */
+ (void)updUserIntebyTypeWithType:(NSInteger)type content:(NSString *)content costinte:(NSString *)costinte updataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/integral/upduserintebytype",SERVER_URL];
    AppDelegate *appDelegate = GetAppDelegates;
    
    if ([XYString isBlankString:costinte]) {
        costinte = @"0";
    }

    NSDictionary * param=@{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"type":[NSString stringWithFormat:@"%ld",(long)type],@"content":content,@"costinte":costinte};
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

#pragma mark - 获得个人每日任务和首次任务状态列表（/integral/gettaskstate）
/**
 获得个人每日任务和首次任务状态列表（/integral/gettaskstate）

 @param types ”1,201,18,2,12,13,20,”类型，每日任务：对应的types 1每日签到 201发表帖子（每日任务的） 18分享帖子
                                         新手任务：
                                         2完善个人资料 12完善二轮车防盗资料 13查看新手指南 20新帖发布（新手任务的）

 @param updataViewBlock
 */
+ (void)getTaskStateWithTypes:(NSString *)types updataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/integral/gettaskstate",SERVER_URL];
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"types":types};
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

#pragma mark - 获得用户兑换的所有的兑换券（/merchantgoodslog/getgoodsloglist）

/**
 获得用户兑换的所有的兑换券（/merchantgoodslog/getgoodsloglist）

 @param state 状态 0为已兑换但是没有使用的 -1过期  （1已使用即已核销的）
 @param isexchange 是否赠予 0否 1是
 @param updataViewBlock
 */
+ (void)getGoodsLoglistWithState:(NSString *)state isexchange:(NSInteger)isexchange updataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/merchantgoodslog/getgoodsloglist",SERVER_URL];
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param=@{@"userid":appDelegate.userData.userID,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"state":state,@"isexchange":[NSString stringWithFormat:@"%ld",isexchange]};
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
            if(errcode==0 || errcode==99999)//返回操作成功
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

#pragma mark - 赠予礼券（/merchantgoodslog/presentcertificate）

/**
 赠予礼券（/merchantgoodslog/presentcertificate）
 
 @param userid  要赠予的用户id
 @param id      赠予券后台记录id
 @param message 内容
 @param updataViewBlock
 */
+ (void)persentCertificateWithUserid:(NSString *)userid theid:(NSString *)theid message:(NSString *)message updataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/merchantgoodslog/presentcertificate",SERVER_URL];
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"userid":userid,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"id":theid,@"message":[XYString IsNotNull:message]};
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

#pragma mark - 获得我的票券信息（/merchantgoodslog/getmycertificate）

/**
 获得我的票券信息（/merchantgoodslog/getmycertificate）
 
 @param type  类型 2代表赠予券  9代表商城兑换券
 @param token 登录令牌
 @param updataViewBlock
 */
+ (void)getMyCertificateWithType:(NSString *)type coupontype:(NSString *)coupontype updataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/getmycertificate",kNewRedPaket_URL];
//    NSString * url=[NSString stringWithFormat:@"%@/merchantgoodslog/getmycertificate",SERVER_URL];

    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"type":type,@"coupontype":coupontype,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
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
            /*
            {
                “errcode”:0
                ,”errmsg”:””
                ,”map”:[
                        “isexchange”:1,
                        “state”:0,
                        “number”:2
                        ]
            }
            */
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

#pragma mark - 获得我的中奖记录（/drawrecord/getuserrecordlist）

/**
 获得我的中奖记录（/drawrecord/getuserrecordlist）
 
 @param token 登录令牌
 @param updataViewBlock
 */
+ (void)getUserRecordListUpdataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/drawrecord/getuserrecordlist",SERVER_URL];
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
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
            /*
             {
             “errcode”:0
             ,”errmsg”:””
             ,”map”:[
             “isexchange”:1,
             “state”:0,
             “number”:2
             ]
             }
             */
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"json=%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                NSArray *array = [L_RecordListModel mj_objectArrayWithKeyValuesArray:dicJson[@"list"]];
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

#pragma mark - 获得用户商城兑换券记录（/drawrecord/getusercouponlist）

/**
 获得用户商城兑换券记录（/drawrecord/getusercouponlist）
 
 @param token 登录令牌
 @param updataViewBlock
 */
+ (void)getUserCouponListUpdataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/drawrecord/getusercouponlist",SERVER_URL];
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
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
            /*
             {
             “errcode”:0
             ,”errmsg”:””
             ,”map”:[
             “isexchange”:1,
             “state”:0,
             “number”:2
             ]
             }
             */
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"json=%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                NSArray *array = [L_CouponListModel mj_objectArrayWithKeyValuesArray:dicJson[@"list"]];
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
