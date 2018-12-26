//
//  BeautyGPUImageFilterGroup.h
//  GuiimageCamera
//
//  Created by Liyanjun on 2018/12/26.
//  Copyright © 2018 hand. All rights reserved.
//

#import "GPUImageFilterGroup.h"
#import "GPUImage.h"
NS_ASSUME_NONNULL_BEGIN

@interface BeautyGPUImageFilterGroup : GPUImageFilterGroup
@property (nonatomic, strong) GPUImageBilateralFilter *bilaterFilter;//磨皮（双边模糊）
@property (nonatomic, strong) GPUImageExposureFilter *exposureFilter;//曝光
@property (nonatomic, strong) GPUImageBrightnessFilter *brightnessFilter;//美白 亮度
@property (nonatomic, strong) GPUImageSaturationFilter *saturationFilter;//饱和

@end

NS_ASSUME_NONNULL_END
