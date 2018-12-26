//
//  FiterCameraCollectionViewCell.m
//  GuiimageCamera
//
//  Created by Liyanjun on 2018/12/25.
//  Copyright © 2018 hand. All rights reserved.
//

#import "FiterCameraCollectionViewCell.h"
static NSString* const CollectionCellId=@"FiterCameraCollectionViewCellId";
@interface FiterCameraCollectionViewCell()
@end
@implementation FiterCameraCollectionViewCell
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self ) {
        [ self initialization ];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}
#pragma mark - 初始化
- (void)initialization{
    [self setupUi];
}
#pragma mark -- setupUi
- (void)setupUi{
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.textLabel];
    
    self.contentView.layer.borderWidth = 0.5;
    self.contentView.layer.cornerRadius = 3;
      self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;

}

#pragma mark - 类方法
+ (NSString*)registerCellID
{
    return CollectionCellId;
}
- (void)setIsselected:(BOOL)isselected{
    self.contentView.backgroundColor =  isselected?RGB_COLOR(36, 141, 245):[UIColor whiteColor];
}


- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        _textLabel.numberOfLines = 0;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.font = [UIFont systemFontOfSize: 12];
    }
    return _textLabel;
}
@end
