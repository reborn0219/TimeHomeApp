//
//  PARedBagPresenter.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/2/6.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PARedBagPresenter.h"
#import "EncryptUtils.h"
#import "PARedBagModel.h"
#import "PARedBagDetailModel.h"

@implementation PARedBagPresenter

/**
 获取广告（红包）
 */
+ (void)getRedEnvelopeWithType:(AD_RECEIVE_TYPE)type andCommunityid:(NSString *)communityid updataViewBlock:(UpDateViewsBlock)updataViewBlock {
    
    //CommandModel
    CommandModel *command=[[CommandModel alloc]init];
    
    //API新协议
    command.commandUrl=kNewRedPaket_URL;
    
    AppDelegate *appDelegate = GetAppDelegates;
    
    NSDictionary * param=@{@"token":[XYString IsNotNull:appDelegate.userData.token],
                           @"type":[NSString stringWithFormat:@"%lu",type],
                           @"communityid":[XYString IsNotNull:communityid]};
    
    NSDictionary *apiParam = [self paramDicWithMethodName:@"api.advert.getredenvelope" params:param];
    command.jsonStr = [apiParam mj_JSONString];
    
    //DataController
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"PANetAesJsonDataCommond" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode){//无网络处理
        
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
            
        }else if(resultCode==FailureCode){//返回数据失败
        
            updataViewBlock(data,resultCode);
            
        }else if(resultCode==SucceedCode){//成功返回数据
        
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
       
            NSInteger errcode=[[dicJson objectForKey:@"code"]intValue];
            NSString * errmsg = [XYString IsNotNull:[dicJson objectForKey:@"msg"]];
            NSDictionary *data = [dicJson objectForKey:@"data"];
            
            NSLog(@"json=%@",dicJson);
            
            PARedBagModel *redBag = [PARedBagModel mj_objectWithKeyValues:data];
            
            if(errcode==0){//返回操作成功
                updataViewBlock(redBag,SucceedCode);
            }else{//返回操作失败
                updataViewBlock(errmsg,FailureCode);
            }
        }
    }];
}

/**
 抢(领取)红包
 */
+ (void)receiveRedEnvelopeWithOrderId:(NSString*)orderId Userticketid:(NSString *)userticketid updataViewBlock:(UpDateViewsBlock)updataViewBlock{
    //CommandModel
    CommandModel *command = [[CommandModel alloc]init];
    
    //API新协议
    command.commandUrl = kNewRedPaket_URL;
    
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param=@{@"token":[XYString IsNotNull:appDelegate.userData.token],
                           @"userticketid":[XYString IsNotNull:userticketid],
                           @"orderid":[XYString IsNotNull:orderId]
                           };
    
    NSDictionary *apiParam = [self paramDicWithMethodName:@"api.advert.reciveredenvelope" params:param];
    command.jsonStr = [apiParam mj_JSONString];    
    
    //DataController
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"PANetAesJsonDataCommond" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode){//无网络处理
            
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
            
        }else if(resultCode==FailureCode){//返回数据失败
            
            updataViewBlock(data,resultCode);
            
        }else if(resultCode==SucceedCode){//成功返回数据
            
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            NSLog(@"json=%@",dicJson);
            
            NSInteger errcode = [[dicJson objectForKey:@"code"]intValue];
            NSString * errmsg = [XYString IsNotNull:[dicJson objectForKey:@"msg"]];
           
            NSDictionary *data = [dicJson objectForKey:@"data"];
            
            NSArray *redBagList = [PARedBagDetailModel mj_objectArrayWithKeyValuesArray:data];
            
            if(errcode==0){//返回操作成功
                updataViewBlock(redBagList,SucceedCode);
            }else{//返回操作失败
                updataViewBlock(errmsg,FailureCode);
            }
        }
    }];
}

/**
 查看红包详情
 */
+ (void)getRedEnvlopeinfoWithUserticketid:(NSString *)userticketid type:(AD_TYPE)type updataViewBlock:(UpDateViewsBlock)updataViewBlock{
    //CommandModel
    CommandModel *command=[[CommandModel alloc]init];
    
    //API新协议
    command.commandUrl=kNewRedPaket_URL;
    
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param=@{@"token":[XYString IsNotNull:appDelegate.userData.token],
                           @"userticketid":[XYString IsNotNull:userticketid]};
    
    NSDictionary *apiParam = [self paramDicWithMethodName:@"api.advert.getredenvelopeinfo" params:param];
    command.jsonStr = [apiParam mj_JSONString];
    
    //DataController
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"PANetAesJsonDataCommond" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode){//无网络处理
            
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
            
        }else if(resultCode==FailureCode){//返回数据失败
            
            updataViewBlock(data,resultCode);
            
        }else if(resultCode==SucceedCode){//成功返回数据
            
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"code"]intValue];
            NSString * errmsg = [XYString IsNotNull:[dicJson objectForKey:@"msg"]];
            NSArray *data = [dicJson objectForKey:@"data"];
            
            NSArray *redBagArray = [PARedBagDetailModel mj_objectArrayWithKeyValuesArray:data];
            
            NSLog(@"json=%@",dicJson);
            
            if(errcode==0){//返回操作成功
                updataViewBlock(redBagArray,SucceedCode);
            }else{//返回操作失败
                updataViewBlock(errmsg,FailureCode);
            }
        }
    }];
}

/**
 查看红包广告
 */
+ (void)showAdInfoWithUserticketid:(NSString *)userticketid updataViewBlock:(UpDateViewsBlock)updataViewBlock{
    //CommandModel
    CommandModel *command=[[CommandModel alloc]init];
    
    //API新协议
    command.commandUrl=kNewRedPaket_URL;
    
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param=@{@"token":[XYString IsNotNull:appDelegate.userData.token],
                           @"userticketid":[XYString IsNotNull:userticketid]};
    
    NSDictionary *apiParam = [self paramDicWithMethodName:@"api.advert.clickred" params:param];
    command.jsonStr = [apiParam mj_JSONString];
    
    //DataController
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"PANetAesJsonDataCommond" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode){//无网络处理
            
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
            
        }else if(resultCode==FailureCode){//返回数据失败
            
            updataViewBlock(data,resultCode);
            
        }else if(resultCode==SucceedCode){//成功返回数据
            
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"code"]intValue];
            NSString * errmsg = [XYString IsNotNull:[dicJson objectForKey:@"msg"]];
            
            NSLog(@"json=%@",dicJson);
            
            if(errcode==0){//返回操作成功
                updataViewBlock(dicJson,SucceedCode);
            }else{//返回操作失败
                updataViewBlock(errmsg,FailureCode);
            }
        }
    }];
}

/**
 查看我的红包和优惠券
 */
+ (void)getRedEnvelopeListWithType:(AD_TYPE)type UpdataViewBlock:(UpDateViewsBlock)updataViewBlock{
    //CommandModel
    CommandModel *command=[[CommandModel alloc]init];
    
    //API新协议
    command.commandUrl=kNewRedPaket_URL;
    
    AppDelegate *appDelegate = GetAppDelegates;
    NSDictionary * param=@{@"token":[XYString IsNotNull:appDelegate.userData.token],
                           @"type":[NSString stringWithFormat:@"%lu",type]
                           };
    
    NSDictionary *apiParam = [self paramDicWithMethodName:@"api.advert.getredenvelopelist" params:param];
    command.jsonStr = [apiParam mj_JSONString];
    
    //DataController
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"PANetAesJsonDataCommond" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode){//无网络处理
            
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
            
        }else if(resultCode==FailureCode){//返回数据失败
            
            updataViewBlock(data,resultCode);
            
        }else if(resultCode==SucceedCode){//成功返回数据
            
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            //“errcode”:0
            //,”errmsg”:””
            NSInteger errcode=[[dicJson objectForKey:@"code"]intValue];
            NSString * errmsg = [XYString IsNotNull:[dicJson objectForKey:@"msg"]];
            NSArray *data = [dicJson objectForKey:@"data"];
            
            NSArray *redBagArray = [PARedBagDetailModel mj_objectArrayWithKeyValuesArray:data];
            
            NSLog(@"json=%@",dicJson);
            
            if(errcode==0){//返回操作成功
                updataViewBlock(redBagArray,SucceedCode);
            }else{//返回操作失败
                updataViewBlock(errmsg,FailureCode);
            }
        }
    }];
}

#pragma mark - helper

/*参数增加校验*/
+(NSMutableDictionary*)paramDicWithMethodName:(NSString*)methodName params:(NSDictionary *)paramdic{
    
    if (!methodName||!paramdic) {
        return nil;
    }
    
    AppDelegate * delegate = GetAppDelegates
    
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [paramDic setObject:methodName forKey:@"apiCode"];
    
    [paramDic setObject:delegate.userData.token forKey:@"token"];//另一套用户体系的token
    
    [paramDic setObject:@"APP_H5" forKey:@"appId"];
    
    [paramDic setObject:[XYString NSDateToString:[NSDate date] withFormat:@"YYYY-MM-dd HH:mm:ss"]forKey:@"timeStamp"];
    
    [paramDic setObject:[paramdic mj_JSONString] forKey:@"params"];
    
    NSString * sign = [EncryptUtils processingParameters:paramDic];
    
    [paramDic setObject:sign forKey:@"sign"];
    
    return paramDic;
}

@end
