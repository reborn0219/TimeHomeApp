//
//  RecommendTopicModel.h
//  TimeHomeApp
//
//  Created by UIOS on 16/4/5.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendTopicModel : NSObject
@property(nonatomic , copy)NSString * recommendTopicID;
@property(nonatomic , copy)NSString * isfollow;
@property(nonatomic , copy)NSString * isfllow;
@property(nonatomic, copy)NSString * state;

@property(nonatomic , copy)NSString * picurl;
@property(nonatomic , copy)NSString * remarks;
@property(nonatomic , copy)NSString * title;
@property(nonatomic , copy)NSString * topicgotourl;
@property (nonatomic,strong)NSString * auditremarks;

@property (nonatomic,strong)NSString * userid;
@property (nonatomic,strong)NSString * userpic;
@property (nonatomic,strong)NSString * ctrcount;

@end
