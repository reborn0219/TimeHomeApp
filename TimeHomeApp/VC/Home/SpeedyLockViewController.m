//
//  SpeedyLockViewController.m
//  TimeHomeApp
//
//  Created by UIOS on 2017/9/6.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "SpeedyLockViewController.h"

#import "SpeedyLockCollectionViewCell.h"

#import "ParkingManagePresenter.h"

#import "SpeedyLockModel.h"

#import "L_BikeManagerPresenter.h"

#import "IntelligentGarageVC.h"

@interface SpeedyLockViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
    ParkingManagePresenter *parkingPresenter;
    UICollectionView *collection_;
//    UIButton *left;
//    UIButton *right;
    NSMutableArray *dataArray;
    UIImageView *backImgView;
    UIButton *leftButton;
}

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation SpeedyLockViewController

#pragma mark - http request method

-(void)lockOrCallPhoneCarWithIndexPath:(SpeedyLockModel *)speedy
{

    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    NSString *isclock;
    if([speedy.islock integerValue]==1)
    {
        isclock=@"0";
    }
    else
    {
        isclock=@"1";
    }
    @WeakObj(self);
    [parkingPresenter lockcarForParkingcarid:speedy.parkingcarid state:isclock upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if(resultCode==SucceedCode)
            {
                
                speedy.islock = isclock;
                if([speedy.islock integerValue]==1)
                {
                    [selfWeak showToastMsg:@"车已锁定" Duration:3.0];
                }
                else
                {
                    [selfWeak showToastMsg:@"车已解锁" Duration:3.0];
                }
                [selfWeak playSoundForLockCarOrNot];
                
                [collection_ reloadData];
            }
            else
            {
                [selfWeak showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
}

// MARK: - 锁定，解锁请求
- (void)httpRequestForModel:(SpeedyLockModel *)speedy{
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    
    NSString *isclock;
    if([speedy.islock integerValue]==1)
    {
        isclock=@"0";
    }
    else
    {
        isclock=@"1";
    }
    @WeakObj(self);
    /** 锁车状态：0否1是 */
    [L_BikeManagerPresenter setLockWithID:speedy.parkingcarid islock:isclock UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                
                speedy.islock = isclock;
                if([speedy.islock integerValue]==1)
                {
                    [selfWeak showToastMsg:@"车已锁定" Duration:3.0];
                }
                else
                {
                    [selfWeak showToastMsg:@"车已解锁" Duration:3.0];
                }
                [selfWeak playSoundForLockCarOrNot];
                
                [collection_ reloadData];
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}

-(void)httpRequest{
    
    [ParkingManagePresenter getUserinParkingLotCarBikeForupDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (resultCode == SucceedCode) {
                
                NSDictionary *dict = (NSDictionary *)data;
                
                NSString *state = [NSString stringWithFormat:@"%@",dict[@"state"]] ;
                
                if ([state isEqualToString:@"0"]) {
                    
                    NSArray *arr = dict[@"list"];
                    [dataArray removeAllObjects];
                    
                    NSArray *arr1 = [SpeedyLockModel mj_objectArrayWithKeyValuesArray:arr];
                    [dataArray addObjectsFromArray:arr1];
                    
//                    if (dataArray.count <= 1) {
//                        
//                        left.hidden = YES;
//                        right.hidden = YES;
//                    }else{
//                        
//                        left.hidden = NO;
//                        right.hidden = NO;
//                    }
                    backImgView.image = [UIImage imageNamed:@"一键锁定背景图"];
                    UIImage *img = [UIImage imageNamed:@"返回"];
                    img = [img imageWithColor:[UIColor whiteColor]];
                    [leftButton setImage:img forState:UIControlStateNormal];
                    [collection_ reloadData];
                }else if([state isEqualToString:@"1"]){
                    
//                    left.hidden = YES;
//                    right.hidden = YES;
                    backImgView.image = [UIImage imageNamed:@""];
                    UIImage *img = [UIImage imageNamed:@"返回"];
                    img = [img imageWithColor:[UIColor blackColor]];
                    [leftButton setImage:img forState:UIControlStateNormal];
                    
                    [self showNothingnessViewWithType:NoContentTypeSpeedyLock Msg:@"车辆还没有入库\n暂无车辆可以操作" SubMsg:@"" btnTitle:@"去我的车位管理看看" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                        
                        if (index == 0) {
                            
                            UIStoryboard * storyboard=[UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
                            IntelligentGarageVC *pmvc = [storyboard instantiateViewControllerWithIdentifier:@"IntelligentGarageVC"];
                            [self.navigationController pushViewController:pmvc animated:YES];
                        }
                    }];
                    [self.view addSubview:leftButton];
                }else if([state isEqualToString:@"2"]){
                    
//                    left.hidden = YES;
//                    right.hidden = YES;
                    backImgView.image = [UIImage imageNamed:@""];
                    UIImage *img = [UIImage imageNamed:@"返回"];
                    img = [img imageWithColor:[UIColor blackColor]];
                    [leftButton setImage:img forState:UIControlStateNormal];
                    [self showNothingnessViewWithType:NoContentTypeData Msg:@"还没有添加任何车辆\n暂无车辆可以操作" SubMsg:@"" btnTitle:@"回首页" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                        
                        if (index == 0) {
                            
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        
                    }];
                    [self.view addSubview:leftButton];
                }
                
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
        });
    }];
}

/**
 *  锁车解锁声音
 */
- (void)playSoundForLockCarOrNot {
    [YYPlaySound playSoundWithResourceName:@"锁车解锁提示音" ofType:@"wav"];
}

#pragma mark - extend method

-(void)back:(id)sedner{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)configNavigation{
    
    float topHeight;
    AppDelegate *appDel = GetAppDelegates;
    NSString *type = [appDel iphoneType];
    if ([type isEqualToString:@"iPhone X"]) {
        
        topHeight = 50.0;
    }else{
        
        topHeight = 30.0;
    }
    
    leftButton = [[UIButton alloc]initWithFrame:CGRectMake(10, topHeight, 30, 30)];
    UIImage *img = [UIImage imageNamed:@"返回"];
    [leftButton setImage:img forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
}

-(void)configUI{
    
    backImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImgView.image = [UIImage imageNamed:@""];
    [self.view addSubview:backImgView];
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.minimumInteritemSpacing = 0;//行间距
    flow.minimumLineSpacing = 0; //列间距
    
    
    flow.itemSize = CGSizeMake( SCREEN_WIDTH, SCREEN_HEIGHT);
    
    collection_ = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flow];
    collection_.delegate = self;
    collection_.dataSource = self;
    collection_.backgroundColor = [UIColor clearColor];
    
    collection_.bounces = NO;
    collection_.pagingEnabled = YES;
    
    [collection_ registerNib:[UINib nibWithNibName:@"SpeedyLockCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:@"SpeedyLockCollectionViewCell"];
    
    [self.view addSubview:collection_];
    
//    float midWidth = SCREEN_WIDTH * 10 / 16;
//    left = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
//    //left.hidden = YES;
//    left.center = CGPointMake((SCREEN_WIDTH - midWidth )/ 2, 200 + midWidth / 2);
//    [left setImage:[UIImage imageNamed:@"切换箭头左"] forState:UIControlStateNormal];
//    [left addTarget:self action:@selector(left:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:left];
//    
//    right = [[UIButton alloc]initWithFrame:CGRectMake( 0, 0, 60, 60)];
//    //right.hidden = YES;
//    right.center = CGPointMake(left.center.x + midWidth, left.center.y);
//    [right setImage:[UIImage imageNamed:@"切换箭头右"] forState:UIControlStateNormal];
//    [right addTarget:self action:@selector(right:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:right];
    
    [self httpRequest];
}

-(void)left:(id)sender{
    
//    right.hidden = NO;
//    if (_selectIndex != 0) {
//        
//        _selectIndex --;
//    }else{
//        
//        _selectIndex = 0;
//    }
//    
//    if (_selectIndex == 0){
//        
//        left.hidden = YES;
//    }
    
    if (_selectIndex == 0) {
        
        _selectIndex = dataArray.count - 1;
    }else{
        
        _selectIndex--;
    }
    [collection_ scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

-(void)right:(id)sender{
    
//    left.hidden = NO;
//    if (_selectIndex < dataArray.count - 1) {
//        
//        _selectIndex ++;
//    }else{
//        
//        _selectIndex = dataArray.count - 1;
//    }
//    
//    if (_selectIndex == dataArray.count - 1){
//        
//        right.hidden = YES;
//    }
    
    if (_selectIndex == dataArray.count - 1) {
        
        _selectIndex = 0;
    }else{
        
        _selectIndex++;
    }
    [collection_ scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSLog(@"scrollView=====%f",scrollView.contentOffset.x);
    
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        
        int offsetXIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
        
        _selectIndex = offsetXIndex;
//        if (_selectIndex == 0) {
//            
//            left.hidden = YES;
//            right.hidden = NO;
//        }else if (_selectIndex == dataArray.count - 1){
//            
//            left.hidden = NO;
//            right.hidden = YES;
//        }else{
//            
//            left.hidden = NO;
//            right.hidden = NO;
//        }
    }
    
}

#pragma mark - life cycle method

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _selectIndex = 0;
    dataArray = [NSMutableArray array];
    parkingPresenter=[[ParkingManagePresenter alloc]init];
    [self configUI];
    [self configNavigation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
//    [TalkingData trackPageBegin:@"kuaijiesuo"];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    
//     [TalkingData trackPageEnd:@"kuaijiesuo"];
}

#pragma mark - ---------UICollection协议实现--------------
/**
 *  返回集合个数
 *
 *  @param view    view description
 *  @param section section description
 *
 *  @return return value 返回集合个数
 */
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    
    return dataArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
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
    
    SpeedyLockModel *speedy = dataArray[indexPath.row];

    if (indexPath.section == 0) {
        
        SpeedyLockCollectionViewCell *SpeedyLock = [collectionView dequeueReusableCellWithReuseIdentifier:@"SpeedyLockCollectionViewCell" forIndexPath:indexPath];
        NSString *type = [NSString stringWithFormat:@"%@",speedy.type];
        
        if (dataArray.count == 1) {
            
            SpeedyLock.leftButton.hidden = YES;
            SpeedyLock.rightButton.hidden = YES;
        }else{
            
            SpeedyLock.leftButton.hidden = NO;
            SpeedyLock.rightButton.hidden = NO;
        }
        
        if ([type isEqualToString:@"1"]) {
            
            SpeedyLock.headerLockImage.image = [UIImage imageNamed:@"汽车锁"];
            
            SpeedyLock.headerTypeLal.text = [NSString stringWithFormat:@"%@",speedy.communityname];
            SpeedyLock.headerCommLal.text = [NSString stringWithFormat:@"%@",speedy.cmmareaname];
            
            NSString *str = [NSString stringWithFormat:@"%@",speedy.card];
            NSString *str1 = [str substringToIndex:1];
            NSString *str2 = [str substringFromIndex:1];
            SpeedyLock.midTypeLal.text = [NSString stringWithFormat:@"%@\n%@",str1,str2];
            
            SpeedyLock.LockButtonDidClickBlock=^(NSInteger index){
                
                if (index == 0) {
                    
                    [self lockOrCallPhoneCarWithIndexPath:speedy];
                }else if (index == 1){
                    
                    [self left:nil];
                }else if (index == 2){
                    
                    [self right:nil];
                }
            };
        }else{
            
            SpeedyLock.headerLockImage.image = [UIImage imageNamed:@"二轮车锁"];
            
            NSString *str = [NSString stringWithFormat:@"%@",speedy.card];
            SpeedyLock.headerCommLal.text = str;
            
            SpeedyLock.headerTypeLal.text = [NSString stringWithFormat:@"%@",speedy.communityname];
            
            if (str.length >= 3) {
                
                str = [str substringFromIndex:str.length - 3];
                SpeedyLock.midTypeLal.text = str;
            }else{
                
                SpeedyLock.midTypeLal.text = @"电动车";
            }
            
            SpeedyLock.LockButtonDidClickBlock=^(NSInteger index){
                
                if (index == 0) {
                   
                    [self httpRequestForModel:speedy];
                }else if (index == 1){
                    
                    [self left:nil];
                }else if (index == 2){
                    
                    [self right:nil];
                }
                
            };
            
        }
        
        NSString *islock = [NSString stringWithFormat:@"%@",speedy.islock];
        if ([islock isEqualToString:@"0"]) {
            
            SpeedyLock.midLockImage.image = [UIImage imageNamed:@"已解锁"];
            SpeedyLock.bottomLockLal.text = @"已解锁";
        }else{
            
            SpeedyLock.midLockImage.image = [UIImage imageNamed:@"已锁定"];
            SpeedyLock.bottomLockLal.text = @"已锁定";
        }
        
        NSString *isalert = [NSString stringWithFormat:@"%@",speedy.isalert];
        if ([isalert isEqualToString:@"0"]) {
            
            SpeedyLock.bottomVoiceLal.hidden = YES;
            SpeedyLock.bottomVoiceLal.text = @"";
        }else{
            
            SpeedyLock.bottomVoiceLal.hidden = NO;
            SpeedyLock.bottomVoiceLal.text = @"已报警";
        }
        
        return SpeedyLock;
    }
    
    return nil;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
}

//事件处理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
