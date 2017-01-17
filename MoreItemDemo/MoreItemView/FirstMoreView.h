//
//  FirstMoreView.h
//  Sina
//
//  Created by yaoyoumiao on 16/8/23.
//  Copyright © 2016年 ZTE. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedItemBlock)(NSInteger index, NSString *itemString);
typedef void(^DismissBlock)();
@interface FirstMoreView : UIView

/**
 *  微信发起群聊的入口按钮
 */
@property (nonatomic, copy) DismissBlock dismissBlock;
@property (nonatomic, copy) SelectedItemBlock selectedItemBlock;

- (void)dismissMoreView;

@end
