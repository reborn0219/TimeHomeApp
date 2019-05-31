//
//  CertificationSuccessfulVC.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/8/5.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface CertificationSuccessfulVC : THBaseViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIView *twoBtnBgView;
@property (weak, nonatomic) IBOutlet UIView *oneBtnBgView;
@property (weak, nonatomic) IBOutlet UIButton *cenertBtn;

@property (nonatomic,copy)NSString *communityName;//认证成功小区名字
@property (nonatomic, copy) NSString *pushType;//从注册跳转传0，其他为1 (用来判断UI显示)
@property (nonatomic, copy) NSString *isMyPush;//从其他跳转传0，我的为1 (用来判断点击跳转)

/**
   1.从“我的房产-选择小区”进来 从我的房产列表-未通过审核-重新认证-进来 2.从“我的房产列表-马上认证”进来 3.从“我的房产-特权”进来 4.首页banner跳转 5.从首页摇摇通行认证提交进来 从baseVC进来 6.任务版
 */
@property (nonatomic, assign) NSInteger fromType;

@end
