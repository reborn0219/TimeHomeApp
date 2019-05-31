//
//  TwoBtnTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//


/**
 *  带有4个按钮的cell，余额、积分、收藏、订单4个按钮
 */
#import <UIKit/UIKit.h>

typedef void (^ TwoButtonClickCallBack)(NSInteger buttonType);
@interface TwoBtnTVC : UITableViewCell
/**
 *  积分
 */
@property (nonatomic, strong) NSString *jfCountString;
/**
 *  余额
 */
@property (nonatomic, strong) NSString *priceString;
/**
 *  收藏数
 */
@property (nonatomic, strong) NSString *collectionNumber;
/**
 *  订单数
 */
@property (nonatomic, strong) NSString *orderNumber;
/**
 *  点击事件回调
 */
@property (nonatomic, copy) TwoButtonClickCallBack twoButtonClickCallBack;

@end

