//
//  MyGPUImageFilterGroup1.m
//  GuiimageCamera
//
//  Created by Liyanjun on 2018/12/26.
//  Copyright © 2018 hand. All rights reserved.
//

#import "MyGPUImageFilterGroup1.h"

@implementation MyGPUImageFilterGroup1
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}
- (void)initialization{
    //rgb
    self.rgbFileter = [[GPUImageRGBFilter alloc] init];
    self.rgbFileter.red = 0.5;
   //卡通
    self.toonFilter = [[GPUImageToonFilter alloc] init];
    [self addGPUImageFilter:self.rgbFileter];
    [self addGPUImageFilter:self.toonFilter];
    
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
