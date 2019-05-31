//
//  L_CommunityAuthoryPresenters.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"
#import "L_ResiListModel.h"
#import "L_ResiCarListModel.h"
#import "L_MyHouseListModel.h"
#import "L_HouseInfoModel.h"

/**
 2.5.0 社区认证
 */
@interface L_CommunityAuthoryPresenters : BasePresenters

/**
 1.获得当前社区的待认证房产与车位 community/getwaitcertinfo
 
 @param updataViewBlock updataViewBlock
 */
+ (void)getWaitCertInfoWithCommunityid:(NSString *)communityid UpdataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 2.一键认证社区下房产 community/akeycert
 
 @param updataViewBlock updataViewBlock
 */
+ (void)akeyCertWithCommunityid:(NSString *)communityid UpdataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 3.获得待认证的房产个数 residcert/getwaitcertcount
 
 @param updataViewBlock updataViewBlock
 */
+ (void)getWaitCertCountUpdataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 4.业主社区房产数据 residcert/getownercertresi
 
 @param updataViewBlock updataViewBlock
 */
+ (void)getOwnerCertresiUpdataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 5.获得房产信息 resicert/getresiinfo
 
 @param theID 房产id
 @param updataViewBlock updataViewBlock
 */
+ (void)getResiInfoWithID:(NSString *)theID UpdataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 6.提交申请房产认证 resicert/identresicert
 @param ownername 业主姓名
 @param buildname 楼栋名称
 @param unitname 单元名称
 @param roomnum 房间号
 @param theID 房产id
 @param updataViewBlock updataViewBlock
 */
+ (void)indentResiCertWithOwnerName:(NSString *)ownername buildName:(NSString *)buildname unitName:(NSString *)unitname roomNum:(NSString *)roomnum communityID:(NSString *)communityid UpdataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 7.删除认证失败的申请 resicert/removeresicert
 
 @param theID 房产id
 @param updataViewBlock updataViewBlock
 */
+ (void)removeresicertWithID:(NSString *)theid UpdataViewBlock:(UpDateViewsBlock)updataViewBlock;


/**
 校验用户权限接口
 map	map	用户信息
 isownercert	int	当前社区是否业主认证 0 否 1 是
 ownerpowertype	int	0 普通用户 1 业主 2 家人 3 租户；按照该级别依次向下先符合那个类型就为那种权限类型
 ownerpower	map	认证对应的权限
 shake	int	门禁权限1 可以使用 0 不可以
 reserve	int	在线报修 1 可以使用0 不可以
 complaint	int	投诉建议
 resipower	int	房产权限操作 1 可以使用 0 不可以
 */
+ (void)checkUserPowerUpdataViewBlock:(UpDateViewsBlock)updataViewBlock;



/**
 获得房产家人列表
 token	string	登陆令牌
 id	string	房产id
 */
+ (void)getResiHomeListWithID:(NSString *)theID andUpdataViewBlock:(UpDateViewsBlock)updataViewBlock;


/**
 修改家人备注名称
 token	string	登陆令牌
 id	string	权限id
 name	string	姓名名称
 */
+ (void)changeHomeNameWithID:(NSString *)theID andName:(NSString *)name andUpdataViewBlock:(UpDateViewsBlock)updataViewBlock;
@end
