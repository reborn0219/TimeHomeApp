//
//  L_GivenPeopleListViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"

typedef void(^GivenSuccessBlock)();

@interface L_GivenPeopleListViewController : THBaseViewController

@property (nonatomic, copy) GivenSuccessBlock givenSuccessBlock;

/**
 券id
 */
@property (nonatomic, strong) NSString *theid;

@end
