//
//  SHAdService.h
//  PAPark
//
//  Created by WangKeke on 2018/5/25.
//  Copyright © 2018年 SafeHome. All rights reserved.
//

#import "PABaseRequestService.h"
#import "PAAdInfoModel.h"

@interface PAAdService : PABaseRequestService

@property (strong,nonatomic) PAAdInfoModel *adInfo;

-(void)loadAdImage;

@end
