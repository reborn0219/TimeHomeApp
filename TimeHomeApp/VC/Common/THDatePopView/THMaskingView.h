//
//  THMaskingView.h
//  TimeHomeApp
//
//  Created by 世博 on 16/4/13.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MMPopupView.h"
#import "MMPopupWindow.h"

@interface THMaskingView : MMPopupView
/**
 *  图片名称
 */
@property (nonatomic, strong) NSString *imageName;
/**
 *  图片位置
 */
@property (nonatomic, assign) CGRect imageRect;


+(instancetype)shareMaskingView;

@end
