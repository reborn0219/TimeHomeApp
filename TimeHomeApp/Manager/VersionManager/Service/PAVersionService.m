//
//  PAVersionService.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/5/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAVersionService.h"
#import "PAVersionRequest.h"
@implementation PAVersionService

/**
 获取服务器新版本提示信息
 */
- (void)versionInfoCheck{
    
    PAVersionRequest * req = [[PAVersionRequest alloc]init];
    [req startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSData *jsonData = [request.responseString dataUsingEncoding : NSUTF8StringEncoding];
        NSDictionary *tmpResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        NSLog(@"%@",tmpResponseDic);
        
        self.versionModel = [[PAVersionModel alloc]init];
        self.versionModel.isForce = NO;
        self.versionModel.version = kCurrentVersion;
        self.versionModel.information = @[@"这次我们优化了XXX问题",@"并且杀了一个程序员祭天"];
        self.versionModel.timeInterval = @"3";
        self.versionModel.validIP = [[PAVersionvalidIPModel alloc]init];
        self.versionModel.validIP.fromIP = @"100.0.0.0";
        self.versionModel.validIP.toIP = @"255.255.255.255";
        self.successBlock(self);
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.error);
        
    }];
    
    /*
     [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
     NSLog(@"%@",responseModel.data);
     } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
     
     NSLog(@"%@",error);
     }];
     */
}
@end
