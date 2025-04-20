//
//  ZHHRadioButton.m
//  ZHHRadioButton
//
//  Created by 桃色三岁 on 04/20/2025.
//  Copyright (c) 2025 桃色三岁. All rights reserved.
//

#import "ZHHRadioButton.h"

@interface ZHHRadioButton ()
@property (nonatomic, assign) CGSize defaultIconSize;                   // 图标默认大小
@property (nonatomic, assign) CGFloat defaultMarginWidth;               // 图标与文本间距
@property (nonatomic, assign) CFTimeInterval defaultAnimationDuration;  // 动画持续时间
@property (nonatomic, copy) NSString *generatedIconName;                // 默认生成的图标名称
@property (nonatomic, assign) BOOL groupModifing;                       // 是否正在批量修改按钮状态
@end

@implementation ZHHRadioButton

@synthesize otherButtons = _otherButtons;

- (void)setOtherButtons:(NSArray<ZHHRadioButton *> *)otherButtons {
    // 如果不是批量修改状态，则先设置批量修改模式，防止递归修改导致重复调用
    if (!self.groupModifing) {
        self.groupModifing = YES;

        // 逐个更新其他按钮的 `otherButtons` 属性，确保所有按钮的引用关系正确
        for (ZHHRadioButton *radioButton in otherButtons) {
            // 创建一个新的数组，包括所有 `otherButtons`，但排除当前 `radioButton`
            NSMutableArray *otherButtonsForCurrent = [otherButtons mutableCopy];
            [otherButtonsForCurrent addObject:self];   // 添加自身
            [otherButtonsForCurrent removeObject:radioButton]; // 移除当前按钮，防止循环引用

            radioButton.otherButtons = [otherButtonsForCurrent copy]; // 递归设置 `otherButtons`
        }

        self.groupModifing = NO;// 结束批量修改模式
    }

    // 使用 NSValue 进行非强引用存储，防止循环引用导致的内存泄漏
    NSMutableArray *weakOtherButtons = [NSMutableArray arrayWithCapacity:otherButtons.count];
    for (ZHHRadioButton *radioButton in otherButtons) {
        [weakOtherButtons addObject:[NSValue valueWithNonretainedObject:radioButton]];
    }
    
    _otherButtons = [weakOtherButtons copy]; // 赋值为不可变数组，防止外部修改
}

- (NSArray<ZHHRadioButton *> *)otherButtons {
    if (_otherButtons.count > 0) {
        NSMutableArray<ZHHRadioButton *> *buttons = [NSMutableArray arrayWithCapacity:_otherButtons.count];
        
        // 将 NSValue 存储的非强引用对象取出
        for (NSValue *value in _otherButtons) {
            ZHHRadioButton *radioButton = [value nonretainedObjectValue];
            if (radioButton) { // 过滤已释放的对象
                [buttons addObject:radioButton];
            }
        }
        return [buttons copy]; // 返回不可变数组，确保外部不会修改
    }
    return @[]; // 返回空数组，而不是 nil，避免调用方需要额外判断 nil
}

- (void)setIconImage:(UIImage *)iconImage {
    _iconImage = iconImage;
    [self setImage:iconImage forState:UIControlStateNormal]; // 直接使用传入的 icon 避免不必要的 self 访问
}

- (void)setIconImageSelected:(UIImage *)iconImageSelected {
    _iconImageSelected = iconImageSelected;
    [self setImage:iconImageSelected forState:UIControlStateSelected];
    [self setImage:iconImageSelected forState:UIControlStateSelected | UIControlStateHighlighted];
}

- (void)setMultipleSelectionEnabled:(BOOL)multipleSelectionEnabled {
    if (_multipleSelectionEnabled != multipleSelectionEnabled) { // 避免不必要的重复赋值
        if (!self.groupModifing) {
            self.groupModifing = YES;

            // 同步所有其他按钮的 `multipleSelectionEnabled` 状态
            for (ZHHRadioButton *radioButton in self.otherButtons) {
                radioButton.multipleSelectionEnabled = multipleSelectionEnabled;
            }

            self.groupModifing = NO;
        }
        _multipleSelectionEnabled = multipleSelectionEnabled;
    }
}

- (void)setAnimationDuration:(CFTimeInterval)animationDuration {
    if (_animationDuration != animationDuration) { // 避免重复赋值
        if (!self.groupModifing) {
            self.groupModifing = YES;

            // 同步所有关联按钮的 `animationDuration`，确保组内一致
            for (ZHHRadioButton *radioButton in self.otherButtons) {
                radioButton.animationDuration = animationDuration;
            }
            self.groupModifing = NO;// 结束批量修改模式
        }
        _animationDuration = animationDuration;
    }
}

#pragma mark - Helpers

- (void)drawButton {
    // 自动生成图标（未设置或标记为默认生成）
    if (!self.iconImage || [self.iconImage.accessibilityIdentifier isEqualToString:self.generatedIconName]) {
        self.iconImage = [self drawIconWithSelection:NO];
    }
    if (!self.iconImageSelected || [self.iconImageSelected.accessibilityIdentifier isEqualToString:self.generatedIconName]) {
        self.iconImageSelected = [self drawIconWithSelection:YES];
    }

    // 图标与文字间距
    CGFloat margin = self.marginWidth;

    // 判断是否为 RTL 布局
    BOOL isRTL = ([UIView userInterfaceLayoutDirectionForSemanticContentAttribute:self.semanticContentAttribute] == UIUserInterfaceLayoutDirectionRightToLeft);

    CGSize iconSize = self.iconImage.size;
    CGFloat iconWidth = iconSize.width;

    if (self.isIconOnRight) {
        // 图标在右侧
        self.imageEdgeInsets = isRTL ?
            UIEdgeInsetsMake(0, 0, 0, self.frame.size.width - iconWidth) :
            UIEdgeInsetsMake(0, self.frame.size.width - iconWidth, 0, 0);

        self.titleEdgeInsets = isRTL ?
            UIEdgeInsetsMake(0, margin + iconWidth, 0, -iconWidth) :
            UIEdgeInsetsMake(0, -iconWidth, 0, margin + iconWidth);
    } else {
        // 图标在左侧（默认）
        if (isRTL) {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, margin, 0, 0);
            self.titleEdgeInsets = UIEdgeInsetsZero;
        } else {
            self.imageEdgeInsets = UIEdgeInsetsZero;
            self.titleEdgeInsets = UIEdgeInsetsMake(0, margin, 0, 0);
        }
    }
}

- (UIImage *)drawIconWithSelection:(BOOL)selected {
    // 选择合适的颜色
    UIColor *defaulColor = selected ? [self titleColorForState:UIControlStateSelected | UIControlStateHighlighted] : [self titleColorForState:UIControlStateNormal];
    UIColor *iconColor = self.iconColor ?: defaulColor;
    UIColor *indicatorColor = self.indicatorColor ?: defaulColor;
    
    CGFloat iconStrokeWidth = self.iconStrokeWidth ?: self.iconSize.width / 9;
    CGFloat indicatorSize = self.indicatorSize ?: self.iconSize.height * 0.5;
    
    // 绘制区域
    CGRect rect = CGRectMake(0, 0, self.iconSize.width, self.iconSize.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);

    // 绘制图标
    UIBezierPath *iconPath;
    CGRect iconRect = CGRectMake(iconStrokeWidth / 2, iconStrokeWidth / 2, self.iconSize.width - iconStrokeWidth, self.iconSize.height - iconStrokeWidth);
    if (self.isIconSquare) {
        iconPath = [UIBezierPath bezierPathWithRect:iconRect];
    } else {
        iconPath = [UIBezierPath bezierPathWithOvalInRect:iconRect];
    }
    [iconColor setStroke];
    iconPath.lineWidth = iconStrokeWidth;
    [iconPath stroke];
    
    // 绘制指示器（选中状态时）
    if (selected) {
        UIBezierPath *indicatorPath;
        CGRect indicatorRect = CGRectMake((self.iconSize.width - indicatorSize) / 2, (self.iconSize.height - indicatorSize) / 2, indicatorSize, indicatorSize);
        if (self.isIconSquare) {
            indicatorPath = [UIBezierPath bezierPathWithRect:indicatorRect];
        } else {
            indicatorPath = [UIBezierPath bezierPathWithOvalInRect:indicatorRect];
        }
        [indicatorColor setFill];
        [indicatorPath fill];
    }
    
    // 获取生成的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 设置图片的辅助标识
    image.accessibilityIdentifier = self.generatedIconName;
    return image;
}

- (void)touchUpInside {
    if (self.isMultipleSelectionEnabled) {
        // 切换选中状态
        [self setSelected:!self.isSelected];
    } else {
        // 单选时直接选中
        [self setSelected:YES];
    }
}

- (void)initRadioButton {
    _defaultIconSize = CGSizeMake(15, 15);
    _defaultMarginWidth = 5.0;                  // 图标与文本间距
    _defaultAnimationDuration = 0.3;            // 动画持续时间
    _generatedIconName = @"Generated Icon";     // 默认生成的图标名称
    _groupModifing = NO;                        // 是否正在批量修改按钮状态
    
    // 设置默认值
    _iconSize = self.defaultIconSize;
    _marginWidth = self.defaultMarginWidth;
    _animationDuration = self.defaultAnimationDuration;
    
    // 注册点击事件
    [super addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - NSObject

- (void)prepareForInterfaceBuilder {
    [self initRadioButton];  // 初始化按钮设置
    [self drawButton];       // 绘制按钮图标
}

#pragma mark - ZHHRadioButton

// 取消其他按钮的选中状态
- (void)deselectOtherButtons {
    for (UIButton *button in self.otherButtons) {
        [button setSelected:NO];  // 取消选中
    }
}

- (ZHHRadioButton *)selectedButton {
    // 如果不支持多选，检查当前按钮是否选中
    if (!self.isMultipleSelectionEnabled) {
        if (self.selected) {
            return self; // 当前按钮被选中，返回自己
        } else {
            // 如果当前按钮未选中，检查其他按钮
            for (ZHHRadioButton *radioButton in self.otherButtons) {
                if (radioButton.selected) {
                    return radioButton; // 返回第一个选中的按钮
                }
            }
        }
    }
    return nil; // 没有按钮被选中
}

- (NSArray *)selectedButtons {
    // 存储选中的按钮
    NSMutableArray *selectedButtons = [[NSMutableArray alloc] init];
    
    // 如果当前按钮选中，添加到选中按钮数组
    if (self.selected) {
        [selectedButtons addObject:self];
    }
    
    // 检查其他按钮，添加选中的按钮
    for (ZHHRadioButton *radioButton in self.otherButtons) {
        if (radioButton.selected) {
            [selectedButtons addObject:radioButton];
        }
    }
    
    return selectedButtons; // 返回所有选中的按钮
}

#pragma mark - UIButton

- (UIColor *)titleColorForState:(UIControlState)state {
    if (state == (UIControlStateSelected | UIControlStateHighlighted)) {
        UIColor *color = [super titleColorForState:state];
        if (!color) {
            // 优先取 Selected，其次取 Highlighted
            UIColor *fallbackColor = [super titleColorForState:UIControlStateSelected];
            if (!fallbackColor) {
                fallbackColor = [super titleColorForState:UIControlStateHighlighted];
            }

            if (fallbackColor) {
                [self setTitleColor:fallbackColor forState:state];
                return fallbackColor;
            }
        }
        return color;
    }

    return [super titleColorForState:state];
}

#pragma mark - UIControl

- (void)setSelected:(BOOL)selected {
    if ((self.isMultipleSelectionEnabled ||
         (selected != self.isSelected &&
          [self.iconImage.accessibilityIdentifier isEqualToString:self.generatedIconName] &&
          [self.iconImageSelected.accessibilityIdentifier isEqualToString:self.generatedIconName])) &&
        self.animationDuration > 0.0) {
        // 为了增强代码的可读性，将动画的设置逻辑提取为独立的代码块
        [self addSelectionAnimation:selected];
    }
    
    [super setSelected:selected];
    
    // 单选模式下选中按钮时，取消其他按钮的选中状态
    if (!self.isMultipleSelectionEnabled && selected) {
        [self deselectOtherButtons];
    }
}

- (void)addSelectionAnimation:(BOOL)selected {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"contents"];
    animation.duration = self.animationDuration;

    if (self.isSelected) {
        animation.fromValue = (id)self.iconImageSelected.CGImage;
        animation.toValue = (id)self.iconImage.CGImage;
    } else {
        animation.fromValue = (id)self.iconImage.CGImage;
        animation.toValue = (id)self.iconImageSelected.CGImage;
    }

    [self.imageView.layer addAnimation:animation forKey:@"icon"];
}

#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initRadioButton]; // 初始化按钮设置r
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initRadioButton]; // 初始化按钮设置
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect]; // 调用父类方法
    [self drawButton]; // 绘制按钮
}

@end
