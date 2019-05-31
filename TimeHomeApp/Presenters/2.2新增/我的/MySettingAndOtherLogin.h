//
//  MySettingAndOtherLogin.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/31.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"

@interface MySettingAndOtherLogin : BasePresenters

#pragma mark -- 收货地址
/**
 获得我的收货地址  /receipt/getreceipt
 pagesize	分页数 可传递否则默认为20
 page		页码可不传递默认为1
 */
+ (void)getMyAddressWithPagesize:(NSString *)pageSize AndPage:(NSString *)page AndUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 获得默认收货地址 /receipt/getdefaultreceipt
 */
+ (void)getMyDefaultAddressWithUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 删除收货地址信息  /receipt/deletereceipt
 token      是	登陆令牌
 receiptid	否	为空则新增
 */
+ (void)deleteAddressWithReceiptid:(NSString *)receiptid andUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 保存收货地址  /receipt/savereceipt

 id         否	为空则新增
 provinceid	否	省id
 cityid	    否	市id
 areaid	    否	区域id
 address	否	详细地址
 linkman	否	联系人
 linkphone	否	联系电话
 isdefault	否	设置默认 0 不默认 1 默认
 */
+ (void)saveMyAddressWithID:(NSString *)ID AndProvinceid:(NSString *)provinceid AndCityid:(NSString *)cityid AndAreaid:(NSString *)areaid AndAddress:(NSString *)address AndLinkMan:(NSString *)linkman AndLinkPhone:(NSString *)linkphone AndIsDefault:(NSString *)isdefault AndUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

#pragma mark ---- 实名认证

/**
 获得我的实名认证 /verified/getverified
 */
+ (void)getMyVerifiedWithUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 添加我的实名认证申请 /verified/addverified
 picid	是	上传的照片id
 */
+ (void)addMyVerifiedWithPicId:(NSString *)picID AndUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;


#pragma mark -- 第三方登录
/**
 第三方登录 /bindinguser/login
 type       是	第三方类型 1 qq 2 微信 3 微博
 thirdtoken	是	第三方令牌
 thirdid	是	第三方id
 account	是	第三方账户名称
 */
+ (void)otherLoginWithType:(NSString *)type AndThirdToken:(NSString *)thirdtoken andThirdID:(NSString *)thirdID andAccount:(NSString *)account AndUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 我的第三方绑定列表  /bindinguser/getbindinglist
 errcode	0 成功；返回未绑定则需要绑定
 type       类型第三方类型 1 qq 2 微信 3 微博
 */
+ (void)getMyOtherBindingWithUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;


/**
 添加第三方绑定 /bindinguser/addthird
 token      是	用户登录
 type       是	第三方类型 1 qq 2 微信 3 微博
 thirdtoken	是	第三方令牌
 phone      是	用户手机号
 password   是  密码
 thirdid	是	第三方id
 account	是	账户名称
 verificode	是	验证码
 unionid        提现所需参数
 */
+ (void)addOtherBindingWithType:(NSString *)type AndThifdToken:(NSString *)thifdToken AndPhone:(NSString *)phone AndPassword:(NSString *)password andThirdid:(NSString *)thirdID andAccount:(NSString *)account AndVerificode:(NSString *)verificode AndUnionID:(NSString *)unionid AndUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 删除第三方登录 /bindinguser/deletethird
 token      是	登陆令牌
 thirdtoken	是	第三方令牌
 type       是	第三方类型 1 qq 2 微信 3 微博
 thirdid	是	第三方id
 account	是	账户名称
 */
+ (void)deleteThirdLoginWithThirdToken:(NSString *)thirdToken AndType:(NSString *)type andThirdid:(NSString *)thirdid andAccount:(NSString *)account AndUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 添加用户反馈 /feedback/addfeedback
 type       是	1001 无法登陆 1002 收不到短信 1003 遇到其他问题 9999用户反馈
 content	是	描述
 picid      否	截图或其他照片
 linkinfo	是	联系电话或者qq
 phonemodel	是	机型
 */
+ (void)addMyFeedBackWithType:(NSString *)type andContent:(NSString *)content andPicID:(NSString *)picid andLinkinfo:(NSString *)linkInfo andPhonemodel:(NSString *)phonemodel andTitle:(NSString *)title andUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;
/**
 获得省市县区域
 /sysarea/getarealist
 */
+ (void)GetAreaListWithUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;


/**
 判断有无房产或车位
 /housepost/judgeHouseArea
 */
+ (void)judgeHouseAreaWithType:(NSString *)type andUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

+ (void)addNewOtherBindingWithType:(NSString *)type AndThifdToken:(NSString *)thifdToken AndPhone:(NSString *)phone AndPassword:(NSString *)password andThirdid:(NSString *)thirdID andAccount:(NSString *)account AndVerificode:(NSString *)verificode AndUnionID:(NSString *)unionid AndUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;


@end
