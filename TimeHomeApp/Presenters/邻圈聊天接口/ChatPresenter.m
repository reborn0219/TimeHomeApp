//
//  ChatPresenter.m
//  YouLifeApp
//
//  Created by UIOS on 15/10/17.
//  Copyright © 2015年 us. All rights reserved.
//

#import "ChatPresenter.h"
#import "RecentlyFriendModel.h"
#import "UserInfoModel.h"

@implementation ChatPresenter

/**
 根据type获取消息通知

 @param types 消息类型
 @param block 请求回调
 */
+(void)getUserNoticeCountWithTypes:(NSString *)types :(UpDateViewsBlock)block
{
    NSString * url=[NSString stringWithFormat:@"%@/usernotice/getusernoticecount",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"types":types};
    CommandModel *command=[[CommandModel alloc]init];
    
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"------sl消息推送数据ls----%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                NSArray * ls_dicArr = [UserNoticeCountModel mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
                block(ls_dicArr,SucceedCode);
                
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];
}

/**
 根据type获取通知详情
 
 @param type 通知类型
 @param page 页码
 @param block 回调
 */
+(void)getUserNoticeWithType:(NSString *)type andPage: (NSString *)page :(UpDateViewsBlock)block
{
    NSString * url=[NSString stringWithFormat:@"%@/usernotice/getusernotice",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"type":type,@"page":page};
    CommandModel *command=[[CommandModel alloc]init];
    
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"dicJson==%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                NSMutableArray *array = [UserNoticeModel mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
                block(array,SucceedCode);
                
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];

}
///获得消息个数
+(void)getUserNoticeCount:(UpDateViewsBlock)block
{
    NSString * url=[NSString stringWithFormat:@"%@/usernotice/getusernoticecount",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token};
    CommandModel *command=[[CommandModel alloc]init];
    
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"%@",dicJson);
            if(errcode==0)//返回操作成功
            {
//                UserData *userData = [UserData mj_objectWithKeyValues:[dicJson objectForKey:@"map"]];
                UserNoticeCountModel *model = [UserNoticeCountModel mj_objectWithKeyValues:[dicJson objectForKey:@"map"]];
                block(model,SucceedCode);
                
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];
}
///获得个人通知（/usernotice/getusernotice）
+(void)getUserNotice:(UpDateViewsBlock)block withPage: (NSString *)page
{
    NSString * url=[NSString stringWithFormat:@"%@/usernotice/getusernotice",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"page":page};
    CommandModel *command=[[CommandModel alloc]init];
    
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"dicJson==%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                NSMutableArray *array = [UserNoticeModel mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
                block(array,SucceedCode);
                
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];

}

/**
 删除单个通知
 
 @param noticeid 通知ID
 @param type 通知类型
 @param block 回调
 */

+(void)clearOneNotice:(NSString *)noticeid withType:(NSString *)type andBlock:(UpDateViewsBlock)block
{
    ////usernotice/clearonenotice

    NSString * url=[NSString stringWithFormat:@"%@/usernotice/clearonenotice",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"type":type,@"noticeid":noticeid};
    CommandModel *command=[[CommandModel alloc]init];
    
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                //                UserData *userData = [UserData mj_objectWithKeyValues:[dicJson objectForKey:@"map"]];
                block(errmsg,SucceedCode);
                
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];
    

}
/**
 删除消息接口
 
 @param ids 消息id字符串逗号分隔
 @param block 回调
 
 */
+(void)batchdelNotice:(NSString *)ids wihtBlock:(UpDateViewsBlock)block
{
    ///  /usernotice/batchdelnotice
    
    NSString * url=[NSString stringWithFormat:@"%@/usernotice/batchdelnotice",SERVER_URL];
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"ids":ids};
    CommandModel *command=[[CommandModel alloc]init];
    
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                //                UserData *userData = [UserData mj_objectWithKeyValues:[dicJson objectForKey:@"map"]];
                block(errmsg,SucceedCode);
                
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];
}
///新版清空接口个人通知（/usernotice/clearnotice）
+(void)clearNotice:(NSString *)type andNotIDs:(NSString *)notIDs withBlock:(UpDateViewsBlock)block
{
    NSString * url=[NSString stringWithFormat:@"%@/usernotice/clearnotice",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"type":type,@"notids":notIDs};
    CommandModel *command=[[CommandModel alloc]init];
    
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                //                UserData *userData = [UserData mj_objectWithKeyValues:[dicJson objectForKey:@"map"]];
                block(errmsg,SucceedCode);
                
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];
}
///清空个人通知（/usernotice/clearnotice）
+(void)clearNotice:(UpDateViewsBlock)block
{
    NSString * url=[NSString stringWithFormat:@"%@/usernotice/clearnotice",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token};
    CommandModel *command=[[CommandModel alloc]init];
    
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
//                UserData *userData = [UserData mj_objectWithKeyValues:[dicJson objectForKey:@"map"]];
                block(errmsg,SucceedCode);
                
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];

}
///获得未处理的群通知（/groupnotice/getdogroupnotice）
+(void)getDogroupNotice:(UpDateViewsBlock)block
{
    NSString * url=[NSString stringWithFormat:@"%@/groupnotice/getdogroupnotice",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token};
    CommandModel *command=[[CommandModel alloc]init];
    
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                UserData *userData = [UserData mj_objectWithKeyValues:[dicJson objectForKey:@"map"]];
                block(userData,SucceedCode);
                
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];

}

///获得聊天消息同步数据（/gamsync/getusergamsync）
+(void)getUserGamSync:(UpDateViewsBlock)block withMaxID: (NSString *)maxid
{
    NSString * url=[NSString stringWithFormat:@"%@/gamsync/getusergamsync",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    if(appDelegate.userData.token==nil)
    {
        return;
    }
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"maxid":maxid};
    CommandModel *command=[[CommandModel alloc]init];
    
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSArray * list = [dicJson objectForKey:@"list"];
            NSNumber * maxid = [dicJson objectForKey:@"maxid"];
            [[NSUserDefaults standardUserDefaults]setObject:maxid forKey:@"maxid"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            if(errcode==0)//返回操作成功
            {
                block(list,SucceedCode);
                
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];
    

}
///搜索社区内的邻友（/user/getappsearchuser）
+(void)getAppSearchuser:(UpDateViewsBlock)block withPage: (NSString *)page andName:(NSString *)name
{
    NSString * url=[NSString stringWithFormat:@"%@/user/getappsearchuser",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"page":page,@"name":name};
    CommandModel *command=[[CommandModel alloc]init];
    
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSArray * list = [dicJson objectForKey:@"list"];
            
            if(errcode==0)//返回操作成功
            {
               
                block([RecentlyFriendModel mj_objectArrayWithKeyValuesArray:list],SucceedCode);
                
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];
  
}
///获得我关注的用户（/userfllow/getfllowuser）
+(void)getFllowUser:(UpDateViewsBlock)block withPage: (NSString *)page andName:(NSString *)name andUerID:(NSString *)userid
{
    NSString * url=[NSString stringWithFormat:@"%@/userfllow/getfllowuser",SERVER_URL];
    if ([XYString isBlankString:userid]) {
        return;
    }
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"page":page,@"name":name,@"userid":userid};
    CommandModel *command=[[CommandModel alloc]init];
    
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSArray * list = [dicJson objectForKey:@"list"];
            
            if(errcode==0)//返回操作成功
            {
                block([UserInfoModel mj_objectArrayWithKeyValuesArray:list],SucceedCode);
                
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];

}
///获得我的粉丝用户（/userfllow/gettofllowuser）
+(void)getToFllowuser:(UpDateViewsBlock)block withPage: (NSString *)page andName:(NSString *)name andUerID:(NSString *)userid
{
    NSString * url=[NSString stringWithFormat:@"%@/userfllow/gettofllowuser",SERVER_URL];
    if ([XYString isBlankString:userid]) {
        return;
    }
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"page":page,@"name":name,@"userid":userid};
    CommandModel *command=[[CommandModel alloc]init];
    
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSArray * list = [dicJson objectForKey:@"list"];
            
            if(errcode==0)//返回操作成功
            {
                block([UserInfoModel mj_objectArrayWithKeyValuesArray:list],SucceedCode);
                
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];

}
///获得我的黑名单用户（/userblacklist/getuserblacklist）

+(void)getUserBlackList:(UpDateViewsBlock)block withPage: (NSString *)page andName:(NSString *)name
{
    
    NSString * url=[NSString stringWithFormat:@"%@/userblacklist/getuserblacklist",SERVER_URL];
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"page":page,@"name":name};
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSArray * list = [dicJson objectForKey:@"list"];

            if(errcode==0)//返回操作成功
            {
                block([UserInfoModel mj_objectArrayWithKeyValuesArray:list],SucceedCode);
                
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];

}

///添加黑名单用户（/userblacklist/adduserblacklist）
+(void)addUserBlackList:(UpDateViewsBlock)block withUserID: (NSString *)userid andType:(NSString *)type
{
    NSString * url=[NSString stringWithFormat:@"%@/userblacklist/adduserblacklist",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"userid":userid,@"type":type};
    CommandModel *command=[[CommandModel alloc]init];
    
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {

        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                block(@"成功添加黑名单",SucceedCode);
                
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];

}
///删除黑名单用户（/userblacklist/removeuserblacklist）
+(void)removeUserBlackList:(UpDateViewsBlock)block withUserID: (NSString *)userid andType:(NSString *)type
{
    NSString * url=[NSString stringWithFormat:@"%@/userblacklist/removeuserblacklist",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"userid":userid,@"type":type};
    CommandModel *command=[[CommandModel alloc]init];
    
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
               
                block(@"成功移除黑名单！",SucceedCode);
                
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];

}

//查找本人关注粉丝和黑名单个数（/user/getrelatedme）

+(void)getAttentionFansBlack:(UpDateViewsBlock)block{
    
    //NSString *test = @"http://192.168.10.75:9080/times";
    
    NSString * url = [NSString stringWithFormat:@"%@/topic/getrelatedme",SERVER_URL];//SERVER_URL
    
    AppDelegate *appDelegate = GetAppDelegates;

    NSDictionary * param = @{@"token":appDelegate.userData.token};
    NSLog(@"搜索条件参数－－－－%@",param);
    
    CommandModel *command=[[CommandModel alloc]init];
    
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            
            NSLog(@"%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSDictionary * list =[dicJson objectForKey:@"map"];
            
            if(errcode==0)//返回操作成功
            {
                block(list,SucceedCode);
                
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];
}

///获得最近在线的用户（/user/getcomlastuser）
+(void)getComLastUser:(UpDateViewsBlock)block withSex: (NSString *)sex andPage:(NSString *)page
{
    NSString * url=[NSString stringWithFormat:@"%@/user/getcomlastuser",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"sex":sex,@"page":page};
    NSLog(@"搜索条件参数－－－－%@",param);
    
    CommandModel *command=[[CommandModel alloc]init];
    
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSArray * list =[dicJson objectForKey:@"list"];
            NSLog(@"dicJson===%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                block([RecentlyFriendModel mj_objectArrayWithKeyValuesArray:list],SucceedCode);
                
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];
    

}
///发送聊天消息（/chat/sendmsg）
+(void)sendChatMsg:(UpDateViewsBlock)block withUserID:(NSString *)userid andMsgType:(NSString *)msgtype andContent:(NSString *)content andResourcesID:(NSString *)resourcesid
{
    NSString * url=[NSString stringWithFormat:@"%@/chat/sendmsg",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"userid":userid,@"msgtype":msgtype,@"content":content,@"resourcesid":resourcesid};
    
    CommandModel *command=[[CommandModel alloc]init];
    
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSString * systime =[dicJson objectForKey:@"systime"];
            if(errcode==0)//返回操作成功
            {
               
                block(systime,SucceedCode);
                
            }else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];
    
}

/**
 添加或取消关注
 
 @param userid 关注用户的userID
 @param block 回调
 @param type 0增加关注 1 取消关注
 */

+(void)addUserFollow:(NSString *)userid withBlock:(UpDateViewsBlock)block withType:(NSString *)type
{
    
    NSString * url=[NSString stringWithFormat:@"%@/userfollow/addfollow",SERVER_URL_New];
    
    if ([XYString isBlankString:userid]) {
        return;
    }
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1",@"userid":userid,@"type":type};
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            block(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }
        else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSDictionary * map = [dicJson objectForKey:@"map"];
            
            NSLog(@"------------添加关注返回%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                
                block(map,SucceedCode);
                
            }
            else//返回操作失败
            {
                block(errmsg,FailureCode);
            }
        }
        else if(resultCode==FailureCode)//返回数据失败
        {
            block(data,resultCode);
        }
    }];
}
@end
