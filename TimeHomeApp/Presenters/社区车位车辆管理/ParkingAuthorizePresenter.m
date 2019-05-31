//
//  ParkingAuthorizePresenter.m
//  TimeHomeApp
//
//  Created by us on 16/3/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ParkingAuthorizePresenter.h"
#import "RegularUtils.h"

@implementation ParkingAuthorizePresenter
/**
 获得业主授权车位信息（/parkingarea/getownerparkingarea）
 */
+(void)getOwnerParkingAreaForupDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/parkingarea/getownerparkingarea",SERVER_URL];
    NSDictionary * param=@{@"token":appDelegate.userData.token};
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
             ,“list”:[{
             ”id”:”12”
             ,”communityname”:”金谈固家园”
             ,”name”:”506号”
             ,”expiretime”:”2016-06-30”
             ,”state”:1
             ,”carid”:”12”
             ,”card”:”冀A10086”
             ,”carremarks”:”备注谁的车”
             ,”carphone”:”153153222”
             ,”type”:0
             ,”userlist”:[{
             “powerid”:”122”
             ,”name”:”儿子”
             ,”phone”:”13961315131”
             ,”rentbegindate”:”2015-01-01”
             ,”rentenddate”:”2015-01-01”
             }]
             }]
             */
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                NSLog(@"%@",dicJson);
                NSMutableArray * citylist = [ParkingOwner mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]] ;
                updataViewBlock(citylist,SucceedCode);
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
        else if(resultCode==TOKENInvalid)//登录失效
        {
            updataViewBlock(data,resultCode);
        }
    }];
}
/**
 保存车位授权信息（/parkingarea/saveparkingareapower）
 powertype	授权方式 0 共享 1 租用
 parkingareaid	需要分配的车位id
 phone	需要分配的用户的手机号
 name	用户备注名
 rentbegindate	租用时开始时间
 rentenddate	租用时结束时间
 */
+(void)saveParkingPowerForType:(NSString *) powertype parkingareaid:(NSString *)parkingareaid phone:(NSString *)phone name:(NSString *)name rentbegindate:(NSString *)rentbegindate rentenddate:(NSString *)rentenddate upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    
    if ([XYString isBlankString:phone]) {
        updataViewBlock(@"您还没有填写被授权人的手机号",FailureCode);
        return;
    }
    if (![RegularUtils isPhoneNum:phone]) {
        updataViewBlock(@"手机号码格式不正确",FailureCode);
        return;
    }
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([XYString isBlankString:name]) {
        updataViewBlock(@"您还没有填写被授权人的姓名",FailureCode);
        return;
    }
    if (name.length > 0) {
        if (name.length < 2 || name.length > 4) {
            updataViewBlock(@"被授权人的姓名应为2-4字",FailureCode);
            return;
        }
    }
    if ([XYString isBlankString:rentbegindate]) {
        updataViewBlock(@"请选择开始日期",FailureCode);
        return;
    }
    if ([XYString isBlankString:rentenddate]) {
        updataViewBlock(@"请选择结束日期",FailureCode);
        return;
    }
    
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/parkingarea/saveparkingareapower",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"powertype":powertype,@"parkingareaid":parkingareaid,@"phone":phone,@"name":name,@"rentbegindate":rentbegindate,@"rentenddate":rentenddate};
    
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
/**
 移除住宅授权信息（/parkingarea/deleteparkingareapower）
 powerid	权限记录id
 */
+(void)deleteParkingareaPowerForPowerid:(NSString *)powerid  upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    if ([XYString isBlankString:powerid]) {
        updataViewBlock(@"数据异常，请联系物业",FailureCode);
        return;
    }
    
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/parkingarea/deleteparkingareapower",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"powerid":powerid};
    
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
/**
 续租车位授权信息（/parkingarea/renewparkingareapower）
 id	车位id
 begindate	租用开始时间
 enddate	租用到期时间
 */
+(void)renewParkingareaPowerForID:(NSString *)ID begindate:(NSString *)begindate enddate:(NSString *)enddate upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/parkingarea/renewparkingareapower",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"id":ID,@"begindate":begindate,@"enddate":enddate};
    
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
@end
