//
//  THMyInfoPresenter.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/28.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  获取我的界面信息、完善我的信息、上传头像
 */
#import "BasePresenters.h"
#import "UserPhotoWall.h"

@interface THMyInfoPresenter : BasePresenters
/**
 *  获得登陆用户的个人信息--
 */
+ (void)getMyUserInfoUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  保存用户信息--
 */
+ (void)perfectMyUserInfoDict:(NSDictionary *)dict UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  获得某个用户信息
 */
+ (void)getOneUserInfoUserID:(NSString *)userid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  获得用户照片墙
 */
+ (void)getPhotoWallUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  保存用户照片墙
 */
+ (void)savePhotoWallpicids:(NSString *)picids UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;


/**
 * 获得验证是否为业主
 */
+ (void)validationIsTheOwnerUpDataViewblock:(UpDateViewsBlock)updataViewBlock;

@end
