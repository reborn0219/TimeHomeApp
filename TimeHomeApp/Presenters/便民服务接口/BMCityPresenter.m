//
//  BMCityPresenter.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BMCityPresenter.h"

@implementation BMCityPresenter

///获得城市区域（/sysarea/getcitycounty）
+(void)getCityCounty:(UpDateViewsBlock)block withCityID:(NSString *)cityid
{
    NSString * url=[NSString stringWithFormat:@"%@/sysarea/getcitycounty",SERVER_URL];
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param = @{@"token":appDelegate.userData.token,@"cityid":cityid};
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
            NSLog(@"json===%@",dicJson);
            if(errcode==0)//返回操作成功
            {

//                NSMutableArray *array = [LifeIDNameModel mj_objectArrayWithKeyValuesArray:[dicJson objectForKey:@"list"]];
//                block(array,SucceedCode);
                NSArray *userData =[dicJson objectForKey:@"list"];
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
@end
