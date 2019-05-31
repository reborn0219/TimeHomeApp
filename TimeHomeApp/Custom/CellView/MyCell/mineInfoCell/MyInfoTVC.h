//
//  MyInfoTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我的首页界面中最上面的带有头像的cell
 *
 *  @return
 */
#import <UIKit/UIKit.h>

typedef void (^ headClickCallBack) (void);

@interface MyInfoTVC : UITableViewCell

@property (nonatomic, strong) UserData *model;//个人信息model
/**
 *  头像点击事件回调block
 */
@property (nonatomic, copy) headClickCallBack headClick;

@end
