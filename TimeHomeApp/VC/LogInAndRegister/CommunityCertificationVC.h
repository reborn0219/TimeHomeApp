//
//  CommunityCertificationVC
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/8/4.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//


/**
 *社区认证
 */
#import "THBaseViewController.h"

@interface CommunityCertificationVC : THBaseViewController

/**
 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;

/**
 认证按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *certificationBtn;

/**
 左右横线
 */
@property (weak, nonatomic) IBOutlet UIImageView *leftLineImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightLineImage;

/**
 展示九宫格
 */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,copy) NSString *pushType;//0是注册页跳转 1为其他

/**
   1.从“我的房产-选择小区”进来 从我的房产列表-未通过审核-重新认证-进来 2.从“我的房产列表-马上认证”进来 3.从“我的房产-特权”进来 4.首页banner跳转 5.从首页摇摇通行认证提交进来 从baseVC进来 6.任务版
 */
@property (nonatomic, assign) NSInteger fromType;
@end
