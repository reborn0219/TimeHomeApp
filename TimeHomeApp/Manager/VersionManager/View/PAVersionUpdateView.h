//
//  PAVersionUpdateView.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/5/11.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAVersionModel.h"
@interface PAVersionUpdateView : UIView

/**
 强制更新

 @param versionModel 传入的versionModel
 @param shouldUpdate 是否更新Block
 */
- (void)showForcedUpdate:(PAVersionModel *)versionModel shouldUpdate:(UpDateViewsBlock)shouldUpdate;

/**
 普通更新

 @param versionModel 传入的versionModel
 @param shouldUpdate 是否更新Block
 */
- (void)showGeneralUpdate:(PAVersionModel *)versionModel shouldUpdate:(UpDateViewsBlock)shouldUpdate;

@end
