//
//  BMSpacePresenter.h
//  TimeHomeApp
//
//  Created by UIOS on 16/3/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"
#import "UserPublishCar.h"

@interface BMSpacePresenter : BasePresenters
///搜索出租出售车位交易信息（/sercarrental/getappsearchcarrental）
/*
 {
 “token”:”1502531323”
 ,”sertype”:1
 ,”cityid”:123
 ,”countyid”:123
 ,”moneybegin”:10
 ,”moneyend”:50,”fixed”:1
 ,”underground”:1
 ,”name”:”sdkfj”
 ,”orderby”:”money desc”
 ,”page”:1
 }
 */
+(void)getAppSearchCarrental:(UpDateViewsBlock)block withInfo:(NSDictionary *)InfoDic;
///我发布的车位（/sercarrental/getusercarrental）
+(void)getUserCarrental:(UpDateViewsBlock)block withPage:(NSString *)page;
///添加出租出售车位交易信息（/sercarrental/addcarrental）
/*
 “token”:”1502531323”
 ,”sertype”:1
 ,”countyid”:123
 ,”communityname”:”金谈固小区”
 ,”mapx”:12.33
 ,”mapy”:32.3
 ,”address”:”河北省石家庄”
 ,”title”:”好用车位”
 ,”description”,”很好”
 ,”fixed”:0
 ,”underground”:1
 ,”money”:”200.0”
 ,”linkman”:”df到访”
 ,”linkphone”:”143838338”
 ,”picids”:”2321,34”
 ,”flag”:1

 */
+(void)addCarrental:(UpDateViewsBlock)block withInfo:(NSDictionary *)InfoDic;
///修改出租出售车位交易信息（/sercarrental/changecarrental）
/*
 {
 “token”:”1502531323”
 ,”id”:”1”
 ,”countyid”:123
 ,”communityname”:”金谈固小区”
 ,”mapx”:12.33
 ,”mapy”:32.3
 ,”address”:”河北省石家庄”
 ,”title”:”好用车位”
 ,”description”,”很好”
 ,”fixed”:0
 ,”underground”:1
 ,”money”:”200.0”
 ,”linkman”:”df到访”
 ,”linkphone”:”143838338”
 ,”picids”:”2321,34”
 ,”flag”:1
 */
+(void)changeCarrental:(UpDateViewsBlock)block withInfo:(NSDictionary *)InfoDic;
///删除出租出售车位交易信息（/sercarrental/removecarrental）
+(void)removeCarrental:(UpDateViewsBlock)block withID:(NSString *)carrentalID;
///搜索求购求租车位交易信息（/sercarrentalwant/getappsearchcarrentalwant）
/*
 “token”:”1502531323”
 ,”sertype”:1
 ,”cityid”:123
 ,”countyid”:123
 ,”moneybegin”:10
 ,”moneyend”:50
 ,”name”:”sdkfj”
 ,”orderby”:”moneybegin desc”
 ,”page”:1

 */
+(void)getAppSearchCarrentalWant:(UpDateViewsBlock)block withInfo:(NSDictionary *)InfoDic;
///添加求租求购车位交易信息（/sercarrentalwant/addcarrentalwant）
/*
 “token”:”1502531323”
 ,”sertype”:2
 ,”countyid”:123
 ,”title”:”好用车位”
 ,”description”,”很好”
 ,”fixed”:0
 ,”underground”:1
 ,”moneybegin”:”200.0”
 ,”moneyend”:”250.0”
 ,”linkman”:”df到访”
 ,”linkphone”:”143838338”
 ,”flag”:1

 */
+(void)addCarrentalWant:(UpDateViewsBlock)block withInfo:(NSDictionary *)InfoDic;
///修改求租求购车位交易信息（/sercarrentalwant/changecarrentalwant）
/*
 “token”:”1502531323”
 ,”id”:”2”
 ,”countyid”:123
 ,”title”:”好用车位”
 ,”description”,”很好”
 ,”fixed”:0
 ,”underground”:1
 ,”moneybegin”:”200.0”
 ,”moneyend”:”250.0”
 ,”linkman”:”df到访”
 ,”linkphone”:”143838338”
 ,”flag”:1

*/
+(void)changeCarrentalWant:(UpDateViewsBlock)block withInfo:(NSDictionary *)InfoDic;
///删除求租求购车位交易信息（/sercarrentalwant/removecarrentalwant）
+(void)removeCarrentalWant:(UpDateViewsBlock)block withID:(NSString *)wantID;
@end
