//
//  LifePresenter.m
//  TimeHomeApp
//
//  Created by us on 16/2/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "LifePresenter.h"

@implementation LifePresenter
/**
 *  处理生活分类数据并更新View
 *
 *  @param updataViewBlock 更新回调
 */
-(void)getLifeData:(UpDateViewsBlock)updataViewBlock
{
    if (self.LifeDataArray==nil) {
        self.LifeDataArray=[NSMutableArray new];
    }
    [self.LifeDataArray removeAllObjects];
    NSArray *strArray=@[@"房屋租售",@"车位租售",@"跳蚤市场",@"车辆定位",@"违章查询"];
    NSArray *iconArray=@[@"生活_房屋租售",@"生活_车位租售",@"生活_二手物品",@"生活_车辆定位",@"生活_违章查询"];
    NSArray *eArray=@[@"生活_E房屋租售",@"生活_E车位租售",@"生活_E二手物品",@"生活_E车辆定位",@"生活_E违章查询"];
    
    PMDataModel * pmDataModel;
    for (int i=0; i<strArray.count; i++) {
        pmDataModel=[[PMDataModel alloc]init];
        pmDataModel.strTitle=strArray[i];
        pmDataModel.strIcon=iconArray[i];
        pmDataModel.strEngLishImgName=eArray[i];
        [self.LifeDataArray addObject:pmDataModel];
    }
    updataViewBlock(self.LifeDataArray,SucceedCode);
}
@end
