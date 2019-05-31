//
//  LS_ReplyVC.h
//  TimeHomeApp
//
//  Created by 优思科技 on 17/3/16.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface LS_ReplyVC : THBaseViewController
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, copy) UIScrollView *scrollView;
@property (nonatomic, copy) NSString * postID;
@property (nonatomic, copy) NSString * commentID;

@property (nonatomic, copy) NSString *replyName;

@end
