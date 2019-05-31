//
//  L_HouseDetailsViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/13.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"

#import "BBSModel.h"

/**
 *  点赞评论回调
 *  praise点赞数
 *  comment评论数
 *  PostID帖子id
 *  type 0已点赞 1 未点赞
 */
typedef void (^PraiseAndCommentCallBack)(NSString *praise,NSString *comment,NSString *PostID,NSString *type);

typedef void(^DeleteRefreshBlock)(void);

/**
 房产车位帖详情
 */
@interface L_HouseDetailsViewController : THBaseViewController

/**
 删除帖子回调
 */
@property (nonatomic, copy) DeleteRefreshBlock deleteRefreshBlock;

@property (nonatomic, copy) PraiseAndCommentCallBack praiseAndCommentCallBack;

/**
 帖子id
 */
@property (nonatomic, strong) NSString *postID;

@property (nonatomic, strong) BBSModel *bbsModel;

/**
 从评论推送过来
 */
@property (nonatomic, assign) BOOL isFromCommentPush;

@end
