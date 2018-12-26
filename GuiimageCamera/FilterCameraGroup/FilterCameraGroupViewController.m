//
//  FilterCameraGroupViewController.m
//  GuiimageCamera
//
//  Created by Liyanjun on 2018/12/26.
//  Copyright © 2018 hand. All rights reserved.
//

#import "FilterCameraGroupViewController.h"
#import "GPUImage.h"
#import "MyGPUImageFilterGroup.h"
#import "FiterCameraCollectionViewCell.h"
#import "MyGPUImageFilterGroup1.h"
#import "BeautyGPUImageFilterGroup.h"
#import <Photos/Photos.h>
static NSString* const CollectionCellId=@"collectionCellId";
@interface FilterCameraGroupViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) GPUImageStillCamera *myCamera;
@property (nonatomic, strong) GPUImageView *myGPUImageView;
@property (nonatomic, strong) NSMutableArray *filterArr;//滤镜数组
@property (nonatomic, strong) UIButton *selectedBtn;//选中的按钮
@property (nonatomic, strong) UISlider *mySlider;//滑动的杠杆
@property (nonatomic, strong) UILabel *mySliderLabel;//滑块的名字
@property (nonatomic, strong) UISlider *mySlider1;//滑动的杠杆
@property (nonatomic, strong) UILabel *mySliderLabel1;//滑块的名字
@property (nonatomic, strong) UIView *bottomView;//底部的视图
@property (nonatomic, strong) GPUImageFilterGroup *currentFilter;//当前的选中的滤镜
@property (nonatomic, strong) UICollectionView *collectionView;//滚动的数组
@property (nonatomic , assign) CGFloat beginGestureScale;//开始的缩放比例
@property (nonatomic , assign) CGFloat effectiveScale;//最后的缩放比例
@property (nonatomic, strong) NSIndexPath *currentIndexpath;
//成功后的图片
@property (nonatomic, strong) UIImageView *imageView;//成功后显示的图片
@property (nonatomic, strong) UIView *savePicView;//保存图片时候的view
@end

@implementation FilterCameraGroupViewController

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化相机，第一个参数表示相册的尺寸，第二个参数表示前后摄像头
    self.myCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionFront];
    //竖屏方向
    self.myCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.myCamera.horizontallyMirrorFrontFacingCamera = YES;//设置是否为镜像
    self.myCamera.horizontallyMirrorRearFacingCamera = NO;
    //初始化GPUImageView
    self.myGPUImageView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-170)];
    //初始设置为哈哈镜效果
    self.currentFilter = self.filterArr.firstObject[@"class"];
    [self.myCamera addTarget:self.currentFilter];//将初始化过的相机加到目标滤镜上
    [self.currentFilter addTarget:self.myGPUImageView];//将滤镜加在目标GPUImage上
      self.currentIndexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.view addSubview:self.myGPUImageView];
    [self setBeginGestureScale:1.0f];
    [self setEffectiveScale:1.0f];
    [self.myCamera startCameraCapture];//相机开始捕捉画面
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(focusDisdance:)];
    pinchGestureRecognizer.delegate = self;
    [self.myGPUImageView addGestureRecognizer:pinchGestureRecognizer];
    
    //创建UI
    [self creatUI];
}
- (void)back:(UIButton *)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)creatUI{
    
    
    //返回按钮
    UIButton *btn = [[UIButton alloc] initWithFrame: CGRectMake(10, 30, 20, 20)];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //切换前后摄像机
    UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    switchBtn.frame = CGRectMake(ScreenWidth-60, 30, 30, 26.1);
    [switchBtn setImage:[UIImage imageNamed:@"switch"] forState:UIControlStateNormal];
    [switchBtn addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchBtn];
    // UISlider
    _mySlider = [[UISlider alloc] initWithFrame:CGRectMake((ScreenWidth-200)/2, ScreenHeight-200, 200, 30)];
    _mySlider.value = 0.5;
    _mySlider.accessibilityLabel = @"哈哈哈";
    [_mySlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_mySlider];
    [self.view addSubview:self.imageView];
    self.imageView.frame = self.myGPUImageView.frame;
    self.imageView.alpha = 0;
    [self.view addSubview:self.bottomView];
}


// MARK:  action
//MARK:  调整焦距方法
-(void)focusDisdance:(UIPinchGestureRecognizer*)pinch {
    self.effectiveScale = self.beginGestureScale * pinch.scale;
    if (self.effectiveScale < 1.0f) {
        self.effectiveScale = 1.0f;
    }
    CGFloat maxScaleAndCropFactor = 3.0f;//设置最大放大倍数为3倍
    if (self.effectiveScale > maxScaleAndCropFactor)
        self.effectiveScale = maxScaleAndCropFactor;
    NSError *error;
    if([self.myCamera.inputCamera lockForConfiguration:&error]){
        [self.myCamera.inputCamera setVideoZoomFactor:self.effectiveScale];
        [self.myCamera.inputCamera unlockForConfiguration];
    }
    else {
        NSLog(@"ERROR = %@", error);
    }
    
}
// MARK:  找缩放

- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}
// MARK:  滑动slider滚动条
- (void)sliderValueChanged:(UISlider *)slider{
    if ([self.currentFilter isKindOfClass:[MyGPUImageFilterGroup class]]) {
        MyGPUImageFilterGroup *filter = (MyGPUImageFilterGroup*)self.currentFilter;
        filter.gammaFilter.gamma = slider.value*3;
//        filter.exposureFilter.exposure =  slider.value *20 - 10;
    }else  if ([self.currentFilter isKindOfClass:[MyGPUImageFilterGroup1 class]]) {
        MyGPUImageFilterGroup1 *filter = (MyGPUImageFilterGroup1*)self.currentFilter;
        filter.rgbFileter.red = slider.value;
    }else  if ([self.currentFilter isKindOfClass:[BeautyGPUImageFilterGroup class]]) {
        BeautyGPUImageFilterGroup *filter = (BeautyGPUImageFilterGroup*)self.currentFilter;
//        filter.brightnessFilter.brightness= slider.value;
//        filter.saturationFilter.saturation = slider.value*2;
        CGFloat maxValue = 20;
        //平滑因子(distanceNormalizationFactor)
        filter.bilaterFilter.distanceNormalizationFactor = maxValue - slider.value*15;
    }
}

// MARK:  切换前后镜头
- (void)switchIsChanged:(UIButton *)sender {
    [self setBeginGestureScale:1.0f];//在转换摄像头的时候把摄像头的焦距调回1.0
    [self setEffectiveScale:1.0f];
    
    [self.myCamera rotateCamera];
}


// MARK:  开始拍照
- (void)capturePhoto:(UIButton *)sender {
    [self.myCamera capturePhotoAsPNGProcessedUpToFilter:self.currentFilter withCompletionHandler:^(NSData *processedPNG, NSError *error) {
        UIImage *image = [UIImage imageWithData:processedPNG];
        self.imageView.image = image;
        [UIView animateWithDuration:0.6 animations:^{
            self.imageView.alpha = 1;
            self.myGPUImageView.alpha = 0;
            self.mySlider.alpha = 0;
            self.savePicView.alpha = 1;
        }];
    }];
}
// MARK:  照片的返回
- (void)photoBack:(UIButton *)sender {
    self.imageView.image = nil;
    [UIView animateWithDuration:0.6 animations:^{
        self.imageView.alpha = 0;
        self.savePicView.alpha = 0;
        
    }];
    self.myGPUImageView.alpha = 1;
    self.mySlider.alpha = 1;
}
// MARK:   保存图片
- (void)photoSave:(UIButton *)sender {
    __block NSString *localIdentifier = nil;
    UIImage *image = self.imageView.image;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        localIdentifier = req.placeholderForCreatedAsset.localIdentifier;
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                NSLog(@"保存成功");
                [self.view makeToast:@"保存相册成功" duration:0.8 position:CSToastPositionCenter];
            } else if (error) {
                NSLog(@"保存照片出错:%@",error.localizedDescription);
            }
        });
    }];
    
    [UIView animateWithDuration:0.6 animations:^{
        self.imageView.alpha = 0;
        self.savePicView.alpha = 0;
        
    }];
    self.myGPUImageView.alpha = 1;
    self.mySlider.alpha = 1;
    
}

#pragma mark - deletegate
//手势代理方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}
#pragma mark UICollectionViewDelegate
#pragma mark 选中响应事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    self.mySlider.value = 0.5;
    if (3 == (indexPath.row) || 4 == (indexPath.row) || 5 == (indexPath.row) || 7 == (indexPath.row)) {
        self.mySlider.hidden = YES;
    }else{
        self.mySlider.hidden = NO;
    }
    GPUImageFilterGroup *filter = self.filterArr[indexPath.row][@"class"];
    [self.myCamera removeAllTargets];
    [self.myCamera addTarget:filter];
    [filter addTarget:self.myGPUImageView];
    self.currentIndexpath = indexPath;
    self.currentFilter = filter;
    [self sliderValueChanged:self.mySlider];
    [self.filterArr enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == indexPath.row) {
            dic[@"isselected"] = @(YES);
        }else{
            dic[@"isselected"] = @(NO);
        }
    }];
    [collectionView reloadData];
}

// MARK:   UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.filterArr.count;
}
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FiterCameraCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FiterCameraCollectionViewCell.registerCellID forIndexPath:indexPath];
    NSDictionary *dic = self.filterArr[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    cell.isselected = [dic[@"isselected"] boolValue];
    return cell;
}
// MARK:  - getter and setter
- (NSMutableArray *)filterArr{
    if (!_filterArr) {
       
        MyGPUImageFilterGroup *mygroup = [[MyGPUImageFilterGroup alloc] init];
        MyGPUImageFilterGroup1 *mygroup1 = [[MyGPUImageFilterGroup1 alloc] init];
        BeautyGPUImageFilterGroup * beautyGroup = [[BeautyGPUImageFilterGroup alloc] init];
        NSArray *array  = @[[@{@"title":@"反色、伽马、曝光、怀旧",@"class":mygroup,@"isselected":@(YES)} mutableCopy],
                            [@{@"title":@"rgb、卡通",@"class":mygroup1,@"isselected":@(NO)} mutableCopy],
                            [@{@"title":@"美颜（双边模糊、曝光、亮度、饱和）",@"class":beautyGroup,@"isselected":@(NO)} mutableCopy],
                            ];
        
        _filterArr = [NSMutableArray arrayWithArray:array];
    }
    return _filterArr;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout* _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing =0  ;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _layout.itemSize = CGSizeMake(80, 80);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth, 80) collectionViewLayout:_layout];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        //注册cell
        [_collectionView registerClass:[FiterCameraCollectionViewCell class] forCellWithReuseIdentifier:FiterCameraCollectionViewCell.registerCellID];
    }
    return _collectionView;
}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 160, ScreenWidth, 160)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        //collectionView
        [_bottomView addSubview:self.collectionView];
        //照相的按钮
        UIButton *catchImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        catchImageBtn.frame = CGRectMake((ScreenWidth-60)/2, 160-70, 60, 60);
        [catchImageBtn addTarget:self action:@selector(capturePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [catchImageBtn setBackgroundImage:[UIImage imageNamed:@"takePic"] forState:UIControlStateNormal];
        [_bottomView addSubview:catchImageBtn];
        
        [_bottomView addSubview:self.savePicView];
        self.savePicView.alpha = 0;
        
    }
    return _bottomView;
}

- (UIView *)savePicView{
    if (!_savePicView) {
        _savePicView = [[UIView alloc] initWithFrame:self.bottomView.bounds];
        _savePicView.backgroundColor = [UIColor whiteColor];
        //返回的按钮
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(30, (160-80)/2, 80, 80);
        [backBtn addTarget:self action:@selector(photoBack:) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"picBack"] forState:UIControlStateNormal];
        [_savePicView addSubview:backBtn];
        
        //保存的按钮
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake(ScreenWidth -30-80, (160-80)/2, 80, 80);
        [saveBtn addTarget:self action:@selector(photoSave:) forControlEvents:UIControlEventTouchUpInside];
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
        [_savePicView addSubview:saveBtn];
    }
    return _savePicView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        // 缩放手势
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
        [_imageView addGestureRecognizer:pinchGestureRecognizer];
    }
    return _imageView;
}

@end

