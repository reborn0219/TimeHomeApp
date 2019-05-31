//
//  bsstestbasemodel.h
//  TimeHomeApp
//
//  Created by UIOS on 2016/10/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface bsstestbasemodel : NSObject

/**
 帖子类型
 */
@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *title;//帖子标题（广告）

@property (nonatomic, copy) NSString *info;//帖子内容

@property (nonatomic, copy) NSString *redOrPink;//红包类型

@property (nonatomic, assign) int imgNo;//图片数量

@property (nonatomic, copy) NSString *allMoney;//总价格（商品，房产车位）

@property (nonatomic, copy) NSString *unit;//单价（房产出售）

@property (nonatomic, copy) NSString *houseOrCar;//车位或房产（房产车位）

@property (nonatomic, copy) NSString *saleOrHire;//出售或出租（房产车位）

@property (nonatomic, copy) NSString *square;//平米数（房产车位）

@property (nonatomic, copy) NSString *roomNo;//房间数（房产车位）

@property (nonatomic, copy) NSString *other;//其他内容（房产车位）

@property (nonatomic, copy) NSArray *voteArr;//投票项（投票）

@property (nonatomic, copy) NSString *voteNo;//投票数（投票）

@property (nonatomic, copy) NSString *voteTag;//投票状态（投票）

@property (nonatomic, assign) int textNo;//投票项数量（投票）

@property (nonatomic, copy) NSString *head;//头像

@property (nonatomic, copy) NSString *name;//昵称

@property (nonatomic, copy) NSString *reQ;//回复

@property (nonatomic, copy) NSString *love;//点赞

@property (nonatomic, assign) float height;//帖子高度

@end
