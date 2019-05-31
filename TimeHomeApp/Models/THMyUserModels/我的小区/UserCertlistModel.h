//
//  UserCertlistModel.h
//  TimeHomeApp
//
//  Created by 世博 on 16/4/5.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  已认证社区集合中的model
 */
#import <Foundation/Foundation.h>

@interface UserCertlistModel : NSObject
/**
 *  社区id
 */
@property (nonatomic, strong) NSString *theID;
/**
 *  社区名称
 */
@property (nonatomic, strong) NSString *name;
/**
 *  社区地址
 */
@property (nonatomic, strong) NSString *address;

//-----自定义------
/**
 cell高度
 */
@property (nonatomic, assign) CGFloat height;

@end
