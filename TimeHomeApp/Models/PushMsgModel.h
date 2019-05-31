//
//  PushMsgModel.h
//  TimeHomeApp
//
//  Created by us on 16/4/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushMsgModel : NSObject

///消息计数
@property(nonatomic,copy) NSNumber * countMsg;
///消息类型
@property(nonatomic,copy) NSNumber * type;

///json数据
@property(nonatomic,copy) NSString * content;

@end
