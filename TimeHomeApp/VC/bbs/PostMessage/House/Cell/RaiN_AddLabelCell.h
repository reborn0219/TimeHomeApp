//
//  RaiN_AddLabelCell.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/2/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THABaseTableViewCell.h"
#import "CustomTextFIeld.h"

typedef void (^ AddTagsCallBack)();
@interface RaiN_AddLabelCell : THABaseTableViewCell

@property (nonatomic, strong) CustomTextFIeld *addtagTF;

@property (nonatomic, copy) AddTagsCallBack addTagsCallBack;


@end
