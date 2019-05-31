//
//  AreaSelectListViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 16/4/9.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  选择区域列表
 */
#import "THBaseViewController.h"
#import "LifeIDNameModel.h"

typedef void (^CallBack) (NSString *areaID,NSString *areaString);
@interface AreaSelectListViewController : THBaseViewController
/**
 *  区域id
 */
@property (nonatomic, strong) NSString *areaID;
/**
 *  返回上一页回调
 */
@property (nonatomic, copy) CallBack callBack;

@end
