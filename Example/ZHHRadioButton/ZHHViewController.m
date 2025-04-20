//
//  ZHHViewController.m
//  ZHHRadioButton
//
//  Created by 桃色三岁 on 04/20/2025.
//  Copyright (c) 2025 桃色三岁. All rights reserved.
//

#import "ZHHViewController.h"
#import "ZHHRadioButton.h"

@interface ZHHViewController ()
@property (weak, nonatomic) ZHHRadioButton *waterButton;

@end

@implementation ZHHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // enable multiple selection for water, beer and wine buttons.
    self.waterButton.multipleSelectionEnabled = YES;
    // set selection states programmatically
    for (ZHHRadioButton *radioButton in self.waterButton.otherButtons) {
        radioButton.selected = YES;
    }
    
    // programmatically add button
    // first button
    CGRect frame = CGRectMake(self.view.frame.size.width / 2 - 131, 350, 262, 50);
    ZHHRadioButton *firstRadioButton = [self createRadioButtonWithFrame:frame
                                                                 title:@"红色按钮"
                                                                 color:[UIColor redColor]];
    
    // other buttons
    NSArray *colorNames = @[@"黑色按钮", @"橘色按钮", @"绿色按钮", @"蓝色按钮", @"紫色按钮"];
    NSArray *colors = @[[UIColor blackColor], [UIColor orangeColor], [UIColor greenColor], [UIColor blueColor], [UIColor purpleColor]];
    NSInteger i = 0;
    NSMutableArray *otherButtons = [NSMutableArray new];
    for (UIColor *color in colors) {
        CGRect frame = CGRectMake(self.view.frame.size.width / 2 - 131, 400 + 44 * i, 262, 32);
        ZHHRadioButton *radioButton = [self createRadioButtonWithFrame:frame
                                                                title:colorNames[i]
                                                                color:color];
        firstRadioButton.backgroundColor = UIColor.orangeColor;
        if (i % 2 == 0) {
            radioButton.iconSquare = YES;
        }
        if (i > 1) {
            // put icon on the right side
            radioButton.iconOnRight = YES;
            radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
        [otherButtons addObject:radioButton];
        i++;
    }
    
    firstRadioButton.iconImage = [UIImage imageNamed:@"icon_video_play"];
//    firstRadioButton.iconImageSelected = [UIImage imageNamed:@"icon_video_pause"];
    firstRadioButton.iconSize = CGSizeMake(44, 44);
    firstRadioButton.iconColor = UIColor.redColor;
    firstRadioButton.otherButtons = otherButtons;
    // set selection state programmatically
    firstRadioButton.otherButtons[1].selected = YES;
    firstRadioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    firstRadioButton.backgroundColor = UIColor.cyanColor;
    firstRadioButton.marginWidth = 35;
    firstRadioButton.titleLabel.font = [UIFont boldSystemFontOfSize:30];
}

#pragma mark - Helper

- (ZHHRadioButton *)createRadioButtonWithFrame:(CGRect) frame title:(NSString *)title color:(UIColor *)color {
    ZHHRadioButton *radioButton = [[ZHHRadioButton alloc] initWithFrame:frame];
    radioButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [radioButton setTitle:title forState:UIControlStateNormal];
    [radioButton setTitleColor:color forState:UIControlStateNormal];
    radioButton.iconColor = color;
    radioButton.indicatorColor = color;
    radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [radioButton addTarget:self action:@selector(logSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:radioButton];
    
    return radioButton;
}

- (IBAction)logSelectedButton:(ZHHRadioButton *)radioButton {
    if (radioButton.isMultipleSelectionEnabled) {
        for (ZHHRadioButton *button in radioButton.selectedButtons) {
            NSLog(@"%@ is selected.\n", button.titleLabel.text);
        }
    } else {
        NSLog(@"%@ is selected.\n", radioButton.selectedButton.titleLabel.text);
    }
}
@end
