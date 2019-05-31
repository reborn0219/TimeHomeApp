//
//  PABaseRequest.h
//  TimeHomeApp
//
//  Created by WangKeke on 2018/3/31.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "YTKRequest.h"
#import "PABaseResponseModel.h"


@interface PABaseRequest : YTKRequest

@property (nonatomic,copy) requestSuccessBlock _Nullable successBlock;
@property (nonatomic,copy) requestFailedBlock _Nullable failedBlock;

- (void)requestStart;

- (void)requestStartBlockWithSuccess:(nullable requestSuccessBlock)success
                             failure:(nullable requestFailedBlock)failure;

-(NSMutableDictionary*)paramDicWithMethodName:(NSString*)methodName token:(NSString *)token originParams:(NSDictionary *)originParamsDic;

-(NSMutableDictionary*)paramDicWithMethodName:(NSString*)methodName
                                        appid:(NSString *)appid
                                      encrypt:(NSString *)encrypt
                                        token:(NSString *)token
                                 originParams:(NSDictionary *)originParamsDic;

@end
