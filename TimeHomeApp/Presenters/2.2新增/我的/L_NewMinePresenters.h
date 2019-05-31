//
//  L_NewMinePresenters.h
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/31.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"
#import "L_UserCommentModel.h"

#import "L_MyFollowersModel.h"

#import "L_BalanceListModel.h"

#import "L_HelpModel.h"

/**
 2.2我的部分接口
 */
@interface L_NewMinePresenters : BasePresenters

/**
 3.9.9--我关注的用户（/userfollow/getfollow）

 @param pagesize 分页数 可传递否则默认为20
 @param page 页码可不传递默认为1
 @param updataViewBlock
 */
+ (void)getMyFollowWithPagesize:(NSInteger)pagesize page:(NSInteger)page UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 3.9.10--添加取消关注(/userfollow/addfollow)

 @param userid 用户id
 @param type 0 新增 1 取消
 @param updataViewBlock
 */
+ (void)addFollowWithUserid:(NSString *)userid type:(NSInteger)type UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 3.4.7--取消确认订单(/goodsorder/cancelorder)

 @param postid 帖子id
 @param updataViewBlock
 */
+ (void)cancelOrderWithPostid:(NSString *)postid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 3.4.10--确认订单发货(/goodsorder/sendgoods)

 @param postid 帖子id
 @param serialno 订单流水号
 @param updataViewBlock
 */
+ (void)sendGoodsWithPostid:(NSString *)postid serialno:(NSString *)serialno UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 3.4.11--确认收货(/goodsorder/receiptgoods)

 @param postid 帖子id
 @param serialno 订单流水号
 @param updataViewBlock
 */
+ (void)receiptGoodsWithPostid:(NSString *)postid serialno:(NSString *)serialno UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 3.4.12--下架(/housepost/closehouse)

 @param postid 帖子id
 @param updataViewBlock
 */
+ (void)offGoodsWithPostid:(NSString *)postid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;


/**
 3.8.4--分页获得我发布的评论(/postcomment/getusercomment)

 @param page 页码
 @param pagesize 分页数 可传递否则默认为20
 @param updataViewBlock
 */
+ (void)getUserCommentWithPage:(NSInteger)page pagesize:(NSInteger)pagesize UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;


/**
 3.8.6--删除评论(/postcomment/deletecomment)

 @param postid 帖子id
 @param commentid 评论id
 @param updataViewBlock
 */
+ (void)deleteCommentWithPostid:(NSString *)postid commentid:(NSString *)commentid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 3.9.7--分页获得我的余额记录(/balance/getbalancelist)

 @param page 页码可不传递默认为1
 @param pagesize 分页数 可传递否则默认为20
 @param updataViewBlock
 */
+ (void)getBalanceListWithPage:(NSInteger)page pagesize:(NSInteger)pagesize UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 3.9.8--余额提现(/balance/cashbalance)
 
 @param paytype 101 支付宝 102 微信
 @param paynumber 提现到账户
 @param money 金额
 @param updataViewBlock
 */
+ (void)cashBalanceListWithPaytype:(NSInteger)paytype UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 3.11.2--帮助与反馈(/ help/gethelptype)

 @param updataViewBlock
 */
+ (void)getHelpTypeUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

///**
// 3.4.4--获得我的购买(/goodspost/getbuypost)
//
// @param saletype 交易类型 0 正在交易 1 交易完成
// @param pagesize 分页数 可传递否则默认为20
// @param page 页码可不传递默认为1
// @param updataViewBlock
// */
//+ (void)getbuypostWithSaletype:(NSInteger)saletype pagesize:(NSInteger)pagesize page:(NSInteger)page UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;
//
///**
// 3.4.3--获得我的出售(/goodspost/getsalepost)
//
// @param saletype 交易类型 0 正在交易 1 交易完成
// @param pagesize 分页数 可传递否则默认为20
// @param page 页码可不传递默认为1
// @param updataViewBlock
// */
//+ (void)getsalepostWithSaletype:(NSInteger)saletype pagesize:(NSInteger)pagesize page:(NSInteger)page UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 3.3.6--删除帖子(/post/delpost)

 @param postid 帖子id
 @param updataViewBlock
 */
+ (void)deletePostWithPostid:(NSString *)postid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 3.4.8--支付购买订单(/goodsorder/payorder)

 @param postid 帖子id
 @param serialno 订单流水号
 @param paytype 支付类型0 余额 101 支付宝 102 微信；是否应该在支付订单界面？？？
 @param updataViewBlock
 */
+ (void)payOrderWithPostid:(NSString *)postid serialno:(NSString *)serialno paytype:(NSString *)paytype UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 3.4.9--支付成功购买订单(/goodsorder/payokorder)

 @param postid 帖子id
 @param serialno 订单流水号
 @param thirdpayno 第三方支付号
 @param updataViewBlock
 */
+ (void)payOkOrderWithPostid:(NSString *)postid serialno:(NSString *)serialno thirdpayno:(NSString *)thirdpayno UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 判断用户是否关注微信公众号  关注以后方可提现

 @param unionid 用户绑定微信的unionid
 @param updataViewBlock 回调
 */
+ (void)whetherToFocusOn:(NSString *)unionid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 3.8.2	帖子点赞操作

 @param type 0点赞 1取消点赞
 @param postid 帖子id
 */
+ (void)addPraiseType:(NSInteger)type withPostid:(NSString *)postid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 3.6.6	问答帖子点赞操作 /postpraise/addpraise
 
 @param type 0点赞 1取消点赞
 @param postid 帖子id
 */
+ (void)addQuestionPraiseType:(NSString *)type
                withcommentid:(NSString *)commentid
              UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 3.6.3	问答帖子采纳 /answerpost/agreeanswer
 
 @param postid 帖子id
 @param commentid 回答id
 */
+ (void)agreeAnswerWithPostid:(NSString *)postID
                    commentid:(NSString *)commentid
              UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

@end
