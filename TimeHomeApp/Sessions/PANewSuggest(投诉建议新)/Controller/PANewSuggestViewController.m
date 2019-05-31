//
//  PANewSuggestViewController.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/22.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANewSuggestViewController.h"
#import "PANewSuggestView.h"
#import "PASuggestRecordViewController.h"
#import "FSActionSheet.h"
#import "ACActionSheet.h"
#import "ZZCameraController.h"
#import "PANewSuggestService.h"
@interface PANewSuggestViewController ()<PASuggestDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FSActionSheetDelegate>

@property (nonatomic, strong)PANewSuggestView * suggestView;
@property (nonatomic, strong)PANewSuggestService * suggestService;
@property (nonatomic, strong)NSMutableArray * submitPhotoArray;
@end

@implementation PANewSuggestViewController

#pragma mark -Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        [self initView];
}

- (void)initView{
    [self.view addSubview:self.suggestView];
    [self.suggestView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.title = @"投诉建议";
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 35, 30);
    [rightButton setTitleColor:UIColorHex(0x4A90E2) forState:UIControlStateNormal];
    rightButton.titleLabel.font = DEFAULT_FONT(14);
    [rightButton setTitle:@"投诉记录" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(suggestRecordAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rentItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rentItem;
    self.submitPhotoArray = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PANewSuggestView *)suggestView{
    if (!_suggestView) {
        _suggestView = [[PANewSuggestView alloc]init];
        _suggestView.delegate = self;
    }
    return _suggestView;
}

- (PANewSuggestService *)suggestService{
    if (!_suggestService) {
        _suggestService = [[PANewSuggestService alloc]init];
    }
    return _suggestService;
}
#pragma mark - Actions

/**
 投诉记录页面跳转
 */
- (void)suggestRecordAction{
    PASuggestRecordViewController * record = [[PASuggestRecordViewController alloc]init];
    [self.navigationController pushViewController:record animated:YES];
}

#pragma mark - SuggestDelegate

- (void)choosePhotoAction{

    ACActionSheet * sheet = [[ACActionSheet alloc]initWithTitle:@"" cancelButtonTitle:@"取消" destructiveButtonTitle:@"" otherButtonTitles:@[@"相机",@"从相册选择"] actionSheetBlock:^(NSInteger buttonIndex) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        
            switch (buttonIndex) {
                case 0:{
                    sourceType =UIImagePickerControllerSourceTypeCamera;
                    break;
                }
                case 1:{
                    sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                }
                case 2:{
                    return ;
                }
            }
            sourceType = buttonIndex?UIImagePickerControllerSourceTypePhotoLibrary:UIImagePickerControllerSourceTypeCamera;
            [self showImagePickerWithSourceType:sourceType];
    }];
    [sheet show];
}

- (void)submitSuggestWithMobile:(NSString *)mobile suggestInfo:(NSString *)suggestInfo photoArray:(NSArray<UIImage *> *)photoArray{
    //保存照片
    @weakify(self);
    [self.suggestService submitSuggestWithContactMobile:mobile?:@"" complaintDetails:suggestInfo attachmentIds:weak_self.submitPhotoArray success:^(PABaseRequestService *service) {
        [SVProgressHUD showSuccessWithStatus:@"提交成功"];
        [SVProgressHUD dismissWithDelay:1.75];
        [weak_self.suggestView resetSuggestView];
        [self suggestRecordAction];
    } failed:^(PABaseRequestService *service, NSString *errorMsg) {
        
    }];
    
}

- (void)deletePhotoWithIndex:(NSInteger)index{
    [self.submitPhotoArray removeObjectAtIndex:index];
}

#pragma mark - PhotoPickerDelegate
- (void)showImagePickerWithSourceType:(UIImagePickerControllerSourceType)type{
    if (type == UIImagePickerControllerSourceTypeCamera) {
        ZZCameraController *camera = [[ZZCameraController alloc]init];
        camera.isSaveLocal = NO;
        camera.cameraSourceType = ZZImageSourceForSingle;
        camera.isCanCustom = YES;

        [camera showIn:self result:^(id responseObject) {
            [self updatePhotoViewWithImage:responseObject];
        }];
    } else{
    // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = type;
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self updatePhotoViewWithImage:image];
}

/**
 更新photoView

 @param image image description
 */
- (void)updatePhotoViewWithImage:(UIImage *)image{
    // 上传图片
    @weakify(self);
    [self.suggestService uploadImages:@[image] success:^(PABaseRequestService *service) {
        [self.submitPhotoArray addObjectsFromArray:weak_self.suggestService. submitedImgArray];
        [self.suggestView addPhotoImage:image];

    } failed:^(PABaseRequestService *service, NSString *errorMsg) {
        
    }];
}



@end
