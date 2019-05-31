//
//  L_CommentListViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/9.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"
#import "QuestionAnswerModel.h"

typedef void (^PraiseAndCommentCallBack)(NSString *praise,NSString *comment,NSString *PostID,NSString *type);


/**
 评论列表
 */
@interface L_CommentListViewController : THBaseViewController

@property (nonatomic, copy) PraiseAndCommentCallBack praiseAndCommentCallBack;

/**
 帖子id
 */
@property (nonatomic, strong) NSString *postID;

/**
 评论人id
 */
@property (nonatomic, strong) NSString *commentID;
/**
 评论人昵称
 */
@property (nonatomic, strong) NSString *commentNickName;
/**
 是否是来自问答帖的回答
 */
@property (nonatomic, strong) NSString *isAnswerPost;
/**
 问答帖模型
 */
@property (nonatomic, strong) QuestionAnswerModel *QuestionAnswerModel;

@end
