//
//  IntelligentGarageVC.h
//  TimeHomeApp
//
//  Created by us on 16/2/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  智能车库
 */
#import "BaseViewController.h"

@interface IntelligentGarageVC : THBaseViewController<UICollectionViewDataSource,UICollectionViewDelegate>

/**
 *  集合视图显示车库数据
 */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *selctBt;
@property (nonatomic,copy)NSString *pushType;//推送跳转传1 其他不传
@property (nonatomic,copy)NSString *redPacketURL;//红包url
@property (nonatomic,copy)NSString *userTicketID;//红包接口用到的id
@end
