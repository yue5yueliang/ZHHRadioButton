//
//  ZHHRadioButton.h
//  ZHHRadioButton
//
//  Created by 桃色三岁 on 04/20/2025.
//  Copyright (c) 2025 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 一个高度可定制的 iOS 单选按钮 (Radio Button) 组件。
 */
IB_DESIGNABLE
NS_ASSUME_NONNULL_BEGIN

@interface ZHHRadioButton : UIButton

#pragma mark - 访问按钮组

/// 获取当前组中被选中的按钮（单选模式）。
- (nullable ZHHRadioButton *)selectedButton;

/// 获取当前组中所有被选中的按钮（多选模式）。
- (NSArray<ZHHRadioButton *> *)selectedButtons;

/// 其他属于同一组的单选按钮。
@property (nonatomic) IBOutletCollection(ZHHRadioButton) NSArray<ZHHRadioButton *> *otherButtons;

/// 取消当前组中其他按钮的选中状态。
- (void)deselectOtherButtons;

#pragma mark - UI 自定义

/// 图标尺寸，默认 `15.0`。
@property (nonatomic) IBInspectable CGSize iconSize;

/// 图标颜色，默认与 `UIControlStateNormal` 颜色一致。
@property (nonatomic) IBInspectable UIColor *iconColor;

/// 图标的边框宽度，默认 `iconSize / 9`。
@property (nonatomic) IBInspectable CGFloat iconStrokeWidth;

/// 选中指示器的大小，默认 `iconSize * 0.5`。
@property (nonatomic) IBInspectable CGFloat indicatorSize;

/// 选中指示器的颜色，默认与 `UIControlStateSelected` 颜色一致。
@property (nonatomic) IBInspectable UIColor *indicatorColor;

/// 图标与文本的间距，默认 `5.0`。
@property (nonatomic) IBInspectable CGFloat marginWidth;


/// 图标是否显示在右侧，默认 `NO`。
@property (nonatomic, getter=isIconOnRight) IBInspectable BOOL iconOnRight;

/// 是否使用方形图标，默认 `NO`。
@property (nonatomic, getter=isIconSquare) IBInspectable BOOL iconSquare;

/// 自定义图标（可选）。
@property (nonatomic) IBInspectable UIImage *iconImage;

/// 选中状态下的自定义图标（可选）。
@property (nonatomic) IBInspectable UIImage *iconImageSelected;

/// 是否允许多选，默认 `NO`。
@property (nonatomic, getter=isMultipleSelectionEnabled) BOOL multipleSelectionEnabled;

/// 按钮动画持续时间（秒），默认 `0.3`，设为 `0.0` 关闭动画。
@property (nonatomic) CFTimeInterval animationDuration;

@end
NS_ASSUME_NONNULL_END
