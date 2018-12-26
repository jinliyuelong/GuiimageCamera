//
//  MyGPUImageFilterGroup.h
//  GuiimageCamera
//
//  Created by Liyanjun on 2018/12/26.
//  Copyright © 2018 hand. All rights reserved.
//

#import "GPUImageFilterGroup.h"
#import "GPUImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyGPUImageFilterGroup : GPUImageFilterGroup
@property (nonatomic, strong) GPUImageColorInvertFilter *invertFilter;//反色
@property (nonatomic, strong) GPUImageGammaFilter *gammaFilter;//伽马
@property (nonatomic, strong) GPUImageExposureFilter *exposureFilter;//曝光
@property (nonatomic, strong) GPUImageSepiaFilter *sepiaFilter;//怀旧
@end

NS_ASSUME_NONNULL_END
