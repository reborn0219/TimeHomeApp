//
//  L_BikeManagerPresenter.m
//  TimeHomeApp
//
//  Created by 世博 on 16/9/6.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_BikeManagerPresenter.h"
#import "RegularUtils.h"
#import "L_NewPointPresenters.h"

@implementation L_BikeManagerPresenter
// MARK: - 添加用户自行车设备（/bike/adduserbike）（2.4废弃勿用）
/**
 *  添加用户自行车设备（/bike/adduserbike）（2.4废弃勿用）
 *
 *  @param alias           别名
 *  @param deviceno        设备号
 *  @param color           颜色
 *  @param brand           品牌
 *  @param purchasedate    购买日期
 *  @param resourceid      照片ID
 */
+ (void)addUserBikeWithAlias:(NSString *)alias deviceno:(NSString *)deviceno color:(NSString *)color brand:(NSString *)brand purchasedate:(NSString *)purchasedate resourceid:(NSString *)resourceid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/bike/adduserbike",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"alias":alias,@"deviceno":deviceno,@"color":color,@"brand":brand,@"purchasedate":purchasedate,@"resourceid":resourceid};
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
            NSLog(@"%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
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
            NSLog(@"%@",data);
        }
        
    }];

    
}
// MARK: - 获得自行车设备列表（/bike/getbikelist）
/**
 *  获得自行车设备列表（/bike/getbikelist）
 */
+ (void)getBikeListUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    
    NSString * url=[NSString stringWithFormat:@"%@/bike/getbikelist",SERVER_URL];
//    NSString * url=[NSString stringWithFormat:@"%@/bike/getbikelist",@"192.168.111.86:8080"];

    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token};
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
            
//            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicJson options:NSJSONWritingPrettyPrinted error:nil];
//            NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            //“errcode”:0
            //,”errmsg”:””
            NSLog(@"%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                NSArray *array = [L_BikeListModel mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
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
            NSLog(@"%@",data);
        }
        
    }];
    
}
// MARK: - 设置自行车锁定状态（/bike/setlock）
/**
 *  设置自行车锁定状态（/bike/setlock）
 *
 *  @param theID           用户自行车设备id
 *  @param islock          锁车状态：0否1是
 */
+ (void)setLockWithID:(NSString *)theID islock:(NSString *)islock UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/bike/setlock",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"id":theID,@"islock":islock};
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
            NSLog(@"%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
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
            NSLog(@"%@",data);
        }
        
    }];
    
}

// MARK: - 修改自行车别名（/bike/changealias）
/**
 *  修改自行车别名（/bike/changealias）
 *
 *  @param theID           用户自行车设备id
 *  @param alias           别名
 */
+ (void)changeAliasWithID:(NSString *)theID alias:(NSString *)alias UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/bike/changealias",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"id":theID,@"alias":alias};
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
            NSLog(@"%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
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
            NSLog(@"%@",data);
        }
        
    }];

    
}
// MARK: - 解除设备绑定（/bike/deletebike）
/**
 *  解除设备绑定（/bike/deletebike）
 *
 *  @param theID           用户自行车设备id
 */
+ (void)deleteBikeWithID:(NSString *)theID UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/bike/deletebike",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"id":theID};
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
            NSLog(@"%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
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
            NSLog(@"%@",data);
        }
        
    }];

    
}

// MARK: - ------------------------------新二轮车接口------------------------------
// MARK: - 二轮车共享（/bike/bikeshare）
/**
 *  二轮车共享（/bike/bikeshare）
 *
 *  @param theID           用户自行车设备id
 *  @param mobilephone     手机号
 *  @param sharename       联系人
 */
+ (void)shareBikeInfoWithID:(NSString *)theID mobilephone:(NSString *)mobilephone sharename:(NSString *)sharename UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/bike/bikeshare",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"id":theID,@"mobilephone":mobilephone,@"sharename":sharename};
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
            NSLog(@"%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
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
            NSLog(@"%@",data);
        }
        
    }];
    
    
}
// MARK: - 二轮车取消共享（/bike/delshare）
/**
 *  二轮车取消共享（/bike/delshare）
 *
 *  @param theID           被共享id
 */
+ (void)delshareBikeInfoWithID:(NSString *)theID UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/bike/delshare",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"id":theID};
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
            NSLog(@"%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
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
            NSLog(@"%@",data);
        }
        
    }];
    
    
}
// MARK: - 新版添加用户自行车设备（/bike/adduserbike）
/**
 *  新版添加用户自行车设备（/bike/adduserbike）
 *
 *  @param deviceno        设备号-设备号(可以为空)
 *  @param color           颜色-
 *  @param brand           品牌-
 *  @param resourceid      照片ID-照片ID(多个逗号分隔)
 *  @param communityid     社区id-
 *  @param defaultresourceid     默认的照片id-
 *  @param devicetype      二轮车类型 默认0：自行车 1电动车-

 */
+ (void)newAddUserBikeWithDeviceno:(NSString *)deviceno devicetype:(NSString *)devicetype color:(NSString *)color brand:(NSString *)brand resourceid:(NSString *)resourceid  defaultresourceid:(NSString *)defaultresourceid communityid:(NSString *)communityid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/bike/adduserbike",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"deviceno":deviceno,@"devicetype":devicetype,@"color":color,@"brand":brand,@"resourceid":resourceid,@"defaultresourceid":defaultresourceid,@"communityid":communityid};
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
            NSLog(@"%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
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
            NSLog(@"%@",data);
        }
        
    }];
    
    
}

// MARK: - 根据二轮车id获取二轮车被分享人的信息列表（/bike/getsharelist）
/**
 根据二轮车id获取二轮车被分享人的信息列表（/bike/getsharelist）

 @param theID 用户自行车id
 */
+ (void)getShareListWithID:(NSString *)theID UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/bike/getsharelist",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"id":theID};
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
            NSLog(@"%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0 || errcode == 99999)//返回操作成功
            {
                NSArray *array = [L_BikeShareInfoModel mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
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
            NSLog(@"%@",data);
        }
        
    }];
    
}
// MARK: - 二轮车修改接口（/bike/changebike）
/**
    二轮车修改接口（/bike/changebike）
 *  @param deviceno        设备号-设备号(可以为空)
 *  @param color           颜色-
 *  @param brand           品牌-
 *  @param resourceid      照片ID-照片ID(多个逗号分隔)
 *  @param communityid     社区id-
 *  @param defaultresourceid     默认的照片id-
 *  @param devicetype      二轮车类型 默认0：自行车 1电动车-
 */
+ (void)changeBikeWithID:(NSString *)theID deviceno:(NSString *)deviceno devicetype:(NSString *)devicetype color:(NSString *)color brand:(NSString *)brand resourceid:(NSString *)resourceid  defaultresourceid:(NSString *)defaultresourceid communityid:(NSString *)communityid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/bike/changebike",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"id":theID,@"deviceno":deviceno,@"devicetype":devicetype,@"color":color,@"brand":brand,@"resourceid":resourceid,@"defaultresourceid":defaultresourceid,@"communityid":communityid};
    
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
            NSLog(@"%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
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
            NSLog(@"%@",data);
        }
        
    }];
    
}
// MARK: - 修改二轮车 解锁，开锁设置（/bike/changeopenclose）
/**
 修改二轮车 解锁，开锁设置（/bike/changeopenclose）
 *  @param theID        用户自行车id
 *  @param isopen       总开关是否开启定时0未开启 1已开启
 *  @param opentype     解锁是否开启0:未开启 1已开启
 *  @param closetype    锁车是否开启0:未开启1已开启
 *  @param closesettime 锁车时间 22:00
 *  @param closesetweek 锁车的周期 逗号拼接 (1,3,5)
 *  @param opensettime  解锁的时间（07:00）
 *  @param opensetweek  解锁设置的周期(1,2,3) 逗号拼接 1代表周一  7代表周日
 */
+ (void)changeOpenCloseWithID:(NSString *)theID model:(L_TimeSetInfoModel *)model UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/bike/changeopenclose",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"id":theID,@"isopen":[NSString stringWithFormat:@"%@",model.lockstate],@"opentype":model.openstate,@"closetype":model.closestate,@"closesettime":model.closetime,@"closesetweek":model.closetimes,@"opensettime":model.opentime,@"opensetweek":model.opentimes};
    
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
            NSLog(@"%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
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
            NSLog(@"%@",data);
        }
        
    }];
    
}
// MARK: - 二轮车定时详情（/bike/getbiketimeset
/**
 二轮车定时详情（/bike/getbiketimeset）
 {
 "errcode": 0,
 "errmsg": "成功获取二轮车定时详情",
 "map": {
         "isopen": 1,
         "closeinfo": {
                         "settime": "22:00",
                         "isopen": 1,
                         "setweek": "1,2,3,4,5,6,7"
                      },
         "id": "b71d034152384c9cbf4f4aa992e226d5",
         "openinfo": {
                         "settime": "07:05",
                         "isopen": 1,
                         "setweek": "1,2,3,4,5,6,7"
                     }
         }
 }

 */
+ (void)getBikeTimeSetWithID:(NSString *)theID UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/bike/getbiketimeset",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"id":theID};
    
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
            NSLog(@"%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                NSDictionary *mapDict = dicJson[@"map"];
                L_TimeSetInfoModel *timeModel = [[L_TimeSetInfoModel alloc] init];
                timeModel.lockstate = [NSNumber numberWithInteger:[mapDict[@"isopen"] integerValue]];//总开关是否开启0未开启 1开启
                timeModel.openstate = [NSString stringWithFormat:@"%@",[mapDict[@"openinfo"] objectForKey:@"isopen"]];
                timeModel.closestate = [NSString stringWithFormat:@"%@",[mapDict[@"closeinfo"] objectForKey:@"isopen"]];
                
                timeModel.opentime = [NSString stringWithFormat:@"%@",[mapDict[@"openinfo"] objectForKey:@"settime"]];
                timeModel.opentimes = [NSString stringWithFormat:@"%@",[mapDict[@"openinfo"] objectForKey:@"setweek"]];
                
                timeModel.closetime = [NSString stringWithFormat:@"%@",[mapDict[@"closeinfo"] objectForKey:@"settime"]];
                timeModel.closetimes = [NSString stringWithFormat:@"%@",[mapDict[@"closeinfo"] objectForKey:@"setweek"]];
                
//                timeModel.parkingcarid = [NSString stringWithFormat:@"%@",mapDict[@"id"]];

                updataViewBlock(timeModel,SucceedCode);
                
            }
            else//返回操作失败
            {
                updataViewBlock(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
            NSLog(@"%@",data);
        }
        
    }];
    
}

#pragma mark - 获取二轮车详情

/**
 获取二轮车详情
 
 @param theID id
 @param updataViewBlock
 */
+ (void)getNewBikeInfoWithID:(NSString *)theID UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/bike/getnewbikeinfo",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"id":theID};
    
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
            NSLog(@"%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                NSDictionary *mapDict = dicJson[@"map"];
                L_BikeListModel *model = [L_BikeListModel mj_objectWithKeyValues:mapDict];
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
            NSLog(@"%@",data);
        }
        
    }];
    
}

#pragma mark - 保存和锁定二轮车（/bike/saveandlock）

/**
 *  保存和锁定二轮车（/bike/saveandlock）
 *
 *  @param deviceno        设备号-设备号(可以为空)
 *  @param color           颜色-
 *  @param brand           品牌-
 *  @param resourceid      照片ID-照片ID(多个逗号分隔)
 *  @param communityid     社区id-
 *  @param defaultresourceid     默认的照片id-
 *  @param devicetype      二轮车类型 默认0：自行车 1电动车-
 
 */
+ (void)saveAndLockBikeWithDeviceno:(NSString *)deviceno devicetype:(NSString *)devicetype color:(NSString *)color brand:(NSString *)brand resourceid:(NSString *)resourceid  defaultresourceid:(NSString *)defaultresourceid communityid:(NSString *)communityid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/bike/saveandlock",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"deviceno":deviceno,@"devicetype":devicetype,@"color":color,@"brand":brand,@"resourceid":resourceid,@"defaultresourceid":defaultresourceid,@"communityid":communityid};
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
            NSLog(@"%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
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
            NSLog(@"%@",data);
        }
        
    }];
    
    
}

#pragma mark - 获得用户的报警记录

/**
 获得用户的报警记录
 
 @param updataViewBlock
 */
+ (void)getUserBikeAlermWith:(NSInteger)page UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/bike/getuserbikealerm",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"page":[NSString stringWithFormat:@"%ld",page]};
    
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
            NSLog(@"%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                NSArray *array = [L_BikeAlermModel mj_objectArrayWithKeyValuesArray:dicJson[@"list"]];
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
            NSLog(@"%@",data);
        }
        
    }];
    
}

#pragma mark - 删除用户二轮车报警记录

/**
 删除用户二轮车报警记录
 
 @param theID 记录id
 @param updataViewBlock
 */
+ (void)removeUserBikeAlermWithID:(NSString *)theID UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/bike/removeuserbikealerm",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"logid":theID};
    
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
            NSLog(@"%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
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
            NSLog(@"%@",data);
        }
        
    }];
    
}

@end
