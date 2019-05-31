//
//  PARedBagModel.h
//  TimeHomeApp
//
//  Created by WangKeke on 2018/2/7.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PARedBagDetailModel.h"

@interface PARedBagModel : NSObject

@property (copy,nonatomic) NSString *map;//广告内容
@property (assign,nonatomic) NSUInteger type;//卡券类型:0红包1卡券
@property (copy,nonatomic) NSString *userticketid;//领取卡卷记录id
@property (copy,nonatomic) NSString *logo;//红包背景图
@property (copy,nonatomic) NSString *orderid;//
@property (assign,nonatomic) NSUInteger state;//0未领取 1已领取

@property (strong,nonatomic) NSArray *list;//卡券列表 userticketid 字典

+(PARedBagModel *)redBagWithDetail:(PARedBagDetailModel *)redBagDetail;

#pragma mark - helper

+(PARedBagModel *)redBagWithUserticketids:(NSString*)userticketids;

@end
