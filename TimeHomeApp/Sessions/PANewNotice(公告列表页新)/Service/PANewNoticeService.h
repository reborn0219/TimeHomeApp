//
//  PANewNoticeService.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/30.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequestService.h"
#import "PANewNoticeModel.h"
@interface PANewNoticeService : PABaseRequestService

@property (nonatomic, strong)NSMutableArray * noticeArray;
@property (nonatomic, strong)NSMutableArray * topNoticeArray;
/**
 加载新公告列表接口

 @param page page description
 @param success success description
 @param failed failed description
 */
- (void)loadNewNoticeListWithPage:(NSInteger)page
                          success:(ServiceSuccessBlock)success
                           failed:(ServiceFailedBlock)failed;


/**
 加载首页top公告接口

 @param success success description
 @param failed failed description
 */
- (void)loadNewTopNoticeSuccess:(ServiceSuccessBlock)success
                         failed:(ServiceFailedBlock)failed;

@end
