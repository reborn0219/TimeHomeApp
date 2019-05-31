//
//  L_CommunityAuthoryPresenters.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_CommunityAuthoryPresenters.h"

@implementation L_CommunityAuthoryPresenters

/**
 1.获得当前社区的待认证房产与车位 community/getwaitcertinfo

 @param updataViewBlock updataViewBlock
 */
+ (void)getWaitCertInfoWithCommunityid:(NSString *)communityid UpdataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/community/getwaitcertinfo",kCarError_SEVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"token"] = appDelegate.userData.token;
    param[@"internettype"] = [AppDelegate getNetWorkStates];
    param[@"appsofttype"] = @"1";
    
    if (![XYString isBlankString:communityid]) {
        param[@"communityid"] = communityid;
    }
    
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
            if(errcode==0 || errcode == 99999)//返回操作成功
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
 2.一键认证社区下房产 community/akeycert
 
 @param updataViewBlock updataViewBlock
 */
+ (void)akeyCertWithCommunityid:(NSString *)communityid UpdataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/community/akeycert",kCarError_SEVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"token"] = appDelegate.userData.token;
    param[@"internettype"] = [AppDelegate getNetWorkStates];
    param[@"appsofttype"] = @"1";
    
    if (![XYString isBlankString:communityid]) {
        param[@"communityid"] = communityid;
    }
    
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
                [UserDefaultsStorage saveData:@"1" forKey:@"resipower"];
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
 3.获得待认证的房产个数 resicert/getwaitcertcount
 
 @param updataViewBlock updataViewBlock
 */
+ (void)getWaitCertCountUpdataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/resicert/getwaitcertcount",kCarError_SEVER_URL];
    
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
 4.业主社区房产数据 resicert/getownercertresi
 
 @param updataViewBlock updataViewBlock
 */
+ (void)getOwnerCertresiUpdataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/resicert/getownercertresi",kCarError_SEVER_URL];
    
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
                NSArray *arr = [L_MyHouseListModel mj_objectArrayWithKeyValuesArray:dicJson[@"list"]];
                updataViewBlock(arr,SucceedCode);
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
 5.获得房产信息 resicert/getresiinfo
 
 @param theID 房产id
 @param updataViewBlock updataViewBlock
 */
+ (void)getResiInfoWithID:(NSString *)theID UpdataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    if ([XYString isBlankString:theID]) {
        updataViewBlock(nil,FailureCode);
        return;
    }
    
    NSString * url=[NSString stringWithFormat:@"%@/resicert/getresiinfo",kCarError_SEVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"id":theID};
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
                L_HouseInfoModel *model = [L_HouseInfoModel mj_objectWithKeyValues:dicJson[@"map"]];
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
 6.提交申请房产认证 resicert/identresicert
 @param ownername 业主姓名
 @param buildname 楼栋名称
 @param unitname 单元名称
 @param roomnum 房间号
 @param theID 房产id
 @param updataViewBlock updataViewBlock
 */
+ (void)indentResiCertWithOwnerName:(NSString *)ownername buildName:(NSString *)buildname unitName:(NSString *)unitname roomNum:(NSString *)roomnum communityID:(NSString *)communityid UpdataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/resicert/identresicert",kCarError_SEVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"ownername":ownername,@"buildname":buildname,@"unitname":unitname,@"roomnum":roomnum,@"communityid":communityid};
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
 7.删除认证失败的申请 resicert/removeresicert
 
 @param theID 房产id
 @param updataViewBlock updataViewBlock
 */
+ (void)removeresicertWithID:(NSString *)theid UpdataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/resicert/removeresicert",kCarError_SEVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"id":theid};
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
 校验用户权限接口
 map	map	用户信息
 isownercert	int	当前社区是否业主认证 0 否 1 是
 ownerpowertype	int	0 普通用户 1 业主 2 家人 3 租户；按照该级别依次向下先符合那个类型就为那种权限类型
 ownerpower	map	认证对应的权限
 shake	int	门禁权限1 可以使用 0 不可以
 reserve	int	在线报修 1 可以使用0 不可以
 complaint	int	投诉建议
 resipower	int	房产权限操作 1 可以使用 0 不可以
 */
+ (void)checkUserPowerUpdataViewBlock:(UpDateViewsBlock)updataViewBlock {
    NSString * url=[NSString stringWithFormat:@"%@/user/checkuserpower",kCarError_SEVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param=@{@"token":appDelegate.userData.token?:@"",@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
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
 获得房产家人列表
 token	string	登陆令牌
 id	string	房产id
 */
+ (void)getResiHomeListWithID:(NSString *)theID andUpdataViewBlock:(UpDateViewsBlock)updataViewBlock {
    NSString * url=[NSString stringWithFormat:@"%@/resicert/getresihomelist",kCarError_SEVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"id":theID};
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
 修改家人备注名称
 token	string	登陆令牌
 id	string	权限id
 name	string	姓名名称
 */
+ (void)changeHomeNameWithID:(NSString *)theID andName:(NSString *)name andUpdataViewBlock:(UpDateViewsBlock)updataViewBlock {
    NSString * url=[NSString stringWithFormat:@"%@/resicert/changehomename",kCarError_SEVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param=@{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"id":theID,@"name":name};
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
