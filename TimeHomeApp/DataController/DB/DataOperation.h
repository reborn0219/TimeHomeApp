//
//  DataOperation.h
//  YouLifeApp
//
//  Created by UIOS on 15/10/13.
//  Copyright © 2015年 us. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gam_UnreadMsg.h"
#import "Gam_Chat.h"


@interface DataOperation : NSObject

+ (DataOperation *)sharedDataOperation;
///获取单条数据模型
-(NSManagedObject *)creatManagedObj:(NSString *)tableName;
///添加数据
-(void)save;
///删除数据
-(void)deleteObj:(NSManagedObject *)obj;
///查询单个用户数据
-(NSManagedObject *)queryData:(NSString *)tableName;

///查询数据
-(NSArray *)queryData:(NSString *)tableName withRequest:(NSFetchRequest*)userID;

///数据库分页查询－每页20条数据
-(NSArray *)queryData:(NSString *)tableName withCurrentPage: (NSInteger)page;

///查询聊天记录
-(NSArray *)queryData:(NSString *)tableName withCurrentPage: (NSInteger)page withChatID:(NSString *)chatID;
///查询未读消息
-(Gam_UnreadMsg *)queryData:(NSString *)tableName withUserID:(NSString *)userID andReceiveID:(NSString *)receiveID;

///分组查询未读消息
-(NSFetchedResultsController *)groupQueryData:(NSString *)tableName;
///更新未读消息
-(void)queryData:(NSString *)tableName withIsRead:(BOOL)isRead andChatID:(NSString *)chatID andLastObject:(Gam_Chat*)gamChat;
///更新当前聊天用户头像信息
-(void)queryData:(NSString *)tableName withHeadPicUrl:(NSString *)headPicUrl andChatID:(NSString *)chatID andnikeName:(NSString *)sendername;
///删除当前聊天人聊天记录
-(void)deleteDataWithChatID:(NSString *)chatID;
///查询单条数据
-(NSArray *)queryData:(NSString *)tableName withRequest:(NSString*)chatID andSystem:(NSDate *)system;

///查询一条数据
-(NSArray *)ls_queryData:(NSString *)tableName withRequest:(NSString*)chatID;


////查聊天消息列表数据
-(NSArray *) getChatGoupListData;


///邻趣分页查询
-(NSArray *)queryDataFunCircle:(NSString *)tableName withCurrentPage: (NSInteger)page;

///查询统计数据
-(NSArray *)queryDataStatistics:(NSString *)tableName;
///删除上传后的统计数据
-(void)deleteStatisticsData:(NSArray *)statisticsArr;

@end
