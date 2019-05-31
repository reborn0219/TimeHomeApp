//
//  PABaseRequestService.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/19.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PABaseRequestService;
typedef void(^ServiceSuccessBlock)( PABaseRequestService * service);
typedef void(^ServiceFailedBlock)(PABaseRequestService * service,NSString *errorMsg);

@protocol PABaseServiceDelegate <NSObject>

@optional

- (void)loadDataSuccess;

- (void)loadDataFailed:(NSString *)errorMsg;

@end

@interface PABaseRequestService : NSObject

@property (nonatomic, assign) id<PABaseServiceDelegate>delegate;

@property (nonatomic, copy)   ServiceSuccessBlock successBlock;
@property (nonatomic, copy)   ServiceFailedBlock failedBlock;

@end
