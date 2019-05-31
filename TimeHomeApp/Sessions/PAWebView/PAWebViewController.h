//
//  PAWebViewController.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/31.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"
#import "PANewNoticeModel.h"
@interface PAWebViewController : THBaseViewController

@property (nonatomic, strong)PANewNoticeModel * noticeModel;//公告model

@property (nonatomic, strong)NSString * url;
@property (nonatomic, strong)NSString * shareUrl;
//@property (nonatomic, strong)NSString * content;
@property (nonatomic, assign)BOOL hideRightBarButtonItem;
@end
