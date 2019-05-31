//
//  TopicImgList.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "TopicImgList.h"
#import "TopicImgCell.h"
#import "AppSystemSetPresenters.h"
#import "TopicImgListModel.h"
#import "TZImagePickerController.h"
#import "AppSystemSetPresenters.h"
//图片剪裁库
#import "TOCropViewController.h"
#import "THIndicatorVC.h"

@interface TopicImgList ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,TOCropViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

{
    UITableView * table;
    NSMutableArray * picList;
    NSIndexPath * tempIndexPath;
    BOOL unSelectImg;
    TZImagePickerController *imagePickerVc;
}
@property (nonatomic, strong) UIImagePickerController* picker;
@end

@implementation TopicImgList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    _picker.allowsEditing = NO;
    _picker.navigationBar.tintColor = TEXT_COLOR;
    
    unSelectImg = YES;
    // Do any additional setup after loading the view.
    picList = [[NSMutableArray alloc]initWithCapacity:0];
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-60) style:UITableViewStyleGrouped];
    table.delegate =self;
    table.dataSource=self;
    [self.view setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    [table setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    [table registerNib:[UINib nibWithNibName:@"TopicImgCell" bundle:nil] forCellReuseIdentifier:@"topicImgCell"];
    self.navigationItem.title = @"背景图";
    [self.view addSubview:[self createFooterView]];
    
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarAction:)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    @WeakObj(table);
    if (unSelectImg) {
        
        THIndicatorVC *indicator = [THIndicatorVC sharedTHIndicatorVC];
        [indicator startAnimating:self.tabBarController];
        
        [AppSystemSetPresenters getSysPicType:@"1" UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [indicator stopAnimating];
                
                NSLog(@"%@",data);
                [picList removeAllObjects];
                //修改------sy--06.13
                if ([data isKindOfClass:[NSArray class]]) {
                    [picList addObjectsFromArray:data];
                }
                
                [tableWeak reloadData];
                NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [tableWeak selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];

            });
                          
        }];
    }
}
#pragma mark - rightAction
-(void)rightBarAction:(id)sender
{
    NSLog(@"完成");
    
   TopicImgListModel * TILM = [picList objectAtIndex:tempIndexPath.row];
    self.block(TILM,SucceedCode);
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - tableviewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicImgCell * cell = [tableView dequeueReusableCellWithIdentifier:@"topicImgCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    TopicImgListModel * TILML = [picList objectAtIndex:indexPath.row];
    if (TILML.image) {
        cell.backImgV.image = TILML.image;
    }else
    {
        [cell.backImgV sd_setImageWithURL:[NSURL URLWithString:TILML.fileurl]placeholderImage:PLACEHOLDER_IMAGE];

    }
    return cell;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return picList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tempIndexPath = indexPath;
}
#pragma  mark - TableViewFooterView
-(UIView *)createFooterView
{
    UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT-60-64, SCREEN_WIDTH,60)];
    [v setBackgroundColor:BLACKGROUND_COLOR];
    
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(20,10, SCREEN_WIDTH-40,40)];
    [btn setTitle:@"从相册中选择" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btn setBackgroundColor:PURPLE_COLOR];
    [btn addTarget:self action:@selector(selectImgAction) forControlEvents:UIControlEventTouchUpInside];

    [v addSubview:btn];
    
    return v;
}
-(void)selectImgAction
{
    NSLog(@"从相册选择图片");
    [self pickPhotoButtonClick];
}
- (void)pickPhotoButtonClick{

//            _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            [self presentViewController:_picker animated:YES completion:nil];

//    @WeakObj(self)
    
    imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.pickerDelegate = self;
    [self presentViewController:imagePickerVc animated:YES completion:nil];

//    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets){
    
//        UIImage * tempImg = photos[0];
//        
//        AppDelegate *appDelegate =GetAppDelegates;
//        
//        TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:tempImg];
//        cropController.delegate = selfWeak;
//        cropController.defaultAspectRatio = TOCropViewControllerAspectRatio5x2;
//        cropController.rotateClockwiseButtonHidden = NO;
//        cropController.rotateButtonsHidden = YES;
//        cropController.aspectRatioLocked = YES;
//        [appDelegate.getCurrentViewController presentViewController:cropController animated:YES completion:nil];
        
//        UIImage * tempImg = photos[0];
//        TopicImgListModel * TIML = [[TopicImgListModel alloc]init];
//        TIML.image = tempImg;
//        [picList insertObject:TIML atIndex:0];
//        
//        [selfWeak upLoadImgForImg:photos[0]];
        
//     }];
 
}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //模态消失
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets
{
    @WeakObj(self);
    imagePickerVc = nil;
    
    UIImage * tempImg = photos[0];
    unSelectImg = NO;

    [GCDQueue executeInGlobalQueue:^{
        [GCDQueue executeInMainQueue:^{
            TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:tempImg];
            cropController.delegate = selfWeak;
            cropController.defaultAspectRatio = TOCropViewControllerAspectRatio5x2;
            cropController.rotateClockwiseButtonHidden = NO;
            cropController.rotateButtonsHidden = YES;
            cropController.aspectRatioLocked = YES;
            [selfWeak presentViewController:cropController animated:YES completion:nil];
        }];
    }];
    
}
/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = nil;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        if (picker.allowsEditing) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        }else {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
    }else {
        if (picker.allowsEditing) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        }else {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    unSelectImg = NO;
    
    [GCDQueue executeInGlobalQueue:^{
        [GCDQueue executeInMainQueue:^{
            TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
            cropController.delegate = self;
            cropController.defaultAspectRatio = TOCropViewControllerAspectRatio5x2;
            cropController.rotateClockwiseButtonHidden = NO;
            cropController.rotateButtonsHidden = YES;
            cropController.aspectRatioLocked = YES;
            [self presentViewController:cropController animated:YES completion:nil];
        }];
    }];
    

}
 */
#pragma mark - Cropper Delegate - 编辑图片
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    @WeakObj(self);
    [cropViewController dismissAnimatedFromParentViewController:self toFrame:CGRectMake(self.view.centerX_sd, self.view.centerY_sd, 0, 0) completion:^{
        
        TopicImgListModel * TIML = [[TopicImgListModel alloc]init];
        TIML.image = image;
        [picList insertObject:TIML atIndex:0];

        [selfWeak upLoadImgForImg:image];
        
    }];
}
/**
 *  取消编辑图片
 */
- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    [cropViewController dismissAnimatedFromParentViewController:self toFrame:CGRectMake(self.view.centerX_sd, self.view.centerY_sd, 0, 0) completion:nil];
}
///上传图片
-(void)upLoadImgForImg:(UIImage *)img
{
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    @WeakObj(table)
    [AppSystemSetPresenters upLoadPicFile:img UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            if([[THIndicatorVC sharedTHIndicatorVC] isStarting])
//            {
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
//            }
            if (resultCode == SucceedCode) {
                
                NSString *picID = [NSString stringWithFormat:@"%@",[data objectForKey:@"id"]];
                
                TopicImgListModel * TIML = [picList firstObject];
                TIML.picID = (NSString *)picID;
                [tableWeak reloadData];
                NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [tableWeak selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                unSelectImg = YES;
            }
        });
    }];
    
}


@end
