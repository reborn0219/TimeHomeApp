//
//  L_TieziCommentModel.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/9.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface L_TieziCommentModel : NSObject


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
 用户图片url
 */
@property (nonatomic, strong) NSString *userpicurl;
/**
 用户昵称
 */
@property (nonatomic, strong) NSString *nickname;
/**
 回答时间
 */
@property (nonatomic, strong) NSString *systime;
/**
 是否我发布的评论 0 否 1 是
 */
@property (nonatomic, strong) NSString *isme;

/**
 评论数
 */
@property (nonatomic, strong) NSString *commentcount;

@property (nonatomic, strong) NSString *tonickname;

//-----------自定义-------------------------------
/**
 cell高度
 */
@property (nonatomic, assign) CGFloat height;

@end
