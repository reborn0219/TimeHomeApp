//
//  BBSMainPresenters.h
//  TimeHomeApp
//
//  Created by UIOS on 2016/11/3.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"

#import "BBSModel.h"
#import "QuestionModel.h"
#import "L_NormalInfoModel.h"
#import "L_TieziCommentModel.h"
#import "QuestionAnswerModel.h"
#import "L_BBSVisitorsModel.h"

@interface BBSMainPresenters : BasePresenters


/**
    邻趣首页顶部内容：/index/gettopinfo
    请求数据
    1.token
    返回内容包括：顶部banner数组，热门标签栏数组和活跃用户数组。
 */
+(void)getTopInfo:(UpDateViewsBlock)updataViewBlock;

/**
 邻趣首页广告：/index/getadvlist
 请求数据
 1.token
 返回内容包括：广告类型和广告位置。
 */
+(void)getAdvlistInfo:(UpDateViewsBlock)updataViewBlock;


/**
    邻趣搜索：/index/gettaglist
    请求数据
    1.token
    2.type类型：0 首页 1 搜索 2 创建时
    返回内容包括：搜索页面热门标签。
 */
+(void)gettagList:(NSString *)type
  updataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 邻趣首页帖子列表总接口：/post/getpostlist
 请求数据:
 1.token
 2.area区域：0 不限制  -1当前社区 -2当前行政区域  -3当前城市  -99用户自己的帖子  >0的则为城市或者行政区域id
 3.userid：为空则不限制,area为-99则该参数失效查询当前用户自己的帖子,否则传递那个userid的则查询他的帖子
 4.sortkey：排序类型：不传递默认为new;new最新 old最久 
 5.contype：内存类型：0 不限制 1 带图 2 单文字
 6.posttype：帖子类型：-1不限制 0普通帖子 1商品帖子 2投票 3问答 4房产;字符类型可传递0,1,2，3，4
 7.poststate：-1 不限制 0正常在售 1下架
 8.iscollect：是否我收藏 0 不现在 1 是
 9.isuserfollow：是否我关注用户下的帖子0 否 1 是
 10.tagsname：搜索的关键字
 11.pagesize:分页数 可传递否则默认为20
 12.page:页码
 返回内容包括：顶部banner数组，热门标签栏数组和活跃用户数组。
 */
+(void)getPostList:(NSString *)area
            userid:(NSString *)userid
           sortkey:(NSString *)sortkey
           contype:(NSString *)contype
          posttype:(NSString *)posttype
         poststate:(NSString *)poststate
         iscollect:(NSString *)iscollect
      isuserfollow:(NSString *)isuserfollow
          tagsname:(NSString *)tagsname
          pagesize:(NSString *)pagesize
              page:(NSString *)page
       communityid:(NSString *)communityid
  updataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 postpraise/getpraise 点赞列表
*/
+(void)getPraiseList:(NSString *)postid
            pagesize:(NSString *)pagesize
                page:(NSString *)page
     updataViewBlock:(UpDateViewsBlock)updataViewBlock;

//-----------------2.4新增---------------------------------

/**
 3.6.1	获得问答帖子详情/answerpost/getanswerpostinfo
 
 @param postid 帖子id
 */
+ (void)getAnswerPostInfoWithID:(NSString *)postid
                updataViewBlock:(UpDateViewsBlock)updataViewBlock;
/**
 3.3.2	获得普通帖子详情/post/getpostinfo
 
 @param postid 帖子id
 */
+ (void)getPostInfoWithID:(NSString *)postid updataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 分页获得帖子评论列表/postcomment/getfirstcomment

 @param postid 帖子id
 @param page 页码
 @param pagesize 分页数 可传递否则默认为20
 */
+ (void)getCommentWithID:(NSString *)postid withPage:(NSInteger)page updataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 获得个人评论列表/postcomment/getuserpostcomment

 @param postid 帖子id
 @param page 页码
 @param commentid 评论id
 */
+ (void)getUserPostCommentWithID:(NSString *)postid withPage:(NSInteger)page withCommentID:(NSString *)commentid updataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 回复评论/postcomment/addcomment

 @param postid 帖子id
 @param content 内容
 @param commentid 评论id
 @param updataViewBlock
 */
+ (void)addCommentWithID:(NSString *)postid withContent:(NSString *)content withCommentID:(NSString *)commentid updataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 收藏帖子/post/collectpost

 @param postid 帖子id
 @param type 0 收藏 1 取消收藏
 @param updataViewBlock
 */
+ (void)collectPostWithID:(NSString *)postid withType:(NSString *)type updataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 邻趣搜索：/index/gettaglist
 请求数据
 1.token
 2.communityID：小区id
 返回内容包括：该社区帖子数量和参与人数。
 */
+(void)getCommPostStat:(NSString *)communityID
       updataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 个人主页：/user/getgaminfo
 请求数据
 1.token
 2.userid：小区id
 返回内容包括：该用户发帖数量，访客数量，关注数，粉丝数，年龄，性别，业主认证，是否是自己，是否已关注等。
 */
+(void)getgaminfo:(NSString *)userID
  updataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 获得房产帖子详情/housepost/gethousepostinfo
 
 @param postid 帖子id
 */
+ (void)getHousePostInfoWithID:(NSString *)postid updataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 3.8.6	删除评论/postcomment/deletecomment
 
 @param postid 帖子id
 */
+ (void)deleteCommentWithPostID:(NSString *)postid commentid:(NSString *)commentid updataViewBlock:(UpDateViewsBlock)updataViewBlock;

#pragma mark-- 红包模块
/**
 获得红包状态/red/getredstate

 @param redid 红包ID
 @param updataViewBlock 请求回调
 */
+(void)getRedState:(NSString *)redid updataViewBlock:(UpDateViewsBlock)updataViewBlock;

#warning 接口域名/red/getredinfo此接口暂时没用
/**
 3.10.2	获得红包信息/red/getredinfo

 @param redid 红包ID
 @param updataViewBlock 请求回调
 
 */
+(void)getRedInfo:(NSString *)redid updataViewBlock:(UpDateViewsBlock)updataViewBlock;


/**
 3.10.3	领取红包/red/receivered

 @param redid 红包ID
 @param updataViewBlock 请求回调
 
 */
+(void)redReceivered:(NSString *)redid updataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 3.10.4	获得红包领取记录/red/getreceiveinfo

 @param redid 红包ID
 @param updataViewBlock 请求回调
 */
+(void)getRedReceiveInfo:(NSString *)redid updataViewBlock:(UpDateViewsBlock)updataViewBlock;



#pragma mark ------- 发帖相关
/**
 普通帖
 接口域名/post/addpost
 token	是	登陆令牌 可以为空
 title	是	标题没有则传递空
 content	是	内容
 picids	是	图片上传后返回的Id 逗号拼接的字符
 redtype	是	0 红包1 粉包 -1 无红包
 paytype	是	支付类型0 余额 101 支付宝 102 微信
 redallmoney	是	红包总金额
 redallcount	是	红包总个数
 redtheway	是	红包发放类型0 随机 1 定额
 tagsname	是	标签名称,多个则逗号拼接
 */
+(void)postOrdinaryPosts:(NSString *)title andContent:(NSString *)content andPicids:(NSString *)picids andRedtype:(NSString *)redtype andPaytype:(NSString *)paytype andRedallmoney:(NSString *)redallmoney andRedallcount:(NSString *)redallcount andRedtheway:(NSString *)redtheway andTagsname:(NSString *)tagsname andOneMoney:(NSString *)onemoney updataViewBlock:(UpDateViewsBlock)updataViewBlock;


/**
 问答帖
 接口域名/answerpost/addanswerpost
 posttype	是	发布帖子类型 0 普通帖子 1 商品帖子 2 投票 3 问答 4 房产
 title	是	标题
 content	是	问题描述
 picids	是	照片资源表ID,多个则逗号拼接
 rewardtype	是	奖励形式 0 现金 1 积分
 rewardmoney	是	奖励金额
 paytype	是	支付类型0 余额 101 支付宝 102 微信
 tagsname	是	标签名称,多个则逗号拼接
 */
+(void)postQuestionPosts:(NSString *)posttype andTitle:(NSString *)title andContent:(NSString *)content andPicids:(NSString *)picids andRewardtype:(NSString *)rewardtype andPaytype:(NSString *)paytype andRewardmoney:(NSString *)rewardmoney andTagsname:(NSString *)tagsname updataViewBlock:(UpDateViewsBlock)updataViewBlock;



/**
 房产帖
 接口域名/housepost/addhousepost
 type	是	10 房产出售 11 房产出租30 车位出售 31 车位出租
 posttype	是	发布帖子类型 0 普通帖子 1 商品帖子 2 投票 3 问答 4 房产
 title	是	标题没有则为空
 content	是	描述
 picids	是	照片资源表ID,逗号分隔存储
 redtype	是	0 红包1 粉包 -1 无红包
 paytype	是	支付类型0 余额 101 支付宝 102 微信
 redallmoney	是	红包总金额
 redallcount	是	红包总个数
 redtheway	是	红包发放类型0 随机 1 定额
 tagsname	是	标签名称,多个则逗号拼接
 bedroom	是	卧室数
 livingroom	是	客厅数
 toilef	是	卫数
 area	是	面积
 allfloornum	是	总楼层
 floornum	是	楼层
 price	是	单价
 decorattype	是	装修程度：1领包 2 简装
 underground	是	是否地下车位
 fixed	是	是否固定车位
 showday	是	展示天数
 houseareacommunityid 小区ID
 houseareacommunityname 小区名字
 houseareaid   房间ID
 isedit 是否编辑 0发帖 1编辑
 postid 帖子ID
 oneMoney  单个红包金额
 */
+(void)postHousePosts:(NSString *)type andPosttype:(NSString *)posttype andTitle:(NSString *)title andContent:(NSString *)content andPicids:(NSString *)picids andRedtype:(NSString *)redtype andPaytype:(NSString *)paytype andRedallmoney:(NSString *)redallmoney andRedallcount:(NSString *)redallcount andRedtheway:(NSString *)redtheway andTagsname:(NSString *)tagsname andBedroom:(NSString *)bedroom andLivingroom:(NSString *)livingroom andToilef:(NSString *)toilef andArea:(NSString *)area andAllfloornum:(NSString *)allfloornum andFloornum:(NSString *)floornum andPrice:(NSString *)price andDecorattype:(NSString *)decorattype andUnderground:(NSString *)underground andFixed:(NSString *)fixed andShowday:(NSString *)showday andHouseareacommunityid:(NSString *)houseareacommunityid andHouseareacommunityname:(NSString *)houseareacommunityname andHouseareaid:(NSString *)houseareaid andIsedit:(NSString *)isedit andPostid:(NSString *)postid andOnemoney:(NSString *)onemoney updataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 获取我的余额
 接口域名/ balance/getbalance
 */
+(void)getMyBalabceAndUpdataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 获取我的房产列表
 接口域名/housepost/gethouselist
 */
+(void)getMyHouseAndUpdataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 获取我的车位列表
 接口域名/housepost/getparkingarealist
 */
+(void)getMyCarPortAndUpdataViewBlock:(UpDateViewsBlock)updataViewBlock;

// MARK: - 3.8.3	分页获得问答帖子回答列表/answerpost/getanswerlist
/**
 @param postid 帖子id
 */
+ (void)getAnswerWithID:(NSString *)postid withPage:(NSInteger)page updataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *获得帖子修改信息
 接口域名/post/getpostupdateinfo
 postid	是	帖子id
 */
+(void)getPostUpDateInfo:(NSString *)postid AndUpdataViewBlock:(UpDateViewsBlock)updataViewBlock;


//---------邻趣个人中心访客列表----------------
/**
 获得访客用户信息/user/getaccessuserinfo
 */
+ (void)getAccessUserInfoWithUserid:(NSString *)userid page:(NSString *)page UpdataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 删除访客用户信息/user/deleteaccessuser

 @param userid 用户id
 */
+ (void)deleteAccessUserWithAccessid:(NSString *)accessid UpdataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 删除所有访客用户信息/user/deleteallaccessuser
 */
+ (void)deleteAllAccessUserInfoUpdataViewBlock:(UpDateViewsBlock)updataViewBlock;

#pragma mark ------- 新闻帖子

+(void)postNews:(NSString *)posttype title:(NSString *)title andContent:(NSString *)content andPicids:(NSString *)picids andRedtype:(NSString *)redtype andPaytype:(NSString *)paytype andRedallmoney:(NSString *)redallmoney andRedallcount:(NSString *)redallcount andRedtheway:(NSString *)redtheway andTagsname:(NSString *)tagsname andOneMoney:(NSString *)onemoney gotourl:(NSString *)gotourl updataViewBlock:(UpDateViewsBlock)updataViewBlock;

@end
