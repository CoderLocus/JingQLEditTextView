//
//  RTDragCellTableView.h
//
//  Created by Rusted on 16/2/12.
//  Copyright © 2016年 Rusted. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RTDragCellTableView;
@protocol RTDragCellTableViewDataSource <UITableViewDataSource>

@required
/**将外部数据源数组传入，以便在移动cell数据发生改变时进行修改重排*/
- (NSArray *)originalArrayDataForTableView:(RTDragCellTableView *)tableView;

@end

@protocol RTDragCellTableViewDelegate <UITableViewDelegate>

@required
/**将修改重排后的数组传入，以便外部更新数据源*/
- (void)tableView:(RTDragCellTableView *)tableView newArrayDataForDataSource:(NSArray *)newArray;
- (void)didFinishDragingTableView:(RTDragCellTableView *)tableView isMovedIndexPath:(NSIndexPath *)isMovedIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
@optional
/**选中的cell准备好可以移动的时候*/
- (void)tableView:(RTDragCellTableView *)tableView cellReadyToMoveAtIndexPath:(NSIndexPath *)indexPath;
/**选中的cell正在移动，变换位置，手势尚未松开*/
- (void)cellIsMovingInTableView:(RTDragCellTableView *)tableView;
/**选中的cell完成移动，手势已松开*/
- (void)cellDidEndMovingInTableView:(RTDragCellTableView *)tableView;

@end

@interface RTDragCellTableView : UITableView

@property (nonatomic, assign) id<RTDragCellTableViewDataSource> dataSource;
@property (nonatomic, assign) id<RTDragCellTableViewDelegate> delegate;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;


/**记录手指所在的位置*/
@property (nonatomic, assign) CGPoint fingerLocation;
/**对被选中的cell的截图*/
@property (nonatomic, weak) UIView *snapshot;
/**被选中的cell的原始位置*/
@property (nonatomic, strong) NSIndexPath *originalIndexPath;
@property (nonatomic, strong) NSIndexPath *firstIndexPath;
/**被选中的cell的新位置*/
@property (nonatomic, strong) NSIndexPath *relocatedIndexPath;
/**cell被拖动到边缘后开启，tableview自动向上或向下滚动*/
- (void)cellSelectedAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)checkIfSnapshotMeetsEdge;
- (void)startAutoScrollTimer;
- (void)stopAutoScrollTimer;
- (void)cellRelocatedToNewIndexPath:(NSIndexPath *)indexPath;
- (void)didEndDraging;

@end
