//
//  ChangAreaVC.h
//  TimeHomeApp
//
//  Created by us on 16/3/4.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "THBaseViewController.h"

/**
 *  切换小区
 */

@protocol changeAreaDelegate <NSObject>

- (void)changeArea;

@end

/**
 *  完善资料回调block
 *
 *  @param data 小区名称(全)
 */
typedef void (^MyCallBack)(NSString *communitID,NSString *communitName);

typedef enum : NSUInteger {
    PAGE_SOURCE_TYPE_MYINFO = 1,//表示从完善资料界面过来
    PAGE_SOURCE_TYPE_BIKE = 2,//从二轮车添加进来
    PAGE_SOURCE_TYPE_COMMUNNITYAUTH = 3,//从社区认证进入
} PAGE_SOURCE_TYPE;


@interface ChangAreaVC : THBaseViewController

/**
 *  完善资料回调block
 */
@property (nonatomic, copy) MyCallBack myCallBack;

/**
 *  判断从完善资料界面过来
 */
@property (nonatomic, assign) PAGE_SOURCE_TYPE pageSourceType;

/**
 二轮车小区id
 */
@property (nonatomic, strong) NSString *bikeCommunityID;
/**
 二轮车小区名称
 */
@property (nonatomic, strong) NSString *bikeCommunityName;
/**
 城市id
 */
@property (nonatomic, strong) NSString *bikeCityid;
/**
 城市名称
 */
@property (nonatomic, strong) NSString *bikeCityName;


@property (nonatomic, unsafe_unretained) id<changeAreaDelegate> delegate;


@end
