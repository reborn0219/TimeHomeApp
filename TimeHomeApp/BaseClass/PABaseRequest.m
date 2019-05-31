//
//  PABaseRequest.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/3/31.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequest.h"
#import "Reachability.h"
#import "MsgAlertView.h"

@implementation PABaseRequest

-(void)requestStart{
    
    /*无网络情况直接提示检查网络*/
    if (![Reachability isNetAvailableStatus]) {
        MsgAlertView * msgV = [MsgAlertView sharedMsgAlertView];
        [msgV showMsgViewForMsg:@"您的网络好像不太给力，请检查网络!" btnOk:@"确定" btnCancel:@"" blok:nil];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSData *jsonData = [request.responseString dataUsingEncoding : NSUTF8StringEncoding];
        NSDictionary *tmpResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        
        PABaseResponseModel *responseModel = [PABaseResponseModel yy_modelWithDictionary:tmpResponseDic];
        
        responseModel.data = [tmpResponseDic valueForKey:@"data"];
        
        if (responseModel.code == PAResponseCodeTypeSuccess){//成功
            
            if(weakSelf.successBlock){
                weakSelf.successBlock(responseModel, weakSelf);
            }
            
        } else if (responseModel.code == PAResponseCodeTypeTokenInvalid) {//登陆失效
            
            if(weakSelf.failedBlock){
                
                [[NSNotificationCenter defaultCenter]postNotificationName:PAUserTokenInvalidNotification object:nil];                
                
                weakSelf.failedBlock(nil, weakSelf);
            }
            
        }else if (responseModel.code == PAResponseCodeTypeServerInnerError) {//服务器内部错误
            
            if(weakSelf.failedBlock){
                
                NSError *error = [NSError errorWithDomain:request.requestUrl
                                                     code:responseModel.code
                                                 userInfo:@{NSLocalizedDescriptionKey:responseModel.msg}];
                weakSelf.failedBlock(error, weakSelf);
            }
        }else {//其他错误
            
            if(weakSelf.failedBlock){
                
                NSError *error = [NSError errorWithDomain:request.requestUrl
                                                     code:responseModel.code
                                                 userInfo:@{NSLocalizedDescriptionKey:responseModel.msg?:@""}];
                weakSelf.failedBlock(error, weakSelf);
            }
        }
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        if(weakSelf.failedBlock){
            weakSelf.failedBlock(request.error, weakSelf);
        }
    }];
}

- (void)requestStartBlockWithSuccess:(nullable requestSuccessBlock)success
                             failure:(nullable requestFailedBlock)failure{
    
    self.successBlock = success;
    self.failedBlock = failure;
    
    [self requestStart];
}

- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeHTTP;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

#pragma mark -- 对请求参数封装
-(NSMutableDictionary*)paramDicWithMethodName:(NSString*)methodName token:(NSString *)token originParams:(NSDictionary *)originParamsDic{
    
    if (!methodName||!originParamsDic||!token) {
        return nil;
    }
    
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [paramDic setObject:methodName forKey:@"apiCode"];
    
    [paramDic setObject:token forKey:@"token"];
    
    [paramDic setObject:@"APP_H5" forKey:@"appId"];
    
    [paramDic setObject:[XYString NSDateToString:[NSDate date] withFormat:@"YYYY-MM-dd HH:mm:ss"]forKey:@"timeStamp"];
    
    //业务相关参数
    [paramDic setObject:[originParamsDic yy_modelToJSONString] forKey:@"params"];
    
    /*MD5----start*/
    NSMutableString * parameStr = [[NSMutableString alloc]initWithCapacity:0];
    
    NSArray * allKeysArray = [[paramDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    [parameStr appendString:@"APP_H5_2017"];
    for (NSString * keyStr in allKeysArray) {
        NSString * valueStr = [paramDic objectForKey:keyStr];
        [parameStr appendString:keyStr];
        [parameStr appendString:valueStr];
    }
    [parameStr appendString:@"APP_H5_2017"];
    
    NSString * sign = [parameStr md5String];
    
    [paramDic setObject:sign forKey:@"sign"];
    /*MD5----end*/
    
    return paramDic;
}

-(NSMutableDictionary*)paramDicWithMethodName:(NSString*)methodName
                                        appid:(NSString *)appid
                                      encrypt:(NSString *)encrypt
                                        token:(NSString *)token
                                 originParams:(NSDictionary *)originParamsDic{
    if (!methodName||!originParamsDic||!token) {
        return nil;
    }
    
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [paramDic setObject:methodName forKey:@"apiCode"];
    
    [paramDic setObject:token forKey:@"token"];
    
    [paramDic setObject:appid forKey:@"appId"];
    
    [paramDic setObject:[XYString NSDateToString:[NSDate date] withFormat:@"YYYY-MM-dd HH:mm:ss"]forKey:@"timeStamp"];
    
    //业务相关参数
    [paramDic setObject:[originParamsDic yy_modelToJSONString] forKey:@"params"];
    
    /*MD5----start*/
    NSMutableString * parameStr = [[NSMutableString alloc]initWithCapacity:0];
    
    NSArray * allKeysArray = [[paramDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    [parameStr appendString:encrypt];
    for (NSString * keyStr in allKeysArray) {
        NSString * valueStr = [paramDic objectForKey:keyStr];
        [parameStr appendString:keyStr];
        [parameStr appendString:valueStr];
    }
    [parameStr appendString:encrypt];
    
    NSString * sign = [parameStr md5String];
    
    [paramDic setObject:sign forKey:@"sign"];
    /*MD5----end*/
    
    return paramDic;

    
}
@end
