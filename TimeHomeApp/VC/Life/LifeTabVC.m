//
//  LifeTabVC.m
//  TimeHomeApp
//
//  Created by us on 16/1/11.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "LifeTabVC.h"
#import "LifePresenter.h"
#import "PMCollectionCell.h"
#import "HouseFunctionVC.h"
#import "WebViewVC.h"
#import "CarLocationVC.h"
#import "HouseTableVC.h"
#import "ChatMessageMainVC.h"
#import "PushMsgModel.h"
#import "DataOperation.h"
@interface LifeTabVC ()
{
    /**
     *  生活数据逻辑处理类
     */
    LifePresenter * lifePresenter;
    AppDelegate *appDlgt;
}

@end

@implementation LifeTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
//    self.hidesBottomBarWhenPushed = YES;
    [self setBadges];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --------初始化--------
-(void)initView
{
    appDlgt=GetAppDelegates;
    
    lifePresenter=[[LifePresenter alloc]init];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PMCollectionCell" bundle:nil]
          forCellWithReuseIdentifier:@"PMCollectionCell"];
    
    [lifePresenter getLifeData:^(id  _Nullable data, ResultCode resultCode) {
        if (resultCode==SucceedCode) {
            [self.collectionView reloadData];
        }
    }];

}


#pragma mark - ---------UICollection协议实现--------------
/**
 *  返回集合个数
 *
 *  @param view    <#view description#>
 *  @param section section description
 *
 *  @return return value 返回集合个数
 */
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [lifePresenter.LifeDataArray count];
}
/**
 *  处理每项视图数据
 *
 *  @param collectionView collectionView description
 *  @param indexPath      indexPath description
 *
 *  @return return value cell
 */

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PMCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PMCollectionCell" forIndexPath:indexPath];
    PMDataModel * pmData=[lifePresenter.LifeDataArray objectAtIndex:indexPath.row];
//    [cell.img_English setImage:[UIImage imageNamed:pmData.strEngLishImgName]];
    [cell.img_Icon setImage:[UIImage imageNamed:pmData.strIcon]];
    [cell.lab_Title setText:pmData.strTitle];
    return cell;
}



//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH-50)/3, (SCREEN_WIDTH-50)/3);
}

-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    PMCollectionCell *cell=(PMCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.view_BackBg setBackgroundColor:UIColorFromRGB(0xffffff)];
    
}
-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    PMCollectionCell *cell=(PMCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.view_BackBg setBackgroundColor:UIColorFromRGB(0x818181)];
}



//事件处理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0://房屋出租
        {
            AppDelegate * appDlt=GetAppDelegates;
            if(appDlt.userData.openmap!=nil)
            {
                NSInteger flag=[[appDlt.userData.openmap objectForKey:@"serresi"] integerValue];
                if(flag==0)
                {
                    [self showToastMsg:@"所在小区暂未开通此功能" Duration:5];
                    return;
                }
                
            }
            
            HouseFunctionVC *hfVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HouseFunctionVC"];
            hfVC.jumpCode=0;
            [self.navigationController pushViewController:hfVC animated:YES];
        }
            
            break;
        case 1://车位出租
        {
            AppDelegate * appDlt=GetAppDelegates;
            if(appDlt.userData.openmap!=nil)
            {
                NSInteger flag=[[appDlt.userData.openmap objectForKey:@"serparking"] integerValue];
                if(flag==0)
                {
                    [self showToastMsg:@"所在小区暂未开通此功能" Duration:5];
                    return;
                }
                
            }

            HouseFunctionVC *hfVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HouseFunctionVC"];
            hfVC.jumpCode=1;
            hfVC.title=@"车位租售";
            [self.navigationController pushViewController:hfVC animated:YES];
        }
            
            break;
        case 2://二手物品
        {
            AppDelegate * appDlt=GetAppDelegates;
            if(appDlt.userData.openmap!=nil)
            {
                NSInteger flag=[[appDlt.userData.openmap objectForKey:@"serused"] integerValue];
                if(flag==0)
                {
                    [self showToastMsg:@"所在小区暂未开通此功能" Duration:5];
                    return;
                }
                
            }
            HouseTableVC *hfVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HouseTableVC"];
            hfVC.jmpCode=2;
            hfVC.title=@"跳蚤市场";
            [self.navigationController pushViewController:hfVC animated:YES];
        }
            
            break;
        case 3://车辆定位
        {
            CarLocationVC *hfVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CarLocationVC"];
            [self.navigationController pushViewController:hfVC animated:YES];
        }
            
            break;
        case 4://违章查询
        {
            UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
            WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
            webVc.url=@"http://m.cheshouye.com/api/weizhang/";
            webVc.title=@"车辆违章查询";
            [self.navigationController pushViewController:webVc animated:YES];
        }
            
            break;
            
        default:
            break;
    }
}



#pragma mark - ---------导航条事件--------------
/**
 *  进入消息
 *
 *  @param sender sender description
 */
- (IBAction)Nav_RightBtnClike:(UIBarButtonItem *)sender {
    
    PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.ChatMsg];
    if(pushMsg!=nil)
    {
        pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
        pushMsg.content=@"";
        [UserDefaultsStorage saveData:pushMsg forKey:appDlgt.ChatMsg];
    }
    
    ChatMessageMainVC * chatVC = [[UIStoryboard storyboardWithName:@"Chat" bundle:nil]instantiateViewControllerWithIdentifier:@"ChatMessageMainVC"];
    chatVC.Type = 1;
    
    [self.navigationController pushViewController:chatVC animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -----------------推送消息------------------
-(void)subReceivePushMessages:(NSNotification *)aNotification
{
    [self setBadges];
}
///设置消息标记
-(void)setBadges
{
    PushMsgModel * pushMsg;
//    [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"消息"]];
    ///消息聊天标记
    pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.PersonalMsg];
    if(pushMsg!=nil)
    {
        if([pushMsg.countMsg integerValue]>0)
        {
//            [self.navigationItem.rightBarButtonItem setImage:[[UIImage imageNamed:@"消息_收到消息"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            
        }
    }
   
    NSArray * fetchController;
    fetchController = [[DataOperation sharedDataOperation] getChatGoupListData];
    Gam_Chat * GCT;
    for(NSInteger i=0;i<fetchController.count;i++)
    {
        GCT=[fetchController objectAtIndex:i];
        
        if(GCT.countMsg.integerValue>0)
        {
//            [self.navigationItem.rightBarButtonItem setImage:[[UIImage imageNamed:@"消息_收到消息"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            break;
        }
    }
//    NSFetchedResultsController * fetchController;
//    fetchController = [[DataOperation sharedDataOperation]groupQueryData:@"Gam_Chat"];
//    
//    NSInteger rowCount=0;
//    for(NSInteger i=0;i< [fetchController sections].count;i++)
//    {
//        NSInteger unReadCount = (long)[[[fetchController sections] objectAtIndex:i] numberOfObjects];
//        rowCount+=unReadCount;
//    }
//    
//    if(rowCount>[fetchController sections].count)
//    {
//        [self.navigationItem.rightBarButtonItem setImage:[[UIImage imageNamed:@"消息_收到消息"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    }
}

@end
