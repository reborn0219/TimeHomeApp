//
//  L_NewAddBikesViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/19.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "L_BikeListModel.h"

typedef void(^CompleteBlock)();

/**
 新版添加或修改二轮车
 */
@interface L_NewAddBikesViewController : THBaseViewController

/**
 从修改界面过来YES 添加界面过来NO
 */
@property (nonatomic, assign) BOOL isFromEditing;

@property (nonatomic, strong) L_BikeListModel *bikeListModel;

@property (nonatomic, copy) CompleteBlock completeBlock;

/**
 1.从二轮车防盗添加过来 
 */
@property (nonatomic, assign) NSInteger fromType;

@end
