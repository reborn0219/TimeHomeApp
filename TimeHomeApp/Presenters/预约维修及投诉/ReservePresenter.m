//
//  ReservePresenter.m
//  TimeHomeApp
//
//  Created by us on 16/3/30.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
///预约维修及投诉 发布
#import "ReservePresenter.h"

@implementation ReservePresenter

/**
 获得我的保修单（/reserve/getuserreserve）
 page	页码数
 */
+(void)getUserReserveForPage:(NSString *) page upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/reserve/getuserreserve",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"page":page};
    
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
            /**
             “errcode”:0
             ,”errmsg”:””
             ,”list”:[{
             “id”: ”12”
             ,”reserveno”:”21521521223”
             ,”typeid”: ”2”
             ,”typename”:”家电”
             ,”feedback”:”家电坏了速度”
             ,”residenceid”:1232
             ,”addressid”: ”1”
             ,”address”:”月坛园1号楼2单元301”
             ,”phone”:”15028106232”
             ,”propertyname”:”分配的物业名称”
             ,”processdate”:”2015-01-01 23:59”
             ,”isok”:1
             ,”state”:1
             ,”visitlinkman”:”张三”
             ,”visitlinkphone”:”1232323232”
             ,”views”:”马上去修”
             ,”visitdate”:”2015-01-01 23:59”
             ,”okdate”:”2015-02-01 23:59”
             ,”evaluatelevel”:1
             ,”evaluate”:”还不错”
             ,”evaluatedate”:”2015-02-02 23:59”
             ,”systime”:”2015-10-10 12:12”
             ,”pricedesc”:”价格描述”
             ,”piclist”:[{
             “id”, ”12232”
             ,”fileurl”:”http://...”
             }]
             }]
             */
            NSLog(@"我的报修===%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0 || errcode == 99999)//返回操作成功
            {
                NSLog(@"%@",dicJson);
                NSMutableArray *array = [UserReserveInfo mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
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
/** 查看维修进度日志
 获得我的保修单日志（/reserve/getreservelog）
 reserveid	维修记录id
 */
+(void)getReserveLogForReserveid:(NSString *) reserveid upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/reserve/getreservelog",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"reserveid":reserveid};
    
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
            /**
             “errcode”:0
             ,”errmsg”:””
             ,”list”:[{
             ”state”:1
             ,”content”:”维修完成，等待评价”
             ,”systime”:”2015-02-02 23:59”
             }]
             */
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                NSLog(@"%@",dicJson);
                NSMutableArray *array = [UserReserveLog mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
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
 评价在线保修（/reserve/ evaluatereserve）
 reserveid	在线报修id
 evaluatelevel	评价等级 1 非常满意 2 满意 3 不满意
 evaluate	评价内容
 */
+(void)evaluateReserveForReserveid:(NSString *) reserveid evaluatelevel:(NSString *)evaluatelevel evaluate:(NSString *)evaluate upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    if ([XYString isBlankString:evaluate]) {
        updataViewBlock(@"评价内容不能为空",FailureCode);
        return;
    }

    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/reserve/evaluatereserve",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"reserveid":reserveid,@"evaluatelevel":evaluatelevel,@"evaluate":evaluate};
    
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
            /**
             “errcode”:0
             ,”errmsg”:””
             */
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(@"发表评价成功",SucceedCode);
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
 预约延期短信（/reserve/remindmsg）
 reserveid	在线报修id
 */
-(void)remindMsgForReserveid:(NSString *) reserveid upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/reserve/remindmsg",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"reserveid":reserveid};
    
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
            /**
             “errcode”:0
             ,”errmsg”:””
             */
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

#pragma mark ----------------------投诉列表------------------
/**
 获得我的物业投诉（/complaint/getusercomplaint）
 page	页码数
 */
+(void)getUserComplaintForPage:(NSString *) page upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/complaint/getusercomplaint",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"page":page};
    
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
            /**
             “errcode”:0
             ,”errmsg”:””
             ,”list”:[{
             “id”:”123”
             ,”complaintno”:”21521521223”
             ,”propertyid”:”23”
             ,”propertyname”:”金谈固”
             ,”content”:”太坏了”
             ,”state”:1
             ,”views”:”我们不坏”
             ,”viewsdate”:”2015-01-01 10:01”
             ,”systime“:”2015-01-01 12:12”
             ,”piclist”:[{
             “id”,”12232”
             ,”fileurl”:”http://...”
             }]
             }]
             */
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0 || errcode == 99999)//返回操作成功
            {
                NSLog(@"%@",dicJson);
                NSMutableArray *array = [UserComplaint mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
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
