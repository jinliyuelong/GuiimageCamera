//
//  FiterCameraCollectionViewCell.h
//  GuiimageCamera
//
//  Created by Liyanjun on 2018/12/25.
//  Copyright © 2018 hand. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FiterCameraCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *textLabel;
+ (NSString*)registerCellID;
@property (nonatomic, assign)  BOOL  isselected;//是否被选中
@end

NS_ASSUME_NONNULL_END
