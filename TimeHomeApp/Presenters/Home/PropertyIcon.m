
//
//  PropertyIcon.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/7/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PropertyIcon.h"

@implementation PropertyIcon


/**
 *  获得首页物业图标
 */
+ (void)getPropertyIconUpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    
    NSString * url=[NSString stringWithFormat:@"%@/userappquicktab/getindexquicktablist",SERVER_URL];
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
                updataViewBlock(dicJson,SucceedCode);
                
            }else//返回操作失败
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



/**
 *  保存首页物业图标
 */
+ (void)savePropertyIconWithKeys:(NSString *)keys UpDataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    
    
    NSString * url=[NSString stringWithFormat:@"%@/userappquicktab/saveindexquicktab",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"keys":keys};
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
