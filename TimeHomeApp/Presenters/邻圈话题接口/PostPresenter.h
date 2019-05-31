//
//  PostPresenter.h
//  TimeHomeApp
//
//  Created by UIOS on 16/3/23.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"
#import "UserTopicModel.h"
#import "UserMsgModel.h"

@interface PostPresenter : BasePresenters

///获取邻圈广告位advertise/getgamadvertise
+(void)getGamadvertise :(UpDateViewsBlock)block;

///获取全部圈子
+(void)getAllTopic:(NSString*)name withPage:(NSString*)page withBlock:(UpDateViewsBlock)block;
///获取我关注的圈子
+(void)getFollowTopic:(NSString*)name withPage:(NSString*)page withBlock:(UpDateViewsBlock)block;
///获得热门话题（/topic/gethottopic）
+(void)getHotTopic:(UpDateViewsBlock)block;
///获得推荐的话题（/topic/getrecommendtopic）
+(void)getRecommendTopic:(NSString * )page :(UpDateViewsBlock)block;
///得到最近浏览的圈子（/topic/getfllowtopic）
+(void)getFllowTopic:(UpDateViewsBlock)block;
///我创建的话题（/topic/getusertopic）
+(void)getUserTopic:(UpDateViewsBlock)block withPage:(NSString *)page;
///获得单个话题帖子信息（/topic/gettopicinfo）
+(void)getTopicInfo:(UpDateViewsBlock)block withTopicID:(NSString *)topicid;

///新增话题（/topic/addtopic）
+(void)addTopic:(UpDateViewsBlock)block withTitle:(NSString *)title andRemarks:(NSString *)remarks andPicid:(NSString*)picid;
///删除话题（/topic/removetopic）
+(void)removeTopic:(UpDateViewsBlock)block withTopicID:(NSString *)topicid;
///获得帖子详情（/topicposts/gettopicpostsinfo）
+(void)getTopicPostsInfo:(UpDateViewsBlock)block withTopicID:(NSString *)postsid;
///分页获得话题帖子（/topicposts/getapptopicposts）
+(void)getAppTopicPosts:(UpDateViewsBlock)block withPage:(NSString *)page;
///分页获取已关注话题内帖子（/topicposts/getfollowtopicposts）
+(void)getFollowTopicPosts:(NSString * )page :(UpDateViewsBlock)block;

///分页话题内的帖子（/topicposts/gettopicposts）
+(void)getTopicPosts:(UpDateViewsBlock)block withPage:(NSString *)page andTopicID:(NSString*)topicid;
///话题内的我发布的帖子（/topicposts/gettopicuserposts）
+(void)getTopicUserPosts:(UpDateViewsBlock)block withPage:(NSString *)page withUserID:(NSString*)userid;
///删除话题内我发布的帖子（/topicposts/removetopicposts）
+(void)removeTopicPosts:(UpDateViewsBlock)block withTopicID:(NSString *)postsid withReason:(NSString *)reason;
///添加帖子点赞（/topicpostspraise/addtopicpraise）
+(void)addTopicPraise:(UpDateViewsBlock)block withTopicID:(NSString *)postsid;
///删除帖子点赞（/topicpostspraise/removetopicpraise）
+(void)removeTopicPraise:(UpDateViewsBlock)block withTopicID:(NSString *)postsid;
///添加帖子评论（/topicpostscomment/addtopiccomment）
+(void)addTopicComment:(UpDateViewsBlock)block withPostID:(NSString *)postsid andContent:(NSString*)content andCommentID:(NSString *)commentid andUserID:(NSString *)userid;
///删除帖子回复（/topicpostscomment/removetopiccomment）
+(void)removeTopicComment:(UpDateViewsBlock)block withCommentID:(NSString *)commentid;
///获得邻圈未读消息个数(/postsmsg/getnoreadmsgcount)
+(void)getMsgCount:(UpDateViewsBlock)block;
///获得邻圈未读消息(/postsmsg/getnoreadmsg)(0未读 1已读)
+(void)getMsg:(UpDateViewsBlock)block withType:(NSString *)type;
///添加话题关注followtopic/addfollowtopic
+(void)addFollowTopic:(NSString *)topicid WithCallBack:(UpDateViewsBlock)block;
///删除话题关注followtopic/removefollowtopic
+(void)removeFollowTopic:(NSString *)topicid WithCallBack:(UpDateViewsBlock)block;
///添加话题帖子（/topicposts/addtopicposts）
+(void)addTopicPosts:(NSString *)topicid withPicIDs:(NSString *)picids andContent:(NSString *)content andCallBack:(UpDateViewsBlock)block;
///举报话题帖子 （/postsreport/addpostsreport）
+(void)addPostsReport:(NSString *)postsid withType:(NSString *)type andSource:(NSString*)source andCallBack:(UpDateViewsBlock)block;
@end
