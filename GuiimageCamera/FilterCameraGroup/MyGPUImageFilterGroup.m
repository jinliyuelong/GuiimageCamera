//
//  MyGPUImageFilterGroup.m
//  GuiimageCamera
//
//  Created by Liyanjun on 2018/12/26.
//  Copyright © 2018 hand. All rights reserved.
//

#import "MyGPUImageFilterGroup.h"


@implementation MyGPUImageFilterGroup
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}
- (void)initialization{
    //反色滤镜
   self.invertFilter = [[GPUImageColorInvertFilter alloc] init];
    //伽马线滤镜
   self.gammaFilter = [[GPUImageGammaFilter alloc]init];
    self.gammaFilter.gamma = 1.5;
    //曝光度滤镜
   self.exposureFilter = [[GPUImageExposureFilter alloc]init];
    self.exposureFilter.exposure = 0;
    //怀旧
    self.sepiaFilter = [[GPUImageSepiaFilter alloc] init];
    
    [self addGPUImageFilter:self.invertFilter];
    [self addGPUImageFilter:self.gammaFilter];
    [self addGPUImageFilter:self.exposureFilter];
    [self addGPUImageFilter:self.sepiaFilter];
    
}

#pragma mark 将滤镜加在FilterGroup中并且设置初始滤镜和末尾滤镜
- (void)addGPUImageFilter:(GPUImageFilter *)filter{
    [self addFilter:filter];
    GPUImageOutput<GPUImageInput> *newTerminalFilter = filter;
    NSInteger count = self.filterCount;
    if (count == 1)
    {
        //设置初始滤镜
        self.initialFilters = @[newTerminalFilter];
        //设置末尾滤镜
        self.terminalFilter = newTerminalFilter;
        
    } else
    {
        GPUImageOutput<GPUImageInput> *terminalFilter    = self.terminalFilter;
        NSArray *initialFilters                          = self.initialFilters;
        [terminalFilter addTarget:newTerminalFilter];
        //设置初始滤镜
        self.initialFilters = @[initialFilters[0]];
        //设置末尾滤镜
        self.terminalFilter = newTerminalFilter;
    }
}

@end
