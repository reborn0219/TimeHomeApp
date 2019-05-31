//
//  UserTrafficPresenter.m
//  TimeHomeApp
//
//  Created by us on 16/3/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "UserTrafficPresenter.h"

@implementation UserTrafficPresenter


///获得我设置的访客通信列表
+(void)getUserTrafficForupDataWithType:(NSString *)type ViewBlock:(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates

    NSString * url=[NSString stringWithFormat:@"%@/traffic/getusertraffic",SERVER_URL];
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"type":type};
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
             “id”:“12122“
             ,”communityname”:”金谈固”
             ,”type”:1
             ,”residencename”:”月坛园16楼 1单元201”
             ,”visitdate”:”2015-01-01”
             ,”visitcard”:”冀A10086”
             ,”power”:1
             ,”visitname”:”张三”
             ,”visitphone”:”152102212”
              ,”gotourl”:”http://...”
             }]
             */
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"json===%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                NSArray * citylist = [UserVisitor mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
                
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
    }];

}
/**
 获得访客通信详情信息（/traffic/getusertrafficinfo）
 trafficid	通行记录id
 */
+(void)getUserTrafficInfoForID:(NSString *)trafficid upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates
    NSString * url=[NSString stringWithFormat:@"%@/traffic/getusertrafficinfo",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"trafficid":trafficid};
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
             “id”:“12122“
             ,”communityname”:”金谈固”
             ,”type”:1
             ,”residencename”:”月坛园16楼 1单元201”
             ,”visitdate”:”2015-01-01”
             ,”visitcard”:”冀A10086”
             ,”power”:1
             ,”visitname”:”张三”
             ,”visitphone”:”152102212”
              ,”gotourl”:”http://...”
             }]
             */
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"json====%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                UserVisitor * userVisitor = [UserVisitor mj_objectWithKeyValues:[dicJson objectForKey:@"map"]];
                updataViewBlock(userVisitor,SucceedCode);
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
 residenceid	到访住宅id
 visitdate	访客日期
 card	到访车辆
 power	0 进小区 1 单元门  2 电梯
 visitname	到访人
 visitphone	到访手机号
 */
+(void)addTrafficForResidenceid:(NSString *)residenceid visitdate:(NSString *)visitdate card:(NSString *)card power:(NSString *)power visitname:(NSString *)visitname visitphone:(NSString *)visitphone leavemsg:(NSString *)leavemsg upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/traffic/addtraffic",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"residenceid":residenceid,@"visitdate":visitdate,@"card":card,@"power":power,@"visitname":visitname,@"visitphone":visitphone,@"leavemsg":leavemsg};
    
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
            /**返回
             “errcode”:0
             ,”errmsg”:””
             , “id”:“12122”
             */
            
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"json==%@",dicJson);
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
/**删除访客通行记录
 Id	住宅id
 */
+(void)removeTrafficForID:(NSString *)Id upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/traffic/removetraffic",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"id":Id};
    
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
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(@"撤销成功",SucceedCode);
                
            }else//返回操作失败
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
