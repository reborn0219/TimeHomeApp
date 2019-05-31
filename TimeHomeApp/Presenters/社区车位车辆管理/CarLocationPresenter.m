//
//  CarLocationPresenter.m
//  TimeHomeApp
//
//  Created by us on 16/3/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
///车辆定位管理
#import "CarLocationPresenter.h"
#import "CarListModel.h"
#import "EncryptUtils.h"
#import "CarLocationInfo.h"

@implementation CarLocationPresenter
{
    NSTimer * carTimer;//定时器
    NSString * access_token;
    NSString * IMEI;
    NSString * acc_Tmp;
    
    ///定位回调
    UpDateViewsBlock updataLoactionBlock;
}

/**
 车辆定位列表（/carposition/getusercarposition）
 */
-(void)getUserCarPositionForPage:(NSString*) page  upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/carposition/getusercarposition",SERVER_URL];
    
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
             ,”list”[{
             “id”:”1212”
             ,”card”:”冀A1086”
             ,”username”:”fdfdsdf”
             ,”password”:”mima”
             ,”imei”:”dfdfefer2e135321”
             }]
             */
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                NSArray * array=[CarListModel mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
                updataViewBlock(array,SucceedCode);
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
/**
 新增车辆定位列表（/carposition/addusercarposition）
 card   车牌号
 imei  设备IMEI号
 */
-(void)addUserCarPositionForCard:(NSString*) card imei:(NSString *)imei upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/carposition/addusercarposition",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"card":card,@"imei":imei};
    
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
             ,”id”:”122”
             ,”username”:”2dfdf”
             ,”password”:”dfdf”
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
 修改车辆定位车牌号（/carposition/changeusercard）
 card   车牌号
 id  车辆Id
 */
-(void)changeUserCardForCard:(NSString*) card ID:(NSString *)ID upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/carposition/changeusercard",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"card":card,@"id":ID};
    
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
 删除车辆定位信息（/carposition/removeusercarposition）
 id  删车辆id
 */
-(void)removeusercarpositionForID:(NSString *)ID upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    AppDelegate * appDelegate=GetAppDelegates
    //
    NSString * url=[NSString stringWithFormat:@"%@/carposition/removeusercarposition",SERVER_URL];
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"id":ID};
    
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


#pragma  mark ---------------设备定位-----------------

///获取登录认证
-(void ) GetAccessForAcc:(NSString *) acc  pw:(NSString *)pwd upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    long recordTime = [[NSDate date] timeIntervalSince1970];
    NSString * ts=[NSString stringWithFormat:@"%ld",recordTime];
    acc_Tmp=acc;
    NSString * name=acc;
    NSString * password=pwd;
    NSString * md5=[EncryptUtils md5HexDigest:[NSString stringWithFormat:@"%@%@",[EncryptUtils md5HexDigest:password],ts]];
    NSString * url=[NSString stringWithFormat:
                    @"http://api.gpsoo.net/1/auth/access_token?account=%@&time=%@&signature=%@",name,ts,md5];
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.HTTPMethod=@"get";
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            if(dicJson==nil)
            {
                updataViewBlock(@"登录失败",SucceedCode);
                return ;
            }
            access_token=[dicJson objectForKey:@"access_token"];
            updataViewBlock(access_token,SucceedCode);

        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
        }
    }];


}
///获取车定位信息
-(void) getCarInfo
{
    if (access_token==nil) {
        updataLoactionBlock(@"无效登录令牌",FailureCode);
        return;
    }
    long recordTime = [[NSDate date] timeIntervalSince1970];
    NSString * ts=[NSString stringWithFormat:@"%ld",recordTime];
    //    NSString * url=[NSString stringWithFormat:
    //                    @"http://api.gpsoo.net/1/devices/tracking?access_token=%@&target=shgaosu&account=shgaosu&time=%@&map_type=BAIDU",access_token,ts];
    
    //access_token=0011045701369822736adb020814946df1ded1c8681d026d5c5&map_type=BAIDU&account=testacc&imeis=353419031939627,353419032982170&time=1366786321
    NSString * url=[NSString stringWithFormat:
                    @"http://api.gpsoo.net/1/devices/tracking?access_token=%@&imeis=%@&account=%@&time=%@&map_type=BAIDU",access_token,IMEI,acc_Tmp,ts];
    NSLog(@"url=:%@",url);
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.HTTPMethod=@"get";
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataLoactionBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"aString======%@",aString);
            NSArray * listData;
            NSError *error;
            NSDictionary * resultDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if (error) {
                updataLoactionBlock(@"json解析错误",FailureCode);
            }
            else
            {
                listData=[resultDic objectForKey:@"data"];
                NSInteger count=[listData count];
                NSDictionary * dic;
                CarLocationInfo *bancheInfo=[[CarLocationInfo alloc]init];
                for (int i=0; i<count; i++) {
                    dic=[listData objectAtIndex:i];
                    bancheInfo.imei=[dic objectForKey:@"imei"];
                    bancheInfo.lat=[[dic objectForKey:@"lat"] doubleValue];
                    bancheInfo.lng=[[dic objectForKey:@"lng"] doubleValue];
                    bancheInfo.direction=[[dic objectForKey:@"course"] doubleValue];
                    bancheInfo.speed=[dic objectForKey:@"speed"];
                }
                updataLoactionBlock(bancheInfo,SucceedCode);
                
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataLoactionBlock(data,resultCode);
        }
    }];
}
///定时刷新车定位信息
-(void) startCarTimeTorefresh:(NSString *)imei  upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    updataLoactionBlock=updataViewBlock;
    IMEI=imei;
    if(carTimer)
    {
        [carTimer invalidate];
        carTimer=nil;
    }
    carTimer=[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(getCarInfo) userInfo:nil repeats:YES];
}


///取消定时器
-(void)cancalTimer
{
    if(carTimer)
    {
        [carTimer invalidate];
        carTimer=nil;
    }
}
///获取当前定位车辆地址
-(void)getCarAddrForAcc:(NSString *) acc  pw:(NSString *)pwd imei:(NSString *)aIMEI upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    
    [self GetAccessForAcc:acc pw:pwd upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        NSString * taken=(NSString *)data;
        if(![XYString isBlankString:taken])
        {
            [self getCarLoactionInfoToken:taken imei:aIMEI Acc:acc upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                CarLocationInfo *bancheInfo=(CarLocationInfo *)data;
                [self getAddrStringForToken:taken Acc:acc lat:bancheInfo.lat lng:bancheInfo.lng upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                    if(resultCode==NONetWorkCode)//无网络处理
                    {
                        updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
                    }
                    else if(resultCode==SucceedCode)//成功返回数据
                    {
                        
                        updataViewBlock(data,SucceedCode);

                    }
                    else if(resultCode==FailureCode)//返回数据失败
                    {
                        updataViewBlock(@"获取地址失败",resultCode);
                    }
                }];
                
            }];
        }
        
    }];
}

//获车位置信息
-(void) getCarLoactionInfoToken:(NSString *) Token imei:(NSString *)aIMEI Acc:(NSString *) acc upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
//    if (access_token==nil) {
//        updataViewBlock(@"无效登录令牌",FailureCode);
//        return;
//    }
    long recordTime = [[NSDate date] timeIntervalSince1970];
    NSString * ts=[NSString stringWithFormat:@"%ld",recordTime];
    //    NSString * url=[NSString stringWithFormat:
    //                    @"http://api.gpsoo.net/1/devices/tracking?access_token=%@&target=shgaosu&account=shgaosu&time=%@&map_type=BAIDU",access_token,ts];
    
    NSString * url=[NSString stringWithFormat:
                    @"http://api.gpsoo.net/1/devices/tracking?access_token=%@&imeis=%@&account=%@&time=%@&map_type=BAIDU",Token,aIMEI,acc,ts];
    NSLog(@"url=:%@",url);
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.HTTPMethod=@"get";
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"aString======%@",aString);
            NSArray * listData;
            NSError *error;
            NSDictionary * resultDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if (error) {
                updataViewBlock(@"json解析错误",FailureCode);
            }
            else
            {
                listData=[resultDic objectForKey:@"data"];
                NSInteger count=[listData count];
                NSDictionary * dic;
                CarLocationInfo *bancheInfo=[[CarLocationInfo alloc]init];
                for (int i=0; i<count; i++) {
                    dic=[listData objectAtIndex:i];
                    bancheInfo.imei=[dic objectForKey:@"imei"];
                    bancheInfo.lat=[[dic objectForKey:@"lat"] doubleValue];
                    bancheInfo.lng=[[dic objectForKey:@"lng"] doubleValue];
                    bancheInfo.direction=[[dic objectForKey:@"course"] doubleValue];
                    bancheInfo.speed=[dic objectForKey:@"speed"];
                }
                updataViewBlock(bancheInfo,SucceedCode);
                
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
        }
    }];

}
//获取定位地址
-(void) getAddrStringForToken:(NSString *)token Acc:(NSString * )acc lat:(double)lat lng:(double)lng upDataViewBlock:(UpDateViewsBlock)updataViewBlock
{
    if (access_token==nil) {
        updataViewBlock(@"无效登录令牌",FailureCode);
        return;
    }
    long recordTime = [[NSDate date] timeIntervalSince1970];
    NSString * ts=[NSString stringWithFormat:@"%ld",recordTime];
    
    
    //http://api.gpsoo.net/1/tool/address?lng=114.343088&lat=30.682888& access_token=0011045701369822736adb020814946df1ded1c8681d026d5c5&account=testacc&map_type=BAIDU&time= 1366786321
    NSString * url=[NSString stringWithFormat:
                    @"http://api.gpsoo.net/1/tool/address?lng=%lf&lat=%lf&access_token=%@&account=%@&map_type=BAIDU&time=%@",lng,lat,token,acc,ts];
    NSLog(@"url=:%@",url);
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.HTTPMethod=@"get";
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"aString======%@",aString);
            NSError *error;
            NSDictionary * resultDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if (error) {
                updataViewBlock(@"json解析错误",FailureCode);
            }
            else
            {
                NSInteger ret=[(NSNumber *)[resultDic objectForKey:@"ret"]integerValue];
                if (ret==0) {
                    NSString * addrs=[resultDic objectForKey:@"address"];
                   updataViewBlock(addrs,SucceedCode);
                }
                else
                {
                    updataViewBlock(@"没有找到地址",FailureCode);
                }

                
                
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
        }
    }];
    
    
}

@end
