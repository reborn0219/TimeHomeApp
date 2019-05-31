//
//  L_NewBikeForthTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/19.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_BikeListModel.h"

typedef void(^TFTextCallBack)(NSString *string);
typedef void(^AllButtonDidTouchBlock)(NSInteger buttonIndex);
/**
 感应条码
 */
@interface L_NewBikeForthTVC : UITableViewCell

@property (nonatomic, copy) AllButtonDidTouchBlock allButtonDidTouchBlock;

/**
 扫描按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UIImageView *scan_ImageView;

@property (weak, nonatomic) IBOutlet UITextField *textField;

/**
 输入框右边距 5 -35
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tfTrailingLayout;

/**
 感应条码
 */
@property (nonatomic, strong) NSString *codeString;

@property (nonatomic, copy) TFTextCallBack tFTextCallBack;

/**
 删除按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

/**
 距右间距 52 17
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingLayout;


@end
