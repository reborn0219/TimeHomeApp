//
//  PAVersionModel.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/5/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PAVersionvalidIPModel : NSObject
@property (nonatomic, strong) NSString * fromIP;
@property (nonatomic, strong) NSString * toIP;
@property (nonatomic, assign) BOOL conformIP; // 合法IP
@end

@interface PAVersionModel : NSObject

///最新版本号
@property (nonatomic, strong) NSString *version;
///灰度下发，指定有效网段
@property (nonatomic, strong) PAVersionvalidIPModel *validIP;
///是否强制更新
@property (nonatomic, assign) NSInteger isForce;
///非强制更新下提醒升级的间隔
@property (nonatomic, strong) NSString *timeInterval;
///更新文案
@property (nonatomic, strong) NSArray *information;
///提示框主题颜色
@property (nonatomic, strong) NSString *themeColor;
///升级包或商店的地址;
@property (nonatomic, strong) NSString *packageUrl;

///是否需要更新
@property (nonatomic, assign) BOOL needUpdate;


@end
