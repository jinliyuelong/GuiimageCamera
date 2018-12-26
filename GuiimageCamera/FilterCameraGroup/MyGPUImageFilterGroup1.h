//
//  MyGPUImageFilterGroup1.h
//  GuiimageCamera
//
//  Created by Liyanjun on 2018/12/26.
//  Copyright © 2018 hand. All rights reserved.
//

#import "GPUImageFilterGroup.h"
#import "GPUImage.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyGPUImageFilterGroup1 : GPUImageFilterGroup
@property (nonatomic, strong) GPUImageRGBFilter *rgbFileter;
@property (nonatomic, strong) GPUImageToonFilter *toonFilter;
@end

NS_ASSUME_NONNULL_END
