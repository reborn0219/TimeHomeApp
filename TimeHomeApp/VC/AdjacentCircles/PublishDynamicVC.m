//
//  PublishDynamicVC.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/4.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.

#import "PublishDynamicVC.h"
#import "Masonry.h"
#import "DynamicImgCell.h"

@interface PublishDynamicVC ()<UITextViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    
}
@property (strong, nonatomic)UICollectionView *collectionV;
@property (strong, nonatomic)  UIButton *publishBtn;
@end

@implementation PublishDynamicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    UICollectionViewFlowLayout * flowlayout = [[UICollectionViewFlowLayout alloc]init];
    
    self.collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowlayout];
    [self.collectionV setBackgroundColor:UIColorFromRGB(0xffffff)];
    
    self.collectionV.delegate = self;
    self.collectionV.dataSource =self;
    
    [self.collectionV registerNib:[UINib nibWithNibName:@"DynamicImgCell" bundle:nil] forCellWithReuseIdentifier:@"imgCell"];
    [self.view addSubview:self.collectionV];
    
    [self.collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@90);
        make.top.equalTo(self.view.mas_top).offset(130);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.left.equalTo(self.view.mas_left).offset(10);

    }];
    
    
    UIView * bottomV = [[UIView alloc]init];
    [bottomV setBackgroundColor:UIColorFromRGB(0xf7f7f7)];
    [self.view addSubview:bottomV];
    
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@55);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        
    }];

    
    self.publishBtn = [[UIButton alloc]init];
    [self.publishBtn setTitle:@"发 表" forState:UIControlStateNormal];
    
    [self.publishBtn setTitleColor:UIColorFromRGB(0x8e8e8e) forState:UIControlStateNormal];
    self.publishBtn.layer.borderWidth = 1.0f;
    self.publishBtn.layer.borderColor = UIColorFromRGB(0xB9BABB).CGColor;    [self.view addSubview:self.publishBtn];

    [self.publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40.0f);
        make.bottom.equalTo(self.view.mas_bottom).offset(-7.5);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.left.equalTo(self.view.mas_left).offset(15);

    }];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark 发布动态
- (void)publishAction:(id)sender {
    
}

#pragma mark - UICollectionViewDelgate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    DynamicImgCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imgCell" forIndexPath:indexPath];
    [cell.imgV setImage:[UIImage imageNamed:@"发表动态_添加照片"]];
    
    return cell;

}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{

    return CGSizeMake(0, 0);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{

        return CGSizeMake(0, 0);
    
    
}
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
 
    
    return 5;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{
    
    return 1;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    return CGSizeMake((SCREEN_WIDTH-70)/3.0,(SCREEN_WIDTH-70)/3.0);
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return 1;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0,0);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
        return [UICollectionReusableView new];

}


@end
