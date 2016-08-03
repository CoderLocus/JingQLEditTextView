仿豆瓣日记编辑功能，实现了图文编辑，可以插入删除图片，给图片加标题，并且长按可以移动图片位置

####初始化TextView数据
- (void)p_setData:(NSString *)data;
该方法里暂时只对<img full_url="https://dn-qinqinwojia.qbox.me/Fo1cGsOJ-QArC4-pH9-PoG1nfHKo" abbr_url="" caption="haha" />这一种个是进行了处理，如果需要处理其他格式可以在这个方法里添加。

####格式化数据
- (NSArray *)p_trimIsMove:(BOOL)isMove;
该方法对一行只有一个回车的数据进行了trim，如果不需要，可以删除;

####图片选择，目前并没有去进行获取原图
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto;

####富文本操作
- (NSAttributedString *)p_textViewAttributedText:(id)attribute contentText:(NSAttributedString *)attributeString index:(NSInteger)index originPoint:(CGPoint)originPoint isData:(BOOL)isData;
该方法将图片先转成了自己定义的一个ImageView视图，然后将视图，转成AttributedText。
如果需要获取富文本当中的视图，可以通过_textView.textLayout.attachments来进行获取。该数组里存放了所有的YYTextAttachment，YYTextAttachment里content属性是id类型，可以直接转成相应的视图。另外还有一个对应的_textView.textLayout.attachmentRanges存放的是对应的Ranges。

####长按移动图片位置
- (void)p_longPressGestureRecognized:(id)sender;
该方法调用了RTDragCellTableView当中的方法，来实现移动图片位置