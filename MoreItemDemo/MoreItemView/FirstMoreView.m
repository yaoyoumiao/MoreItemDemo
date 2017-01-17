//
//  FirstMoreView.m
//  Sina
//
//  Created by yaoyoumiao on 16/8/23.
//  Copyright © 2016年 ZTE. All rights reserved.
//

#import "FirstMoreView.h"
//#import "UIView+SinaView.h"

#define kWidth 140
#define kHeight 176
#define kCellHeight 40

#pragma mark -
#pragma mark - FirstMoreModel
@interface FirstMoreModel : NSObject

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *title;

@end

@implementation FirstMoreModel

@end

#pragma mark -
#pragma mark - FirstMoreCell
@interface FirstMoreCell : UITableViewCell

@property (nonatomic, strong) UIImageView    *myImageView;
@property (nonatomic, strong) UILabel        *myLabel;
@property (nonatomic, strong) CALayer        *lineLayer;
@property (nonatomic, strong) NSIndexPath    *indexPath;
@property (nonatomic, strong) FirstMoreModel *model;

@end

@implementation FirstMoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self configure];
    }
    return self;
}

- (void)configure
{
    self.backgroundColor = [UIColor clearColor];
    
    _myImageView = [[UIImageView alloc] init];
    
    _myLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 80, kCellHeight)];
    _myLabel.textColor = [UIColor whiteColor];
    _myLabel.font = [UIFont systemFontOfSize:14];
    
    _lineLayer = [CALayer layer];
    _lineLayer.frame = CGRectMake(13, 0, kWidth - 40, 0.5);
    _lineLayer.backgroundColor = [[[UIColor whiteColor] colorWithAlphaComponent:0.3] CGColor];
    
    [self.contentView addSubview:_myImageView];
    [self.contentView addSubview:_myLabel];
    [self.contentView.layer addSublayer:_lineLayer];
}

- (void)setModel:(FirstMoreModel *)model
{
    UIImage *image = [UIImage imageNamed:model.imageName];
    _myImageView.image = image;
    _myImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    _myImageView.center = CGPointMake(kCellHeight / 2 + 8, kCellHeight / 2);
    _myLabel.text = model.title;
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    if(indexPath.row == 0) {
        _lineLayer.hidden = YES;
    } else {
        _lineLayer.hidden = NO;
    }
}
@end

#pragma mark -
#pragma mark - FirstMoreView
@interface FirstMoreView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView       *myTableView;
@property (nonatomic, strong) UIImageView       *bgImageView;
@property (nonatomic, strong) NSMutableArray    *models;

@end

@implementation FirstMoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self configure];
    }
    return self;
}

- (void)configure
{
    NSArray *images = @[@"contacts_add_newmessage",
                        @"contacts_add_friend",
                        @"contacts_add_scan",
                        @"contacts_add_scan"];
    NSArray *titles = @[@"发起群聊",
                        @"添加朋友",
                        @"扫一扫",
                        @"收付款"];
    _models = [NSMutableArray new];
    for(NSInteger i = 0; i < titles.count; i++) {
        FirstMoreModel *model = [FirstMoreModel new];
        model.title = titles[i];
        model.imageName = images[i];
        [_models addObject:model];
    }
    [self addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.myTableView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(self.dismissBlock) {
        self.dismissBlock();
    }
}

#pragma mark - lazy load
- (UIImageView *)bgImageView
{
    if(!_bgImageView) {
        UIImage *originImage = [UIImage imageNamed:@"MoreFunctionFrame"];
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - kWidth, 0, kWidth, kHeight)];
        _bgImageView.image = [originImage stretchableImageWithLeftCapWidth:originImage.size.width / 2 topCapHeight:originImage.size.height / 2];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.clipsToBounds = YES;
    }
    return _bgImageView;
}

- (UITableView *)myTableView
{
    if(!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(6, 10, _bgImageView.frame.size.width - 12, _bgImageView.frame.size.height - 11) style:UITableViewStylePlain];
        _myTableView.backgroundColor = [UIColor clearColor];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.rowHeight = kCellHeight;
        _myTableView.scrollEnabled = NO;
        _myTableView.separatorColor = [UIColor grayColor];
        _myTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _myTableView.tableFooterView = [UIView new];
    }
    return _myTableView;
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"FirstMoreCell";
    FirstMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FirstMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.model = _models[indexPath.row];
    }
    UIView *bgView = [[UIView alloc] initWithFrame:cell.bounds];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
    cell.selectedBackgroundView = bgView;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.indexPath = indexPath;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FirstMoreModel *model = _models[indexPath.row];
    if(self.selectedItemBlock) {
        self.selectedItemBlock(indexPath.row, model.title);
    }
}

#pragma mark - dismiss
- (void)dismissMoreView
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CATransform3D transform = CATransform3DMakeScale(0.5, 0.5, 10);
        _bgImageView.layer.transform = transform;
        _bgImageView.layer.position = CGPointMake(_bgImageView.frame.origin.x + _bgImageView.frame.size.width - 15, _bgImageView.frame.origin.y);
        _bgImageView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dealloc
{
    NSLog(@"dealloc %@", NSStringFromClass([self class]));
}
@end
