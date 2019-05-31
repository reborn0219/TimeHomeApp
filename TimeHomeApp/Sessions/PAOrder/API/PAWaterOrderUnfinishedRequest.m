//
//  PAWaterOrderUnfinishedRequest.m
//  TimeHomeApp
//
//  Created by ning on 2018/8/14.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAWaterOrderUnfinishedRequest.h"

@implementation PAWaterOrderUnfinishedRequest{
    NSString *_qrCodeNum;
}

- (instancetype)initWithQrCodeNum:(NSString *)qrCodeNum{
    if (self = [super init]) {
        _qrCodeNum = qrCodeNum;
    }
    return self;
}

- (NSString *)requestUrl{
    return @"/api_entrance";
}

- (id)requestArgument{
    AppDelegate * appdelgate = GetAppDelegates;
    NSDictionary * paramDict = @{@"qrCodeNum":_qrCodeNum,};
    return  [self paramDicWithMethodName:@"orderinfo.appOrderInfoByQrCode"
                                   token:appdelgate.userData.token?:@""
                            originParams:paramDict];
}
@end
