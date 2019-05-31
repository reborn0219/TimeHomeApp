//
//  L_PowerListModel.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 被授权人列表model
 */
@interface L_PowerListModel : NSObject

/**
 授权id
 */
@property (nonatomic, copy) NSString *theID;
/**
 被授权人用户id
 */
@property (nonatomic, copy) NSString *userid;
/**
 被授权手机号
 */
@property (nonatomic, copy) NSString *phone;
/**
 被授权人姓名
 */
@property (nonatomic, copy) NSString *remarkname;
/**
 授权的时间
 */
@property (nonatomic, copy) NSString *powertime;

/**
 租期开始时间
 */
@property (nonatomic, copy) NSString *rentbegindate;

/**
 租期结束时间
 */
@property (nonatomic, copy) NSString *rentenddate;

//----------cell高度-----------------------------
@property (nonatomic, assign) CGFloat height;

@end
