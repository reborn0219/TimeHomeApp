//
//  YYNoticeSetPresent.m
//  TimeHomeApp
//
//  Created by 世博 on 16/7/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "YYNoticeSetPresent.h"

@implementation YYNoticeSetPresent

/**
 *  获得推送消息的设置
 */
+ (void)getAppMsgsetUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/appmsgset/getappmsgset",SERVER_URL];
    
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
            NSLog(@"%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
                AppNoticeSet *appNoticeSet = [AppNoticeSet mj_objectWithKeyValues:[dicJson objectForKey:@"map"]];
                
                updataViewBlock(appNoticeSet,SucceedCode);
                
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
 *  保存推送消息的设置
 */
+ (void)saveAppMsgsetWithAppNoticeSet:(AppNoticeSet *)appNoticeSet UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"%@/appmsgset/saveappmsgset",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"chatreceive":appNoticeSet.chatreceive,@"chatdetails":appNoticeSet.chatdetails,@"voiceopen":appNoticeSet.voiceopen,@"shockopen":appNoticeSet.shockopen,@"nightopen":appNoticeSet.nightopen,@"voicekey":@"0",@"carremind":appNoticeSet.carremind};
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
            NSLog(@"保存推送消息的设置====%@",dicJson);
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(errcode==0)//返回操作成功
            {
//                AppNoticeSet *appNoticeSet = [AppNoticeSet mj_objectWithKeyValues:[dicJson objectForKey:@"map"]];
                
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
