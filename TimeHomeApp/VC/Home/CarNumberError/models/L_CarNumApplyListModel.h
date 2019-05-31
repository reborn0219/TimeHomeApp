//
//  L_CarNumApplyListModel.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/6/21.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 获得用户车牌纠错历史纪录列表model
 */
@interface L_CarNumApplyListModel : NSObject

/**
 手机号
 */
@property (nonatomic, strong) NSString *phone;
/**
 申请的车牌号
 */
@property (nonatomic, strong) NSString *card;
/**
 门口名称
 */
@property (nonatomic, strong) NSString *aislename;
/**
 申请时间
 */
@property (nonatomic, strong) NSString *systime;
/**
 状态 0 待审核 1 通过 2 未通过
 */
@property (nonatomic, strong) NSString *flag;

//------------自定义属性-------------
//cell高度
@property (nonatomic, assign) CGFloat height;

@end
