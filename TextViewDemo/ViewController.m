//
//  ViewController.m
//  TextViewDemo
//
//  Created by 井庆林 on 16/7/27.
//  Copyright © 2016年 JingQL. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "TZImagePickerController.h"
#import "YYText.h"
#import "YYImage.h"
#import "JQLImageView.h"
#import "MHEditTitleWindow.h"
#import "ImageModel.h"
#import "RTDragCellTableView.h"
#import "MHStringTableViewCell.h"
#import "MHImageTableViewCell.h"

#define IMAGE_WIDTH ([UIScreen mainScreen].bounds.size.width - 10.0)

@interface ViewController () <UITextViewDelegate, TZImagePickerControllerDelegate, YYTextViewDelegate, RTDragCellTableViewDelegate, RTDragCellTableViewDataSource, JQLImageViewDataSource>

@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, strong) MHEditTitleWindow *editTitleView;

@property (nonatomic, assign) NSRange textViewRange;
//@property (nonatomic, strong) NSArray<YYTextAttachment *> *attachments;
//@property (nonatomic, strong) NSArray *attachmentRanges;

@property (nonatomic, strong) RTDragCellTableView *moveTableView;
@property (nonatomic, strong) NSArray *moveArray;


@end

@implementation ViewController

static NSString *stringCellIdentifier = @"stringCellIdentifier";
static NSString *imageCellIdentifier = @"imageCellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _moveArray = [NSMutableArray new];
    
    _textView = [[YYTextView alloc] init];
    _textView.delegate = self;
    _textView.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _textView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(@(500));
        make.top.equalTo(self.view).offset(64);
        make.leading.equalTo(self.view);
    }];
    
    UIButton *addImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [addImage setTitle:@"添加图片" forState:UIControlStateNormal];
    addImage.backgroundColor = [UIColor grayColor];
    [addImage addTarget:self action:@selector(p_addImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addImage];
    [addImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@40);
        make.top.equalTo(self.view).offset(20);
        make.leading.equalTo(self.view).offset(40);
    }];
    UIButton *post = [UIButton buttonWithType:UIButtonTypeCustom];
    [post setTitle:@"Post" forState:UIControlStateNormal];
    post.backgroundColor = [UIColor grayColor];
    [post addTarget:self action:@selector(p_post) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:post];
    [post mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@40);
        make.top.equalTo(self.view).offset(20);
        make.trailing.equalTo(self.view).offset(-40);
    }];
    
    [self p_setData:@"sss\n<img full_url=\"https://dn-qinqinwojia.qbox.me/Fo1cGsOJ-QArC4-pH9-PoG1nfHKo\" abbr_url=\"\" caption=\"\" />\ns\n<img full_url=\"https://dn-qinqinwojia.qbox.me/Fo1cGsOJ-QArC4-pH9-PoG1nfHKo\" abbr_url=\"\" caption=\"haha\" />\n<img full_url=\"https://dn-qinqinwojia.qbox.me/Fo1cGsOJ-QArC4-pH9-PoG1nfHKo\" abbr_url=\"\" caption=\"\" />\nddd"];
}

- (void)p_addImage {
    _textViewRange = _textView.selectedRange;
    TZImagePickerController *controller = [[TZImagePickerController alloc] initWithMaxImagesCount:5 delegate:self];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)p_post {
    NSMutableArray *postArray = [[self p_trimIsMove:NO] mutableCopy];
    for (int i = 0; i < postArray.count; i++) {
        if ([postArray[i] isKindOfClass:[ImageModel class]]) {
            ImageModel *model = postArray[i];
            NSString *full = @"https://dn-qinqinwojia.qbox.me/Fo1cGsOJ-QArC4-pH9-PoG1nfHKo";
            NSString *abbr = @"https://dn-qinqinwojia.qbox.me/Fo1cGsOJ-QArC4-pH9-PoG1nfHKo/222";
            NSString *title = model.title;
            NSString *imageStr = [NSString stringWithFormat:@"<img full_url=\"%@\" abbr_url=\"%@\" caption=\"%@\" />", full, abbr, title];
            postArray[i] = imageStr;
        }
    }
    NSMutableString *postString = [NSMutableString new];
    for (int i = 0; i < postArray.count; i++) {
        if (i == 0) [postString appendString:postArray[i]];
        else [postString appendFormat:@"\n%@", postArray[i]];
    }
    NSLog(@"%@", postString);
}

- (void)p_setData:(NSString *)data {
    NSMutableAttributedString *contentText = [NSMutableAttributedString new];
    NSArray *attributedStringArr = [data componentsSeparatedByString:@"<img full_url=\""];
    for (int i = 0; i < attributedStringArr.count ; i ++) {
        NSString *string = attributedStringArr[i];
        if ([string rangeOfString:@"/>"].location == NSNotFound) {
            [contentText appendAttributedString:[[NSAttributedString alloc] initWithString:string]];
        } else {
            NSArray *titleArray = [string componentsSeparatedByString:@"\" />"];
            for (int i = 0; i < titleArray.count; i++) {
                if (i == 0) {
                    JQLImageView *imageView = [[JQLImageView alloc] initWithDataSourece:self];
                    imageView.title = [titleArray[i] componentsSeparatedByString:@"\" caption=\""][1];
                    imageView.image = [titleArray[i] componentsSeparatedByString:@"\""][0];
                    imageView.location = contentText.length;
                    contentText = [[self p_textViewAttributedText:imageView contentText:contentText index:contentText.length originPoint:[_textView caretRectForPosition:_textView.selectedTextRange.start].origin isData:YES] mutableCopy];
                } else {
                    [contentText appendAttributedString:[[NSAttributedString alloc] initWithString:titleArray[i]]];
    }}}}
    _textView.attributedText = contentText;
}

- (void)p_longPressGestureRecognized:(id)sender{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;
    //手指在tableView中的位置
    _moveTableView.fingerLocation = [longPress locationInView:_moveTableView];
    //手指按住位置对应的indexPath，可能为nil
    _moveTableView.relocatedIndexPath = [_moveTableView indexPathForRowAtPoint:_moveTableView.fingerLocation];
    switch (longPressState) {
        case UIGestureRecognizerStateBegan:{  //手势开始，对被选中cell截图，隐藏原cell
            _moveTableView.originalIndexPath = [_moveTableView indexPathForRowAtPoint:_moveTableView.fingerLocation];
            if (_moveTableView.originalIndexPath) {
                _moveTableView.firstIndexPath = _moveTableView.originalIndexPath;
                [_moveTableView cellSelectedAtIndexPath:_moveTableView.originalIndexPath];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{//点击位置移动，判断手指按住位置是否进入其它indexPath范围，若进入则更新数据源并移动cell
            //截图跟随手指移动
            CGPoint center = _moveTableView.snapshot.center;
            center.y = _moveTableView.fingerLocation.y;
            _moveTableView.snapshot.center = center;
            if ([_moveTableView checkIfSnapshotMeetsEdge]) {
                [_moveTableView startAutoScrollTimer];
            }else{
                [_moveTableView stopAutoScrollTimer];
            }
            //手指按住位置对应的indexPath，可能为nil
            _moveTableView.relocatedIndexPath = [_moveTableView indexPathForRowAtPoint:_moveTableView.fingerLocation];
            if (_moveTableView.relocatedIndexPath && ![_moveTableView.relocatedIndexPath isEqual:_moveTableView.originalIndexPath]) {
                [_moveTableView cellRelocatedToNewIndexPath:_moveTableView.relocatedIndexPath];
            }
            break;
        }
        default: {                             //长按手势结束或被取消，移除截图，显示cell
            [_moveTableView stopAutoScrollTimer];
            [_moveTableView didEndDraging];
            break;
        }
    }
}

#pragma mark - JQLImageView Action
- (void)p_move:(JQLImageView *)imageView longPress:(UILongPressGestureRecognizer *)longPress {
    CGFloat tableViewHeight = 0.0;
    CGFloat rowPointY = 0.0;
    if (longPress.state == UIGestureRecognizerStateBegan) {
        _moveArray = [self p_trimIsMove:YES];
        if (!_moveTableView) {
            _moveTableView = [[RTDragCellTableView alloc] init];
            _moveTableView.sectionHeaderHeight = 0.0;
            _moveTableView.sectionFooterHeight = 0.0;
            _moveTableView.allowsSelection = YES;
            _moveTableView.delegate = self;
            _moveTableView.dataSource = self;
            _moveTableView.frame = _textView.frame;
            [_moveTableView registerClass:[MHStringTableViewCell class] forCellReuseIdentifier:stringCellIdentifier];
            [_moveTableView registerClass:[MHImageTableViewCell class] forCellReuseIdentifier:imageCellIdentifier];
            [self.view addSubview:_moveTableView];
        } else {
            _moveTableView.hidden = NO;
            _moveTableView.contentOffset = CGPointZero;
            [_moveTableView reloadData];
        }
        NSInteger row = 0;
        for (int i = 0; i < _moveArray.count; i++) {
            if ([_moveArray[i] isKindOfClass:[JQLImageView class]]) {
                JQLImageView *image = _moveArray[i];
                if ([image.uuid isEqualToString:imageView.uuid]) {
                    row = i;
                    rowPointY = tableViewHeight;
                }
                tableViewHeight += 60;
            } else {
                tableViewHeight += 30;
            }
        }
        CGPoint pressPoint = [longPress locationInView:_moveTableView];
        
        NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
        CGRect rect = [_moveTableView rectForRowAtIndexPath:rowIndexPath];
        [_moveTableView setContentOffset:CGPointMake(0, rect.origin.y - pressPoint.y + 20)];
    }
    [self p_longPressGestureRecognized:longPress];
}

- (void)p_editImageViewTitle:(JQLImageView *)imageView point:(CGPoint)point {
    if (!_editTitleView) {
        _editTitleView = [[MHEditTitleWindow alloc] init];
    }
    _editTitleView.title = imageView.title;
    __weak typeof(self) weakSelf = self;
    [_editTitleView setAlertCancelBlock:nil ConfirmBlock:^(NSString *title) {
        imageView.title = title;
        [weakSelf p_deleteImageView:imageView];
        NSMutableAttributedString *contentText = [weakSelf.textView.attributedText mutableCopy];
        contentText = [[weakSelf p_textViewAttributedText:imageView contentText:contentText index:imageView.location - 1 originPoint:point isData:NO] mutableCopy];
        if (weakSelf.editTitleView.title && ![weakSelf.editTitleView.title isEqualToString:@""]) {
            [contentText replaceCharactersInRange:NSMakeRange(imageView.location - 1, 1) withAttributedString:[[NSAttributedString alloc] initWithString:@""]];
        }
        weakSelf.textView.attributedText = contentText;
    }];
    [_editTitleView show];
    
}

- (void)p_deleteImageView:(JQLImageView *)imageView {
    NSMutableAttributedString *text = [_textView.attributedText mutableCopy];
    for (int i = 0; i < _textView.textLayout.attachments.count; i++) {
        YYTextAttachment *attachment = _textView.textLayout.attachments[i];
        JQLImageView *attachmentImageView = attachment.content;
        if (attachmentImageView.uuid == imageView.uuid) {
            [text replaceCharactersInRange:NSMakeRange([_textView.textLayout.attachmentRanges[i] rangeValue].location, 2) withAttributedString:[[NSAttributedString alloc] initWithString:@""]];
        }
    }
    _textView.attributedText = text;
}

#pragma mark - trim
- (NSArray *)p_trimIsMove:(BOOL)isMove {
    NSInteger currentIndex = 0;
    NSString *dataString = _textView.attributedText.string;
    NSMutableArray *data = [[dataString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] mutableCopy];
    NSMutableArray *result = [NSMutableArray new];
    for (int i = 0; i < data.count; i++) {
        BOOL isChangedIndex = NO;
        int attachmentIndex = 0;
        for (int j = attachmentIndex; j < _textView.textLayout.attachmentRanges.count; j++) {
//            NSLog(@"%d: %3ld !==== %3ld", i, currentIndex, [_textView.textLayout.attachmentRanges[j] rangeValue].location);
            if ([_textView.textLayout.attachmentRanges[j] rangeValue].location == currentIndex) {
                JQLImageView *imageView = _textView.textLayout.attachments[j].content;
                if (!isChangedIndex) {
                    if (isMove) {
                        [result addObject:imageView];
                    } else {
                        ImageModel *model = [ImageModel new];
                        model.image = imageView.image;
                        if (imageView.title) model.title = imageView.title;
                        [result addObject:model];
                    }
                    currentIndex += 2;
                    isChangedIndex = YES;
                    attachmentIndex ++;
                }
            }
        }
        if (!isChangedIndex) {
            NSString *string = data[i];
            currentIndex += string.length + 1;
            if (![string isEqualToString:@""]) {
                [result addObject:string];
            }
        }
    }
    return result;
}

#pragma mark - Move Table View Delegate
- (void)tableView:(RTDragCellTableView *)tableView newArrayDataForDataSource:(NSArray *)newArray {
    _moveArray = newArray;
}

- (void)didFinishDragingTableView:(RTDragCellTableView *)tableView isMovedIndexPath:(NSIndexPath *)isMovedIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    _moveTableView.hidden = YES;
    NSMutableAttributedString *contentText = [NSMutableAttributedString new];
    for (int i = 0; i < _moveArray.count; i++) {
        if ([_moveArray[i] isKindOfClass:[JQLImageView class]]) {
            JQLImageView *imageView = _moveArray[i];
            imageView.location = contentText.length;
            contentText = [[self p_textViewAttributedText:imageView contentText:contentText index:contentText.length originPoint:[_textView caretRectForPosition:_textView.selectedTextRange.start].origin isData:YES] mutableCopy];
        } else {
            [contentText appendAttributedString:[[NSAttributedString alloc] initWithString:_moveArray[i]]];
        }
        if (i != _moveArray.count - 1) [contentText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    }
    _textView.attributedText = contentText;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if ([_moveArray[row] isKindOfClass:[JQLImageView class]]) return 60;
    else return 30;
}

#pragma mark - Move Table View DataSource
- (NSArray *)originalArrayDataForTableView:(RTDragCellTableView *)tableView {
    return _moveArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _moveArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if ([_moveArray[row] isKindOfClass:[JQLImageView class]]) {
        MHImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:imageCellIdentifier];
        JQLImageView *imageView = _moveArray[row];
        cell.image.image = imageView.image;
        return cell;
    }
    else {
        MHStringTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stringCellIdentifier];
        cell.stringLabel.text = _moveArray[row];
        return cell;
    }
}

#pragma mark - TZImage Picker Controller Delegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {

    NSMutableAttributedString *contentText = [_textView.attributedText mutableCopy];
    for (NSInteger i = photos.count - 1; i >= 0; i--) {
        JQLImageView *imageView = [[JQLImageView alloc] initWithDataSourece:self];
        imageView.image = photos[i];
        imageView.location = _textViewRange.location + i * 2 + 1;
        contentText = [[self p_textViewAttributedText:imageView contentText:contentText index:_textViewRange.location originPoint:[_textView caretRectForPosition:_textView.selectedTextRange.start].origin isData:NO] mutableCopy];
    }
    [contentText insertAttributedString:[[NSAttributedString alloc] initWithString:@"\n"] atIndex:_textViewRange.location + photos.count * 2];
    _textView.attributedText = contentText;
}

#pragma mark - YYTextView Get Attributed String
- (NSAttributedString *)p_textViewAttributedText:(id)attribute contentText:(NSAttributedString *)attributeString index:(NSInteger)index originPoint:(CGPoint)originPoint isData:(BOOL)isData {
    NSMutableAttributedString *contentText = [attributeString mutableCopy];
    NSAttributedString *textAttachmentString = [[NSAttributedString alloc] initWithString:@"\n"];
    if ([attribute isKindOfClass:[JQLImageView class]]) {
        JQLImageView *imageView = (JQLImageView *)attribute;
        CGFloat imageViewHeight = ![imageView.title isEqualToString:@""] ? IMAGE_WIDTH + 30.0 : IMAGE_WIDTH;
        imageView.frame = CGRectMake(originPoint.x, originPoint.y, IMAGE_WIDTH, imageViewHeight);
        
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:_textView.font alignment:YYTextVerticalAlignmentCenter];
        if (!isData) [contentText insertAttributedString:textAttachmentString atIndex:index++];
        [contentText insertAttributedString:attachText atIndex:index++];
        
        imageView.editBlock = ^(JQLImageView *imageView) {
            [self p_editImageViewTitle:imageView point:imageView.frame.origin];
        };
        imageView.moveBlock = ^(JQLImageView *imageView, UILongPressGestureRecognizer *longPress) {
            [self p_move:imageView longPress:longPress];
        };
        imageView.deleteBlock = ^(JQLImageView *imageView) {
            [self p_deleteImageView:imageView];
        };
    }
    return contentText;
}

@end
