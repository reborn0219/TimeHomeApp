//
//  IntelligentGaragePresenter.m
//  TimeHomeApp
//
//  Created by us on 16/2/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "IntelligentGaragePresenter.h"

@implementation IntelligentGaragePresenter


/**
 *  获取车库数据和车辆数据
 *
 *  @param updataViewBlock 更新视图回调
 */
-(void)getGaragesAndCarsData:(UpDateViewsBlock)updataViewBlock
{
    
    if(self.arrGarages==nil)
    {
        self.arrGarages=[NSMutableArray new];
    }
    [self.arrGarages removeAllObjects];
    NSMutableArray * arrgarage=[[NSMutableArray alloc]init];
    NSMutableArray * arrcar=[[NSMutableArray alloc]init];
    IntelligentGarageModel * garages;
    GarageCarModel * car;
    for (int i=0; i<6; i++) {
        garages=[[IntelligentGarageModel alloc]init];
        car=[[GarageCarModel alloc]init];
        garages.strCarNum=@"冀A66666";
        garages.strCarNumRemarks=@"小哈哂喹咸夲厅奇";
        garages.strEndDate=@"2016-11-07";
        garages.strGarageName=@"月坛园15号 200013";
        garages.strPhoneNum=@"13931176178";
        garages.numLockState=[[NSNumber alloc]initWithBool:i%2==0];
        garages.numOwnState=[[NSNumber alloc]initWithInt:i>3?0:i];
        [arrgarage addObject:garages];
        
        car.strCarNum=@"冀A66666";
        car.strCarNumRemarks=@"小哈哂喹咸夲厅奇";
        car.numState=[[NSNumber alloc]initWithBool:i%2==0];
        [arrcar addObject:car];
    }
    [self.arrGarages addObject:arrgarage];
    [self.arrGarages addObject:arrcar];
    updataViewBlock(self.arrGarages,SucceedCode);
}

/**
 *  获取车库详情数据
 *
 *  @param updataViewBlock 更新视图回调
 */
-(void)getGaragesDetailData:(IntelligentGarageModel *)garageData callBack:(UpDateViewsBlock)updataViewBlock
{
     if(self.arrGarageDetail==nil)
     {
         self.arrGarageDetail=[NSMutableArray new];
     }
    [self.arrGarageDetail addObject:@[@"晨",@"晨"]];
    [self.arrGarageDetail addObject:@[@"晨",@"晨"]];
    updataViewBlock(self.arrGarageDetail,SucceedCode);
}


@end
