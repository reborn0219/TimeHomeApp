//
//  L_UserCommentModel.h
//  TimeHomeApp
//
//  Created by 世博 on 2016/11/1.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 分页获得我发布的评论model
 */
@interface L_UserCommentModel : NSObject

/**
 贴子id
 */
@property (nonatomic, strong) NSString *postid;
/**
 帖子标题
 */
@property (nonatomic, strong) NSString *posttitle;
/**
 帖子描述
 */
@property (nonatomic, strong) NSString *postcontent;
/**
 帖子首图；有则显示则返回空
 */
@property (nonatomic, strong) NSString *postpicurl;
/**
 评论id
 */
@property (nonatomic, strong) NSString *theID;
/**
 评论的内容
 */
@property (nonatomic, strong) NSString *content;
/**
 用户id
 */
@property (nonatomic, strong) NSString *userid;
/**
 用户昵称
 */
@property (nonatomic, strong) NSString *nickname;
/**
 用户图片url
 */
@property (nonatomic, strong) NSString *userpicurl;
/**
 回答时间
 */
@property (nonatomic, strong) NSString *systime;
/**
 是否我发布的评论 0 否 1 是
 */
@property (nonatomic, strong) NSString *isme;

/**
 帖子详情地址
 */
@property (nonatomic, strong) NSString *gotourl;

/**
 帖子是否删除
 0为有帖子，可以点进去
 -1下架
 -99已删除
 -2审核未通过
 */
@property (nonatomic, strong) NSString *poststate;

/**
 帖子类型0 普通帖子 1 商品帖子 2 投票 3 问答 4 房产
 */
@property (nonatomic, strong) NSString *posttype;

#pragma mark - 自定义属性
/**
 是否显示"显示全部"按钮
 */
@property (nonatomic, assign) BOOL hideShowButton;

/**
 行高
 */
@property (nonatomic, assign) float height;



@end
