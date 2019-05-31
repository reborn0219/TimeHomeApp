//
//  PMPresenter.m
//  TimeHomeApp
//
//  Created by us on 16/2/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PMPresenter.h"


@implementation PMPresenter


/**
 *  处理物业分类数据并更新View
 *
 *  @param updataViewBlock 更新回调
 */
-(void)getPMData:(UpDateViewsBlock)updataViewBlock
{
    if (self.PMDataArray==nil) {
        self.PMDataArray=[NSMutableArray new];
    }
    [self.PMDataArray removeAllObjects];
    NSArray *strArray=@[@"智能车库",@"摇摇通行",@"访客通行",@"建议投诉",@"社区公告",@"在线报修"];
    NSArray *iconArray=@[@"物业服务_智能车库",@"物业服务_摇摇通行",@"物业服务_访客通行",@"物业服务_建议投诉",@"物业服务_公告通知",@"物业服务_在线报修"];
     NSArray *eArray=@[@"物业服务_E智能车库",@"物业服务_E摇摇通行",@"物业服务_访客通行e",@"物业服务_E建议投诉",@"物业服务_公告通知e",@"物业服务_E在线报修"];
    
    PMDataModel * pmDataModel;
    for (int i=0; i<strArray.count; i++) {
        pmDataModel=[[PMDataModel alloc]init];
        pmDataModel.strTitle=strArray[i];
        pmDataModel.strIcon=iconArray[i];
        pmDataModel.strEngLishImgName=eArray[i];
        [self.PMDataArray addObject:pmDataModel];
    }
    updataViewBlock(self.PMDataArray,SucceedCode);
}

@end
