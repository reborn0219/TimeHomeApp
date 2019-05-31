//
//  CommunityManagerPresenters.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/30.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CommunityManagerPresenters.h"
#import "CityCommunityModel.h"
#import "UserUnitKeyModel.h"
#import "RegularUtils.h"
#import "PushMsgModel.h"
#import "PAChangeCommunityRequest.h"
#import "PAH5UrlManager.h"

@implementation CommunityManagerPresenters

/**
 *  获得我的小区
 */
+ (void)getUserCommunityUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/commcertification/getusercommunity",SERVER_URL];
    
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
            NSLog(@"%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(dicJson,SucceedCode);
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

/**
 *  提交认证审核
 */
+ (void)addCommcertificationName:(NSString *)name buiding:(NSString *)buiding number:(NSString *)number UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    if ([XYString isBlankString:name]) {
        updataViewBlock(@"姓名不能为空",FailureCode);
        return;
    }
    if (name.length < 2) {
        updataViewBlock(@"姓名应为2-4字",FailureCode);
        return;
    }
    if ([XYString isBlankString:buiding]) {
        updataViewBlock(@"楼栋不能为空",FailureCode);
        return;
    }
    if ([XYString isBlankString:number]) {
        updataViewBlock(@"房号不能为空",FailureCode);
        return;
    }
    
    NSString * url=[NSString stringWithFormat:@"%@/commcertification/addcommcertification",SERVER_URL];
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"name":name,@"buiding":buiding,@"number":number};
    
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
 *  切换社区
 */
+ (void)changeCommunityCommunityid:(NSString *)communityid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    AppDelegate *appDelegate = GetAppDelegates;
    PAChangeCommunityRequest * req = [[PAChangeCommunityRequest alloc]initWithCommunityID:communityid Token:appDelegate.userData.token];
    
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        
        NSLog(@"返回数据：%@",responseModel.data);
        //保存用户信息
        if (responseModel.data) {
            
            
            PACommunityInfo *user = [PACommunityInfo yy_modelWithJSON:[responseModel.data objectForKey:@"communityInfo"]];
            
            NSArray *powerArr = [responseModel.data objectForKey:@"powerConfig"];
            
            
            if (user) {
                
                [[PAUserManager sharedPAUserManager]updataCommunityInfo:user powerArr:powerArr];
                [appDelegate saveContext];
                [appDelegate setMsgSaveName];
                //今天插件的Token
                NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:WIDGET_GROUP_ID];
                [shared setObject:appDelegate.userData.token forKey:@"widget"];
                [shared synchronize];
                [USER_DEFAULT setObject:@"yes" forKey:NOTICE_REFRESH_EDIT_DATA];
                [USER_DEFAULT synchronize];
                [UserDefaultsStorage saveData:@YES forKey:kHomeUIInfoNeedRefresh];
                [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:@"isChangeSheQu"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                updataViewBlock(@"",SucceedCode);

            }
            
        }else{
            
            updataViewBlock(@"切换社区失败！",FailureCode);

        }
        
        
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        
        NSLog(@"权限获取失败");
        updataViewBlock(@"切换社区失败！",FailureCode);
    }];
   

}

/**
 *  按照名称搜索社区
 */
+ (void)getSearchCommunityName:(NSString *)name cityid:(NSString *)cityid page:(NSString *)page UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/community/getsearchcommunity",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token?:@"",@"name":name,@"cityid":cityid,@"page":page};
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
            if(errcode==0)//返回操作成功
            {
                NSArray* arrJson=[dicJson objectForKey:@"list"];
                NSArray *cityListData=[CityCommunityModel mj_objectArrayWithKeyValuesArray:arrJson];
                updataViewBlock(cityListData,SucceedCode);
                
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
 *  获得附近社区
 */
+ (void)getNearCommunityName:(NSString *)name cityid:(NSString *)cityid page:(NSString *)page positionx:(NSString *)positionx positiony:(NSString *)positiony UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/community/getnearcommunity",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"name":name,@"cityid":cityid,@"page":page,@"positionx":positionx,@"positiony":positiony};
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
            NSLog(@"json=========%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                NSArray* arrJson=[dicJson objectForKey:@"list"];
                NSArray *ListData=[CityCommunityModel mj_objectArrayWithKeyValuesArray:arrJson];
                updataViewBlock(ListData,SucceedCode);

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
 *  获得社区所有的物业列表
 */
+ (void)getCompropertyUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/property/getcomproperty",SERVER_URL];
    
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                NSArray * arrayJson=[dicJson objectForKey:@"list"];
                updataViewBlock(arrayJson,SucceedCode);
                
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
 *  获得社区物业联系电话
 */
+ (void)getPropertyPhoneUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/propertyphone/getpropertyphone",SERVER_URL];
    
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"dicJson===%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                NSArray * arrayJson=[dicJson objectForKey:@"list"];
                updataViewBlock(arrayJson,SucceedCode);
                
            }
            else//返回操作失败
            {
                NSDictionary * dic=@{@"errcode":[dicJson objectForKey:@"errcode"],@"errmsg":errmsg};
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
 *  获得社区公告信息
 */
+ (void)getTopPropertyNoticeUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/cmmnotice/gettoppropertynotice",SERVER_URL];
    
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            
            
            if(errcode==0)//返回操作成功
            {
                NSArray* arrJson=[dicJson objectForKey:@"list"];
               
                
                
                NSString * noreadcount = [dicJson objectForKey:@"noreadcount"];
                
                if(noreadcount.integerValue <=0)
                {
                    noreadcount = @"0";
                }
                PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDelegate.CommunityNotification];
                if (pushMsg == nil) {
                    pushMsg = [[PushMsgModel alloc] init];
                    pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
                }
                pushMsg.countMsg = [NSNumber numberWithInteger:noreadcount.integerValue];
                [UserDefaultsStorage saveData:pushMsg forKey:appDelegate.CommunityNotification];
                updataViewBlock(arrJson,SucceedCode);
                
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
 *  分页获得物业公告
 */
+ (void)getPropertyNoticePage:(NSString *)page UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/cmmnotice/getpropertynotice",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"page":page};
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
            /**
             “list”:[{
             “id”:”1“
             ,”isread”:1
             ,”title”:”我是标题”
             ,”content”:”我是内容”
             ,”systime”:”2015-10-10 10:59”
             ,”gotourl”:”http://...”
             }]
             */
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"=====%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                NSArray * array=[dicJson objectForKey:@"list"];
                updataViewBlock(array,SucceedCode);
                
            }
            else//返回操作失败
            {
                NSDictionary * dic=@{@"errcode":[dicJson objectForKey:@"errcode"],@"errmsg":errmsg};
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
 *  设置公告已读
 */
+ (void)readNoticeID:(NSString *)theID UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/cmmnotice/readnotice",SERVER_URL];
    
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
 *  获得个人拥有住宅信息
 */
+ (void)getUserResidenceUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/residence/getuserresidence",SERVER_URL];
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"dicJson===%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                NSArray * arrayJson=[dicJson objectForKey:@"list"];
                
                updataViewBlock(arrayJson,SucceedCode);
                
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
 *  获得业主授权房产信息
 */
+ (void)getOwnerResidenceUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/residence/getownerresidence",SERVER_URL];
    
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                NSLog(@"%@",dicJson);
                NSMutableArray *array = [OwnerResidence mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
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
        else if(resultCode==TOKENInvalid)//登录失效
        {
            updataViewBlock(data,resultCode);
        }
    }];
}

/**
 *  保存住宅授权信息
 */
+ (void)saveResidencePowerPowertype:(NSString *)powertype residenceid:(NSString *)residenceid phone:(NSString *)phone name:(NSString *)name rentbegindate:(NSString *)rentbegindate rentenddate:(NSString *)rentenddate UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
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
    
    NSString * url=[NSString stringWithFormat:@"%@/residence/saveresidencepower",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{};
    if ([powertype isEqualToString:@"0"]) {
        //共享
        param = @{@"token":appDelegate.userData.token,@"powertype":powertype,@"residenceid":residenceid,@"phone":phone,@"name":name,@"rentbegindate":@"",@"rentenddate":@""};
    }
    if ([powertype isEqualToString:@"1"]) {
        //租用
        if ([XYString isBlankString:rentbegindate]) {
            updataViewBlock(@"请选择开始日期",FailureCode);
            return;
        }
        if ([XYString isBlankString:rentenddate]) {
            updataViewBlock(@"请选择结束日期",FailureCode);
            return;
        }
        
        param = @{@"token":appDelegate.userData.token,@"powertype":powertype,@"residenceid":residenceid,@"phone":phone,@"name":name,@"rentbegindate":rentbegindate,@"rentenddate":rentenddate};
    }
    

    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        NSLog(@"======%@",data);
        
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
            NSLog(@"dicJson==%@",dicJson);
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
 *  移除住宅授权信息
 */
+ (void)deleteResidencePowerPowerid:(NSString *)powerid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    if ([XYString isBlankString:powerid]) {
        updataViewBlock(@"数据异常，请联系物业",FailureCode);
        return;
    }
    
    NSString * url=[NSString stringWithFormat:@"%@/residence/deleteresidencepower",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"powerid":powerid};
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
            //“errcode”:0
            //,”errmsg”:””
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
            
        }else if(resultCode==FailureCode)//返回数据失败
        {
            updataViewBlock(data,resultCode);
        }
        
    }];
    
}

/**
 *  续租住宅授权信息
 */
+ (void)renewResidencePowerID:(NSString *)theid begindate:(NSString *)begindate enddate:(NSString *)enddate UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    if ([XYString isBlankString:begindate]) {
        updataViewBlock(@"请选择开始日期",FailureCode);
        return;
    }
    if ([XYString isBlankString:begindate]) {
        updataViewBlock(@"请选择结束日期",FailureCode);
        return;
    }
    
    NSString * url=[NSString stringWithFormat:@"%@/residence/renewresidencepower",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"id":theid,@"begindate":begindate,@"enddate":enddate};
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
 *  获取电梯定位之后的周围的人的权限
 */
+ (void)getLiftBlueToothWithAreaID:(NSString *)areaID
                   UpDataViewBlock:(UpDateViewsBlock)updataViewBlock{
    
    NSString * url=[NSString stringWithFormat:@"%@/bluetest/sendbluelg2",SERVER_URL];
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary *param=@{@"blueno":areaID,@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
    
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
            NSLog(@"json=dx 32==%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                NSArray* arrJson=[dicJson objectForKey:@"list"];
                
                NSArray *cityListData=[UserUnitKeyModel mj_objectArrayWithKeyValuesArray:arrJson];
                
                NSDictionary *dic = @{@"cityListData":cityListData,@"pid":[dicJson objectForKey:@"pid"]};
                
                updataViewBlock(dic,SucceedCode);
                
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
 *  获取电梯定位连接操作成功返回
 */
+ (void)getLiftBlueToothWithPid:(NSString *)PID
                UpDataViewBlock:(UpDateViewsBlock)updataViewBlock{
    
    NSString * url=[NSString stringWithFormat:@"%@/bluetest/sendblueok",SERVER_URL];
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary *param=@{@"pid":PID,@"token":appDelegate.userData.token,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
    
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
            NSLog(@"json=dx 32==%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(@"成功",SucceedCode);
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
 *  获得蓝牙权限信息
 */

+(void)getUserBluetoothUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/bluetooth/getuserbluetooth",SERVER_URL];
    AppDelegate *appDelegate = GetAppDelegates;
    
    if([XYString isBlankString:appDelegate.userData.token])return;
    
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"json=dx 32==%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                NSArray* arrJson=[dicJson objectForKey:@"list"];
                NSArray *cityListData=[UserUnitKeyModel mj_objectArrayWithKeyValuesArray:arrJson];
                updataViewBlock(cityListData,SucceedCode);
                
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
 *  验证选中车牌是否可以驶入
 */
+(void)getCardCanIn:(NSString *)carid
    upDataViewBlock:(UpDateViewsBlock)updataViewBlock{
    
    NSString * url=[NSString stringWithFormat:@"%@/car/checkcarin",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"carid":carid};
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
            NSLog(@"json=dx 32==%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(@"成功",SucceedCode);
                
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
 *  获取关口的蓝牙权限
 */
+ (void)getGatBlueToothUpDataViewBlock:(UpDateViewsBlock)updataViewBlock{
    
    NSString * url=[NSString stringWithFormat:@"%@/bluetooth/getgatebluetooth",SERVER_URL];
    
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
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            NSLog(@"json=dx 32==%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                NSArray* arrJson=[dicJson objectForKey:@"list"];
                NSArray *cityListData=[UserUnitKeyModel mj_objectArrayWithKeyValuesArray:arrJson];
                updataViewBlock(cityListData,SucceedCode);
                
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
 *  根据社区id获得社区物业联系电话
 */
+ (void)getPropertyPhoneWithCommunityID:(NSString *)communityID UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/bike/getpropertyphone",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    if ([XYString isBlankString:communityID]) {
        communityID = @"0";
    }
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"communityid":communityID};
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
            if(errcode==0)//返回操作成功
            {
                NSArray * arrayJson=[dicJson objectForKey:@"list"];
                updataViewBlock(arrayJson,SucceedCode);
                
            }
            else//返回操作失败
            {
                NSDictionary * dic=@{@"errcode":[dicJson objectForKey:@"errcode"],@"errmsg":errmsg};
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
 添加摇一摇通行记录
 
 @param bluename 蓝牙名称
 @param type 摇一摇类型
 @param updataViewBlock 回调
 */
+(void)addTrafficlog:(NSString *)bluename withType:(NSString *)type Block:(UpDateViewsBlock)updataViewBlock
{
    if ([XYString isBlankString:bluename]) {
        return;
    }
    NSString * url=[NSString stringWithFormat:@"%@/usertrafficlog/addtrafficlog",SERVER_URL];
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"bluename":bluename,@"type":type};
    
    
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
            if(errcode==0)//返回操作成功
            {
                updataViewBlock(@"提交成功",SucceedCode);
                
            }
            else//返回操作失败
            {
                NSDictionary * dic=@{@"errcode":[dicJson objectForKey:@"errcode"],@"errmsg":errmsg};
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
 *  获得常出入社区
 */
+ (void)getUserCommonCommunityWithCityid:(NSString *)cityid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/community/getusercommoncomm",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"cityid":cityid,@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
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
            NSLog(@"json=========%@",dicJson);
            if(errcode==0)//返回操作成功
            {
                NSArray* arrJson = [dicJson objectForKey:@"list"];
                NSArray *ListData = [CityCommunityModel mj_objectArrayWithKeyValuesArray:arrJson];
                updataViewBlock(ListData,SucceedCode);
                
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
