//
//  PANewNoticeModel.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/30.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PANewNoticeModel : NSObject
@property(nonatomic, strong)NSString *noticeCode;
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *noticeContent;
@property(nonatomic, strong)NSString *noticeTime;
@property(nonatomic, strong)NSArray *attachmentIds;
@property(nonatomic, strong)NSString *readNum;
@property(nonatomic, assign)BOOL isRead;
@end
