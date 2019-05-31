//
//  PASuggestDetailModel.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/30.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PASuggestDetailModel : NSObject

@property (nonatomic, strong)NSArray * attachmentIds;
@property (nonatomic, strong)NSString *communityName;
@property (nonatomic, strong)NSString *complainant;
@property (nonatomic, strong)NSString *complaintDetails;
@property (nonatomic, strong)NSString *complaintState;
@property (nonatomic, strong)NSString *createTime;
@property (nonatomic, strong)NSString *workOrderCode;

@end
