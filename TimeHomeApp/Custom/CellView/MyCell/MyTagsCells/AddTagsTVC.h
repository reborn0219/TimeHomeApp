//
//  AddTagsTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THABaseTableViewCell.h"
#import "CustomTextFIeld.h"

typedef void (^ AddTagsCallBack)();
@interface AddTagsTVC : THABaseTableViewCell 

@property (nonatomic, strong) CustomTextFIeld *addtagTF;

@property (nonatomic, copy) AddTagsCallBack addTagsCallBack;

@end
