//
//  L_CarErrorPresenter.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/6/21.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_CarErrorPresenter.h"

@implementation L_CarErrorPresenter

/**
 1.获得车牌纠错需要的门口 parkinglot/getcorrgate
 
 @param card 车牌号
 @param updataViewBlock updataViewBlock
 */
+ (void)getcorrgateWithCard:(NSString *)card updataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/parkinglot/getcorrgate",kCarError_SEVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"card":card};
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
                NSArray *array = [L_CorrgateModel mj_objectArrayWithKeyValuesArray:dicJson[@"list"]];
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
 2.保存车牌纠错申请 carcorrection/saveapply
 
 @param card 车牌号
 @param aisleid 门口进口id
 @param updataViewBlock updataViewBlock
 */
+ (void)saveApplyWithCard:(NSString *)card withAisleid:(NSString *)aisleid updataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/carcorrection/saveapply",kCarError_SEVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"card":card,@"aisleid":aisleid};
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
            //            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
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
 3.获得用户车牌纠错历史纪录 carcorrection/getuserapplylist
 
 @param page 页码
 @param updataViewBlock updataViewBlock
 */
+ (void)getUserApplyListWithPage:(int)page updataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/carcorrection/getuserapplylist",kCarError_SEVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"page":[NSString stringWithFormat:@"%d",page]};
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
//            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"json=%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                NSArray *array = [L_CarNumApplyListModel mj_objectArrayWithKeyValuesArray:dicJson[@"list"]];
                updataViewBlock(array,SucceedCode);
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
 4.获得当前用户关联车牌列表 /car/getcorrcard
 
 @param updataViewBlock updataViewBlock
 */
+ (void)getCorrardUpdataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/car/getcorrcard",kCarError_SEVER_URL];
    
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
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"json=%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                NSArray *array = dicJson[@"list"];
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
 5.获得当前车牌的保存状态 /car/getcardstate
 
 @param updataViewBlock updataViewBlock
 */
+ (void)getCardStateWithCard:(NSString *)card UpdataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/car/getcardstate",kCarError_SEVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"card":card};
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
//            NSString *errmsg=[dicJson objectForKey:@"errmsg"];
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

@end
