//
//  ParkingManagePresenter.m
//  TimeHomeApp
//
//  Created by us on 16/3/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ParkingManagePresenter.h"

@implementation ParkingManagePresenter
///获得个人拥有车位信息（/parkingarea/getuserparkingarea）
-(void)getUserParkingareaForupDataViewBlock:(UpDateViewsBlock)updataViewBlock;
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/parkingarea/getuserparkingarea",SERVER_URL];
    NSDictionary * param=@{@"token":appDelegate.userData.token};
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"链接失败，请检查网络",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            /**
             “errcode”:0
             ,”errmsg”:””
             ,“list”:[{
             ”id”:“12”
             ,”communityname”:”金谈固家园”
             ,”propertyname”:”恒祥物业”
             ,”name”:”金谈固106号”
             ,”expiretime”:”2016-06-30”
             ,”state”:1
             ,”type”:1
             ,”parkingcarid”:”12323”
             ,”carid”:“12”
             ,”card”:”冀A10086”
             ,”carremarks”:”被人的车”
             ,”carphone”:”1502512121”
             ,”caringate”:”南门入口”
             ,”islock”:1
             ,”rentbegindate”:”2015-01-01”
             ,”rentenddate”:”2015-06-06”
             }]
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
                NSDictionary *dic=@{@"errcode":[dicJson objectForKey:@"errcode"],@"errmsg":errmsg};
                updataViewBlock(dic,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
        }
        
    }];

}
/**获得车位下的车辆列表（/car/getparkingareacar）
 parkingareaid 车位Id
 */
-(void)getParkingAreaCarForParkingareaid:(NSString *)parkingareaid  upDataViewBlock:(UpDateViewsBlock)updataViewBlock;
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/car/getparkingareacar",SERVER_URL];
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"parkingareaid":parkingareaid};
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
             ”parkingcarid”:“12”
             ,”card”:”冀A10086”
             ,”position”:1
             ,”state”:1
             ,”remarks”:”车辆备注”
             }]
             */
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"json=getParkingAreaCarForParkingareaid==%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                NSArray * citylist=[dicJson objectForKey:@"list"];
                NSArray * listdata=[ParkingCarModel mj_objectArrayWithKeyValuesArray:citylist];
                updataViewBlock(listdata,SucceedCode);
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
 获得未入库的车辆（/car/getoutcar）
 */
-(void)getOutCarForupDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/car/getoutcar",SERVER_URL];
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
             ”carid”:“12”
             ,”card”:”冀A10086”
             ,”remarks”:”车辆备注”
             }]
             */
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"json==%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                NSArray * citylist=[dicJson objectForKey:@"list"];
                NSArray * listdata=[ParkingCarModel mj_objectArrayWithKeyValuesArray:citylist];
                updataViewBlock(listdata,SucceedCode);
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
 获得未加入到本车位中的车辆（/car/getnotparkingcar）
 */
-(void)getNoParkingCarForID:(NSString *)parkingareaid upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/car/getnotparkingcar",SERVER_URL];
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"parkingareaid":parkingareaid};
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
             ”carid”:“12”
             ,”card”:”冀A10086”
             ,”remarks”:”车辆备注”
             }]
             */
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"json===%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                NSArray * citylist=[dicJson objectForKey:@"list"];
                NSArray * listdata=[ParkingCarModel mj_objectArrayWithKeyValuesArray:citylist];
                updataViewBlock(listdata,SucceedCode);
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
 添加车牌号（/car/addcar）
 parkingareaid	对应的车位
 carids	选中车牌id
 addjson	没有添加过的车牌，需要通过json数组传递过来
 */
-(void)addCarForParkingareaid:(NSString *)parkingareaid usercarids:(NSString *)usercarids addjson:(NSString *)addjson upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/car/addcar",SERVER_URL];
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"parkingareaid":parkingareaid,@"carids":usercarids,@"addjson":addjson};
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
 修改车牌号（/car/changecar）
 parkingcarid	对应的车位
 card	车牌号
 remarks	车辆备注
 */
-(void)changeCarForUserCarID:(NSString *)parkingareaid card:(NSString *)card remarks:(NSString *)remarks upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/car/changecar",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"parkingcarid":parkingareaid,@"card":card,@"remarks":remarks};
    
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
            NSLog(@"josn===%@",dicJson);
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
 车库管理修改车牌号（/car/changeallcar）
 carid 修改的车牌id
 card 修改的车牌
 remarks 备注
 
 返回
 errocode
 errmsg
 carid 修改了车牌后的新carid
 */
-(void)changeallcarForUserCarID:(NSString *)carid card:(NSString *)card remarks:(NSString *)remarks upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/car/changeallcar",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"carid":carid,@"card":card,@"remarks":remarks};
    
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
            NSLog(@"josn===%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                updataViewBlock([dicJson objectForKey:@"carid"],SucceedCode);
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
 锁定、解锁车辆（/car/lockcar）
 parkingcarid	车辆车位记录表id
 state	解锁状态 1 锁定 0 解锁
 */
-(void)lockcarForParkingcarid:(NSString *)parkingcarid state:(NSString *)state upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/car/lockcar",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"parkingcarid":parkingcarid,@"state":state};
    
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
 通过用户车辆记录删除车牌（/car/removecarbycar）
 carid 车辆id
 */
-(void)removeCarByUserForCarid:(NSString *)carid upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/car/removecarbycar",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"carid":carid};
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
            
        }else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            /**
             “errcode”:0
             ,”errmsg”:””
             */
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"josn==%@",dicJson);
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
 通过车位车辆记录删除车牌（/car/removecarbyparking）
 parkingcarid 车辆id
 */
-(void)removeCarByParkingForParkingCarid:(NSString *)parkingcarid upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/car/removecarbyparking",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"parkingcarid":parkingcarid};
    
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
 获得车辆定时设置详细信息（/locktimer/getlocktimesetinfo）
 parkingcarid 车辆id
 */
-(void)getLockTimeSetInfoForParkingCarid:(NSString *)parkingcarid upDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    AppDelegate * appDelegate=GetAppDelegates

    NSString * url=[NSString stringWithFormat:@"%@/locktimer/getlocktimesetinfo",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"parkingcarid":parkingcarid};
    
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
            
            NSLog(@"dicJson==%@",dicJson);
            
            if(errcode==0)//返回操作成功
            {
                L_TimeSetInfoModel *model = [L_TimeSetInfoModel mj_objectWithKeyValues:[dicJson objectForKey:@"map"]];
                updataViewBlock(model,SucceedCode);
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
 保存车辆定时设置详细信息（/locktimer/savelocktimesetinfo）
 token
 登录令牌
 parkingcarid
 车位车辆关联id
 state
 设置是否启动定时 0为关 1为开
 parkingcarid
 车位车辆关联
 openlockstate
 定时开车设定状态 0为关 1为开
 closelockstate
 定时锁车设定状态 0为关 1为开
 opentime
 开启时间
 closetime
 关闭时间
 opentimes
 开锁重复时间，如”1,2,3”则代表，周一，周二，周三
 closetimes
 锁定重复时间，如”1,2,3”则代表，周一，周二，周三

 */
-(void)saveLockTimeSetInfoForParkingModel:(L_TimeSetInfoModel *)model upDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    AppDelegate * appDelegate=GetAppDelegates
    
    NSString * url=[NSString stringWithFormat:@"%@/locktimer/savelocktimesetinfo",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"parkingcarid":model.parkingcarid,@"state":[NSString stringWithFormat:@"%@",model.lockstate],@"openlockstate":model.openstate,@"closelockstate":model.closestate,@"opentime":model.opentime,@"closetime":model.closetime,@"opentimes":model.opentimes,@"closetimes":model.closetimes};
    
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
///parameters/isaddcard判断用户是否可以添加车牌
+(void)getIsAddCard:(NSString *)carid :(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates
    
    NSString * url=[NSString stringWithFormat:@"%@/parameters/isaddcard",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"parkingareaid":carid};
    
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

///获得个人拥有在库车辆和添加的自行车（parkingarea/getuserinparkinglotcarbike）

+(void)getUserinParkingLotCarBikeForupDataViewBlock:(UpDateViewsBlock)updataViewBlock{
    
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/parkingarea/getuserinparkinglotcarbike",SERVER_URL];
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
            
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"json==%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                
                updataViewBlock( dicJson,SucceedCode);
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
