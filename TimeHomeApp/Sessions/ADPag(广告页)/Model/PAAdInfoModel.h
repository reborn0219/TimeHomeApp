//
//  SHAdInfoModel.h
//  PAPark
//
//  Created by WangKeke on 2018/5/28.
//  Copyright © 2018年 SafeHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAAdInfoModel : NSObject

@property (strong,nonatomic) NSString * urlbase64;//图片base64
@property (strong,nonatomic) NSString * outurl;//图片点击链接
@property (strong,nonatomic) NSString * title;//外链title

@end
