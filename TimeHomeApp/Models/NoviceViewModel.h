//
//  NoviceView.h
//  TimeHomeApp
//
//  Created by us on 16/4/15.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoviceViewModel : NSObject

///图片名称
@property(nonatomic,copy)NSString * imgName;

///0.全屏 1.在控件的左边left 2.在控件的右边right
@property(nonatomic,assign) int model;
@end
