//
//  BMReplacePresenter.h
//  TimeHomeApp
//
//  Created by UIOS on 16/3/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"
#import "UserPublishRoom.h"

@interface BMReplacePresenter : BasePresenters
///获得二手置换物品类型（/usedtype/getusedtype）
+(void)getUsedType:(UpDateViewsBlock)block;

///搜索二手置换信息（/usedinfo/getappsearchusedinfo）
/*
 {
 “token”:”1502531323”
 ,”cityid”:123
 ,”countyid”:123
 ,”newness”:9
 ,”name”:”sdkfj”
 ,”typeid”:”12“
 ,”orderby”:”newness desc”
 ,”page”:1

 */
+(void)getAppSearchusedInfo:(UpDateViewsBlock)block withInfo:(NSDictionary *)infoDic;
///获得用户二手置换信息（/usedinfo/getuserusedinfo）
+(void)getUserusedInfo:(UpDateViewsBlock)block withPage:(NSString *)page;
///添加二手置换信息（/usedinfo/addusedinfo）
/*
 {
 “token”:”1502531323”
 ,”typeid”:”12“
 ,”countyid”:13
 ,”mapx”:123.3
 ,”mapy”:12.32
 ,”address”:”ksjfdid”
 ,”newness”:9
 ,”name”:”123456789”
 ,”description”:”132sdfs”
 ,”money”:21.36
 ,”linkman”:” 李召”
 ,”linkphone”:” 1383838438”
 ,”flag”:1
 ,”picids”:”232,232”
 }
 */
+(void)addUsedInfo:(UpDateViewsBlock)block withInfo:(NSDictionary *)infoDic;

///修改二手置换信息（/usedinfo/changeusedinfo）
/*
 {
 “token”:”1502531323”
 ,”id”:“1”
 ,”typeid”:”12“
 ,”countyid”:13
 ,”mapx”:123.3
 ,”mapy”:12.32
 ,”address”:”ksjfdid”
 ,”newness”:9
 ,”name”:”123456789”
 ,”description”:”132sdfs”
 ,”money”:21.36
 ,”linkman”:”李召”
 ,”linkphone”:” 1383838438”
 ,”flag”:1
 ,”picids”:”232,232”
 }
 */
+(void)changeUsedInfo:(UpDateViewsBlock)block withInfo:(NSDictionary *)infoDic;
///删除二手置换信息（/usedinfo/removeusedinfo）
+(void)removeUsedInfo:(UpDateViewsBlock)block withID:(NSString *)replaceID;

@end
