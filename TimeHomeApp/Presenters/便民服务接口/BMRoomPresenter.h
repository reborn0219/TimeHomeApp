//
//  BMRoomPresenter.h
//  TimeHomeApp
//
//  Created by UIOS on 16/3/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"
#import "UserPublishRoom.h"

@interface BMRoomPresenter : BasePresenters
///搜索二手房产信息（/serresidence/getappsearchresidence）
/*
 {
 ”token”:”1231“
 ,”sertype”:1
 ,”cityid”:123
 ,”countyid”:123
 ,”moneybegin”:1200
 ,”moneyend”:2000
 ,”bedroom”:5
 ,”livingroom”:1
 ,”toilef”:1
 ,”title”:”sdkfj”
 ,”orderby”:”newness desc”
 ,“page”:1
 }
 */
+(void)getAppSearchResidence:(UpDateViewsBlock)block withInfo:(NSDictionary *)infoDic;
///获得用户的房产信息（/serresidence/getuserresidence）
+(void)getUserResidence:(UpDateViewsBlock)block withPage:(NSString *)page;
///添加出售出租房产交易信息（/serresidence /addresidence）
/*
 “token”:”1502531323”
 ,”sertype”:1
 ,“countyid”:122
 ,“communityname”:”金谈固小区”
 ,”mapx”:123.12
 ,”mapy”:13.22
 ,”address”:”地址”
 ,”title”:”大三室”
 ,”description”:”还很新”
 ,”area”:98.2
 ,”floornum”:23
 ,”allfloornum”:31
 ,“bedroom”:2
 ,”livingroom”:1
 ,”toilef”:1
 ,”decorattype”:1
 ,“buildyear”:2015
 ,”facetype”:1
 ,”housetype”:1
 ,”propertyyear”:30
 ,“isinhand”:1
 ,”money”:1000.0
 ,”linkman”:”dsfssd”
 ,”linkphone”:”123456789”
 ,”flag”:1
 ,"picids":”232,213”

 */
+(void)addResidence:(UpDateViewsBlock)block withInfo:(NSDictionary *)infoDic;
///修改出售出租房产交易信息（/serresidence/changeresidence）
/*
 “token”:”1502531323”
 ,”id”:”1”
 ,“countyid”:122
 ,“communityname”:”金谈固小区”
 ,”mapx”:123.12
 ,”mapy”:13.22
 ,”address”:”地址”
 ,”title”:”大三室”
 ,”description”:”还很新”
 ,”area”:98.2
 ,”floornum”:23
 ,”allfloornum”:31
 ,“bedroom”:2
 ,”livingroom”:1
 ,”toilef”:1
 ,”decorattype”:1
 ,“buildyear”:2015
 ,”facetype”:1
 ,”housetype”:1
 ,”propertyyear”:30
 ,“isinhand”:1
 ,”money”:1000.0
 ,”linkman”:”dsfssd”
 ,”linkphone”:”123456789”
 ,”flag”:1
 ,"picids":”232,213”

*/
+(void)changeResidence:(UpDateViewsBlock)block withInfo:(NSDictionary *)infoDic;
///删除出租出售房产交易信息（/serresidence/removeresidence）
+(void)removeResidence:(UpDateViewsBlock)block withID:(NSString *)residenceID;
///搜索求购求租房产信息（/serresidencewant/getappsearchresidencewant）
/*
 {
 ”token”:”1231“
 ,”sertype”:1
 ,”cityid”:123
 ,”countyid”:123
 ,”moneybegin”:1200
 ,”moneyend”:2000
 ,”bedroom”:5
 ,”livingroom”:1
 ,”title”:”sdkfj”
 ,”orderby”:”newness desc”
 ,“page”:1
 }
 */
+(void)getAppSearchResidenceWant:(UpDateViewsBlock)block withInfo:(NSDictionary *)infoDic;
///添加求租求购房产交易信息（/serresidencewant/addresidencewant）
/*
 “token”:”1502531323”
 “sertype”:2
 ,”countyid”:3
 ,”title”:”大三室”
 ,”description”:”还很新”
 ,“bedroom”:2
 ,”livingroom”:1
 ,”area”:98.2
 ,”moneybegin”:1000
 ,”moneyend”:2000
 ,”linkman”:”dsfssd”
 ,”linkphone”:”123456789”
 ,”flag”:1

 */
+(void)addResidenceWant:(UpDateViewsBlock)block withInfo:(NSDictionary *)infoDic;
///修改求租求购房产交易信息（/serresidencewant/changeresidencewant）
/*
 “token”:”1502531323”
 ,”id”:”1”
 ,”countyid”:3
 ,”title”:”大三室”
 ,”description”:”还很新”
 ,“bedroom”:2
 ,”livingroom”:1
 ,”area”:98.2
 ,”moneybegin”:1000
 ,”moneyend”:2000
 ,”linkman”:”dsfssd”
 ,”linkphone”:”123456789”
 ,”flag”:1

 */
+(void)changeResidenceWant:(UpDateViewsBlock)block withInfo:(NSDictionary *)infoDic;
///删除求租求购房产交易信息（/serresidencewant/removeresidencewant）
+(void)removeResidenceWant:(UpDateViewsBlock)block withID:(NSString *)wantID;
@end
