//
//  HLLCollectionViewCalendarLayout.m
//  HLLCalendar
//
//  Created by Rocky Young on 2017/3/9.
//  Copyright © 2017年 Rocky Young. All rights reserved.
//

#import "HLLCollectionViewCalendarLayout.h"

NSString * const HLLCollectionElementKindSignHeader = @"HLLCollectionElementKindSignHeader";
NSString * const HLLCollectionElementKindDayRowHeader = @"HLLCollectionElementKindDayRowHeader";
NSString * const HLLCollectionElementKindDayRowGridline = @"HLLCollectionElementKindDayRowGridline";
NSString * const HLLCollectionElementKindCurrentDayHeader = @"HLLCollectionElementKindCurrentDayHeader";
NSString * const HLLCollectionElementKindVerticalGridline = @"HLLCollectionElementKindVerticalGridline";
NSString * const HLLCollectionElementKindHorizontalGridline = @"HLLCollectionElementKindHorizontalGridline";

NSUInteger const HLLCollectionMinOverlayZ = 1000.0; // Allows for 900 items in a section without z overlap issues
NSUInteger const HLLCollectionMinCellZ = 100.0;  // Allows for 100 items in a section's background
NSUInteger const HLLCollectionMinBackgroundZ = 0.0;

@interface HLLCollectionViewCalendarLayout ()

// Caches
@property (nonatomic, assign) BOOL needsToPopulateAttributesForAllSections;
@property (nonatomic, strong) NSMutableDictionary *cachedColumnHeights;

// Registered Decoration Classes
@property (nonatomic, strong) NSMutableDictionary *registeredDecorationClasses;

// Attributes
@property (nonatomic, strong) NSMutableArray *allAttributes;
@property (nonatomic, strong) NSMutableDictionary *itemAttributes;
@property (nonatomic, strong) NSMutableDictionary *dayRowHeaderAttributes;
@property (nonatomic, strong) NSMutableDictionary *dayRowHeaderGridlineAttributes;
@property (nonatomic, strong) NSMutableDictionary *currentDayHeaderAttributes;
@property (nonatomic, strong) NSMutableDictionary *horizontalGridlineAttributes;
@property (nonatomic, strong) NSMutableDictionary *verticalGridlineAttributes;

@property (nonatomic, strong) NSMutableDictionary *signHeaderAttributes;

@end

@implementation HLLCollectionViewCalendarLayout

#pragma mark - NSObject

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void) initialize{

    self.needsToPopulateAttributesForAllSections = YES;
    self.cachedColumnHeights = [NSMutableDictionary new];
    
    self.registeredDecorationClasses = [NSMutableDictionary new];
    
    self.allAttributes = [NSMutableArray new];
    self.itemAttributes = [NSMutableDictionary new];
    self.dayRowHeaderAttributes = [NSMutableDictionary new];
    self.dayRowHeaderGridlineAttributes = [NSMutableDictionary new];
    self.currentDayHeaderAttributes = [NSMutableDictionary new];
    self.horizontalGridlineAttributes = [NSMutableDictionary new];
    self.verticalGridlineAttributes = [NSMutableDictionary new];
    self.signHeaderAttributes = [NSMutableDictionary new];
    
    self.dayRowHeaderWidth = 80.0;
    self.dayRowHeaderHeight = 80.0;
    self.sectionWidth = 254.0;
    self.verticalGridlineWidth = (([[UIScreen mainScreen] scale] == 2.0) ? 0.5 : .5);
    self.horizontalGridlineHeight = (([[UIScreen mainScreen] scale] == 2.0) ? 0.5 : .5);;
    self.sectionMargin = UIEdgeInsetsMake(30.0, 20.0, 30.0, 20.0);
    self.cellMargin = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.contentMargin = UIEdgeInsetsMake(20.0, 10.0, 20.0, 10.0);
    
    self.stickySignHeader = YES;
    self.signHeaderHeight = 80;
}

- (void) invalidateLayoutCache{
    
    self.needsToPopulateAttributesForAllSections = YES;
    
    // Invalidate cached Components
    [self.cachedColumnHeights removeAllObjects];
    
    // Invalidate cached item attributes
    [self.itemAttributes removeAllObjects];
    [self.signHeaderAttributes removeAllObjects];
    [self.verticalGridlineAttributes removeAllObjects];
    [self.horizontalGridlineAttributes removeAllObjects];
    [self.dayRowHeaderAttributes removeAllObjects];
    [self.currentDayHeaderAttributes removeAllObjects];
    [self.dayRowHeaderGridlineAttributes removeAllObjects];
    [self.allAttributes removeAllObjects];
}

#pragma mark -
#pragma mark Layout hooks

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [self invalidateLayoutCache];
    
    [self prepareLayout];
    
    [super prepareForCollectionViewUpdates:updateItems];
}

- (void)finalizeCollectionViewUpdates
{
    // This is a hack to prevent the error detailed in :
    // http://stackoverflow.com/questions/12857301/uicollectionview-decoration-and-supplementary-views-can-not-be-moved
    // If this doesn't happen, whenever the collection view has batch updates performed on it, we get multiple instantiations of decoration classes
    for (UIView *subview in self.collectionView.subviews) {
        for (Class decorationViewClass in self.registeredDecorationClasses.allValues) {
            if ([subview isKindOfClass:decorationViewClass]) {
                [subview removeFromSuperview];
            }
        }
    }
    [self.collectionView reloadData];
}

- (void)registerClass:(Class)viewClass forDecorationViewOfKind:(NSString *)decorationViewKind
{
    [super registerClass:viewClass forDecorationViewOfKind:decorationViewKind];
    self.registeredDecorationClasses[decorationViewKind] = viewClass;
}

/** 子类必须重写的方法 */
- (void)prepareLayout
{
    [super prepareLayout];
    
    if (self.needsToPopulateAttributesForAllSections) {
        [self prepareSectionLayoutForSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.collectionView.numberOfSections)]];
        self.needsToPopulateAttributesForAllSections = NO;
    }
    
    BOOL needsToPopulateAllAttribtues = (self.allAttributes.count == 0);
    if (needsToPopulateAllAttribtues) {
        [self.allAttributes addObjectsFromArray:[self.signHeaderAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.dayRowHeaderAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.currentDayHeaderAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.verticalGridlineAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.horizontalGridlineAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.itemAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.dayRowHeaderGridlineAttributes allValues]];
    }
}

- (void)prepareSectionLayoutForSections:(NSIndexSet *)sectionIndexes
{
    if (self.collectionView.numberOfSections == 0) {
        return;
    }
    
    CGFloat itemCommomWidth = (self.collectionView.bounds.size.width - self.dayRowHeaderWidth - self.contentMargin.left - self.contentMargin.right - self.cellMargin.left - self.cellMargin.right - self.sectionMargin.left - self.sectionMargin.right) / 2;
    CGFloat itemCommomHeight = self.dayRowHeaderHeight;
    
    BOOL needsToPopulateItemAttributes = (self.itemAttributes.count == 0);
    BOOL needsToPopulateHorizontalGridlineAttributes = (self.horizontalGridlineAttributes.count == 0);
    BOOL needsToPopulateVerticalGridlineAttributes = (self.verticalGridlineAttributes.count == 0);
    BOOL needsToPopulateRowHeaderGridlineAttributes = (self.dayRowHeaderGridlineAttributes.count == 0);
    BOOL needsToPopulateSignHeaderAttributes = (self.signHeaderAttributes.count == 0);

    // Current Day Header
    NSIndexPath *currentDayHeaderIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UICollectionViewLayoutAttributes *currentDayHeaderAttributes = [self layoutAttributesForDecorationViewAtIndexPath:currentDayHeaderIndexPath ofKind:HLLCollectionElementKindCurrentDayHeader withItemCache:self.currentDayHeaderAttributes];
    // 先不设置，在需要的Section中再设置frame，显示出来
    currentDayHeaderAttributes.frame = CGRectZero;
    
    // Sign Header
    if (needsToPopulateSignHeaderAttributes) {
        
        CGFloat signHeaderMinY = self.stickySignHeader ? MAX(self.collectionView.contentOffset.y, 0) : 0;
        NSIndexPath * signHeaderIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        UICollectionViewLayoutAttributes * signHeaderAttributes = [self layoutAttributesForDecorationViewAtIndexPath:signHeaderIndexPath ofKind:HLLCollectionElementKindSignHeader withItemCache:self.signHeaderAttributes];
        signHeaderAttributes.frame = CGRectMake(0, signHeaderMinY, self.collectionView.bounds.size.width, self.signHeaderHeight);
        signHeaderAttributes.zIndex = [self zIndexForElementKind:HLLCollectionElementKindSignHeader];
    }
    
    CGFloat calendarGridMinX = (self.dayRowHeaderWidth + self.contentMargin.left);
    CGFloat calendarGridWidth = (self.collectionViewContentSize.width - 0);
    
    CGFloat margin = 0;//self.contentMargin.top + self.contentMargin.bottom;
    [sectionIndexes enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
        
        // Commom data
        CGFloat columnMinY = (section == 0) ? 0.0 : [self stackedSectionHeightUpToSection:section] - margin * section;// 获取当前section的最小y
        columnMinY += self.signHeaderHeight;

        CGFloat calendarGridMinY = (columnMinY + self.contentMargin.top);
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        
        CGFloat baseX = (self.sectionMargin.left + self.cellMargin.left) + self.dayRowHeaderWidth;
        CGFloat baseY = self.cellMargin.top + calendarGridMinY;
        
        // Day Row Header
        NSIndexPath *dayRowHeaderIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        UICollectionViewLayoutAttributes *dayRowHeaderAttributes = [self layoutAttributesForSupplementaryViewAtIndexPath:dayRowHeaderIndexPath ofKind:HLLCollectionElementKindDayRowHeader withItemCache:self.dayRowHeaderAttributes];
        // Frame
        CGFloat dayRowHeaderHeight = self.dayRowHeaderHeight * ((numberOfItems - 1) / 2 + 1) + self.cellMargin.top + self.cellMargin.bottom;
        CGFloat dayRowHeaderMinY = (calendarGridMinY + 0);
        dayRowHeaderAttributes.frame = CGRectMake(0.0, dayRowHeaderMinY, self.dayRowHeaderWidth, dayRowHeaderHeight);
        dayRowHeaderAttributes.zIndex = [self zIndexForElementKind:HLLCollectionElementKindDayRowHeader];

        if (section == [self currentDayHeaderIndex]) {
            
            // Frame
            currentDayHeaderAttributes.frame = dayRowHeaderAttributes.frame;
            currentDayHeaderAttributes.zIndex = [self zIndexForElementKind:HLLCollectionElementKindCurrentDayHeader];
        }
        
        // Item Cell
        if (needsToPopulateItemAttributes) {
            // Items
            for (NSInteger item = 0; item < numberOfItems; item++) {
                
                NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
                UICollectionViewLayoutAttributes *itemAttributes = [self layoutAttributesForCellAtIndexPath:itemIndexPath withItemCache:self.itemAttributes];
                
                CGFloat itemMinY,itemMinX;
                
                CGFloat row = item % 2;
                CGFloat column = item / 2;
                
                itemMinX = baseX + row * itemCommomWidth;
                itemMinY = baseY + column * itemCommomHeight;
                
                itemAttributes.frame = CGRectMake(itemMinX, itemMinY, itemCommomWidth, itemCommomHeight);
                itemAttributes.zIndex = [self zIndexForElementKind:nil];
            }
        }
        
        // Horizontal Gridlines
        if (needsToPopulateHorizontalGridlineAttributes) {

            NSInteger horizontalGridlineCount = 0;
            
            horizontalGridlineCount = ([self.collectionView numberOfItemsInSection:section] - 1) / 2;
            
            for (NSInteger horizontalGridlineIndex = 0; horizontalGridlineIndex <= horizontalGridlineCount; horizontalGridlineIndex++) {
                
                NSIndexPath *horizontalGridlineIndexPath = [NSIndexPath indexPathForItem:horizontalGridlineIndex inSection:section];
                UICollectionViewLayoutAttributes *horizontalGridlineAttributes = [self layoutAttributesForDecorationViewAtIndexPath:horizontalGridlineIndexPath ofKind:HLLCollectionElementKindHorizontalGridline withItemCache:self.horizontalGridlineAttributes];
                // Frame
                CGFloat horizontalGridlineMinY;
                horizontalGridlineMinY = calendarGridMinY + (horizontalGridlineIndex + 1) * itemCommomHeight;
                
                horizontalGridlineAttributes.frame = CGRectMake(calendarGridMinX, horizontalGridlineMinY, calendarGridWidth, self.horizontalGridlineHeight);
                horizontalGridlineAttributes.zIndex = [self zIndexForElementKind:HLLCollectionElementKindHorizontalGridline];
            }
        }
        
        // Vertical Gridlines
        if (needsToPopulateVerticalGridlineAttributes) {
            NSInteger verticalGridlineCount = 3;

            for (NSInteger verticalGridlineIndex = 0; verticalGridlineIndex < verticalGridlineCount; verticalGridlineIndex++) {
                
                NSIndexPath *verticalGridlineIndexPath = [NSIndexPath indexPathForItem:verticalGridlineIndex inSection:section];
                UICollectionViewLayoutAttributes *horizontalGridlineAttributes = [self layoutAttributesForDecorationViewAtIndexPath:verticalGridlineIndexPath ofKind:HLLCollectionElementKindVerticalGridline withItemCache:self.verticalGridlineAttributes];
                // Frame
                CGFloat verticalGridlineMinY = baseY;
                CGFloat verticalGridlineMinX = baseX + itemCommomWidth * verticalGridlineIndex;
                CGFloat verticalGridlineHeight = self.dayRowHeaderHeight * ((numberOfItems - 1) / 2 + 1) + self.cellMargin.top + self.cellMargin.bottom;
                
                horizontalGridlineAttributes.frame = CGRectMake(verticalGridlineMinX, verticalGridlineMinY, self.verticalGridlineWidth, verticalGridlineHeight);
                horizontalGridlineAttributes.zIndex = [self zIndexForElementKind:HLLCollectionElementKindVerticalGridline];
            }
        }
        
        // Day Row Header Gridline
        if (needsToPopulateRowHeaderGridlineAttributes) {
            
            NSIndexPath *horizontalGridlineIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            UICollectionViewLayoutAttributes *horizontalGridlineAttributes = [self layoutAttributesForDecorationViewAtIndexPath:horizontalGridlineIndexPath ofKind:HLLCollectionElementKindDayRowGridline withItemCache:self.dayRowHeaderGridlineAttributes];
            // Frame
            CGFloat horizontalGridlineMinY;
            horizontalGridlineMinY = calendarGridMinY + dayRowHeaderHeight;
            
            horizontalGridlineAttributes.frame = CGRectMake(0, horizontalGridlineMinY, calendarGridMinX, self.horizontalGridlineHeight);
            horizontalGridlineAttributes.zIndex = [self zIndexForElementKind:HLLCollectionElementKindDayRowGridline];
        }
    }];
}

/** 子类必须重写的方法 */
- (CGSize)collectionViewContentSize
{
    CGFloat width;
    CGFloat height;
    
    height = [self stackedSectionHeight];
    width = (self.dayRowHeaderWidth + self.contentMargin.left + self.sectionMargin.left + self.sectionWidth + self.sectionMargin.right + self.contentMargin.right);
    return CGSizeMake(width, height);
}

/** 子类必须重写的方法 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.itemAttributes[indexPath];
}

/** 子类必须重写的方法 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == HLLCollectionElementKindDayRowHeader) {
        return self.dayRowHeaderAttributes[indexPath];
    }
    return nil;
}
/** 子类必须重写的方法 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
{
    if (decorationViewKind == HLLCollectionElementKindCurrentDayHeader) {
        return self.currentDayHeaderAttributes[indexPath];
    }
    else if (decorationViewKind == HLLCollectionElementKindHorizontalGridline) {
        return self.horizontalGridlineAttributes[indexPath];
    }
    else if (decorationViewKind == HLLCollectionElementKindVerticalGridline) {
        return self.verticalGridlineAttributes[indexPath];
    }
    else if (decorationViewKind == HLLCollectionElementKindDayRowGridline) {
        return self.dayRowHeaderGridlineAttributes[indexPath];
    }
    else if (decorationViewKind == HLLCollectionElementKindSignHeader){
        return self.signHeaderAttributes[indexPath];
    }
    return nil;
}

/** 子类必须重写的方法 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableIndexSet *visibleSections = [NSMutableIndexSet indexSet];
    [[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.collectionView.numberOfSections)] enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
        
        CGRect sectionRect = [self rectForSection:section];
        if (CGRectIntersectsRect(sectionRect, rect)) {
            [visibleSections addIndex:section];
        }
    }];
    
    // 更新布局，但是只更新可见的部分
    [self prepareSectionLayoutForSections:visibleSections];
    
    // 返回可见的attributes
    return [self.allAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *layoutAttributes, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, layoutAttributes.frame);
    }]];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    // Required for sticky headers
    return YES;
}

#pragma mark -
#pragma mark Layout

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewAtIndexPath:(NSIndexPath *)indexPath ofKind:(NSString *)kind withItemCache:(NSMutableDictionary *)itemCache{

    UICollectionViewLayoutAttributes *layoutAttributes;
    if (self.registeredDecorationClasses[kind] && !(layoutAttributes = itemCache[indexPath])) {
        layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:kind withIndexPath:indexPath];
        itemCache[indexPath] = layoutAttributes;
    }
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewAtIndexPath:(NSIndexPath *)indexPath ofKind:(NSString *)kind withItemCache:(NSMutableDictionary *)itemCache{

    UICollectionViewLayoutAttributes *layoutAttributes;
    if (!(layoutAttributes = itemCache[indexPath])) {
        layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
        itemCache[indexPath] = layoutAttributes;
    }
    return layoutAttributes;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForCellAtIndexPath:(NSIndexPath *)indexPath withItemCache:(NSMutableDictionary *)itemCache{

    UICollectionViewLayoutAttributes *layoutAttributes;
    if (!(layoutAttributes = itemCache[indexPath])) {
        layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        itemCache[indexPath] = layoutAttributes;
    }
    return layoutAttributes;
}

#pragma mark Z Index

- (CGFloat)zIndexForElementKind:(NSString *)elementKind
{
    return [self zIndexForElementKind:elementKind floating:NO];
}

- (CGFloat)zIndexForElementKind:(NSString *)elementKind floating:(BOOL)floating
{
    // Day Row Header
    if (elementKind == HLLCollectionElementKindDayRowHeader) {
        return (HLLCollectionMinOverlayZ + 2.0);
    }
    // Current Day Header
    else if (elementKind == HLLCollectionElementKindCurrentDayHeader) {
        return (HLLCollectionMinOverlayZ + 3.0);
    }
    // Cell
    else if (elementKind == nil) {
        return HLLCollectionMinOverlayZ;
    }
    // Horizontal Gridline
    else if (elementKind == HLLCollectionElementKindHorizontalGridline) {
        return HLLCollectionMinOverlayZ + 1.0;
    }
    // Vertical Gridline
    else if (elementKind == HLLCollectionElementKindVerticalGridline) {
        return HLLCollectionMinOverlayZ + 1.0;
    }
    else if (elementKind == HLLCollectionElementKindDayRowGridline){
        return HLLCollectionMinOverlayZ + 3.0;
    }
    // Sign Header
    else if (elementKind == HLLCollectionElementKindSignHeader){
        return HLLCollectionMinOverlayZ + 4.0;
    }
    return CGFLOAT_MIN;
}

#pragma mark -
#pragma mark Stacking

/** 计算整个CollectionView的堆叠高度 */
- (CGFloat)stackedSectionHeight
{
    BOOL needsToPopulateSignHeaderAttributes = (self.signHeaderAttributes.count != 0);
    
    return [self stackedSectionHeightUpToSection:self.collectionView.numberOfSections] + (needsToPopulateSignHeaderAttributes ? self.signHeaderHeight : 0);
}
/** 计算upToSection之前的所有section的堆叠高度 */
- (CGFloat)stackedSectionHeightUpToSection:(NSInteger)upToSection
{
    if (self.cachedColumnHeights[@(upToSection)]) {
        return [self.cachedColumnHeights[@(upToSection)] integerValue];
    }
    CGFloat stackedSectionHeight = 0.0;
    for (NSInteger section = 0; section < upToSection; section++) {// 遍历该section以前的所有的section，将以前的section的cell高度叠加
        CGFloat sectionColumnHeight = [self sectionHeight:section];
        stackedSectionHeight += sectionColumnHeight;
    }
    CGFloat headerAdjustedStackedColumnHeight = (stackedSectionHeight + ((0 + self.contentMargin.top + self.contentMargin.bottom) * upToSection));
    if (stackedSectionHeight != 0.0) {
        self.cachedColumnHeights[@(upToSection)] = @(headerAdjustedStackedColumnHeight);
        return headerAdjustedStackedColumnHeight;
    } else {
        return headerAdjustedStackedColumnHeight;
    }
}
/** 当前section下的显示高度， */
- (CGFloat)sectionHeight:(NSInteger)section
{
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
    
    CGFloat dayRowStackedHeight = self.dayRowHeaderHeight * ((numberOfItems - 1) / 2 + 1);
    CGFloat cellMarginHeight = self.cellMargin.top + self.cellMargin.bottom;
    
    return dayRowStackedHeight + cellMarginHeight;
}

- (CGRect)rectForSection:(NSInteger)section
{
    CGRect sectionRect;

    CGFloat columnMinY = (section == 0) ? 0.0 : [self stackedSectionHeightUpToSection:section];
    CGFloat nextColumnMinY = (section == self.collectionView.numberOfSections) ? self.collectionViewContentSize.height : [self stackedSectionHeightUpToSection:(section + 1)];
    sectionRect = CGRectMake(0.0, columnMinY, self.collectionViewContentSize.width, (nextColumnMinY - columnMinY));
    return sectionRect;
}

#pragma mark -
#pragma mark Delegate wrapper

- (NSInteger) currentDayHeaderIndex{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(currentDayIndex)]) {
        return [self.delegate currentDayIndex];
    }
    return NSIntegerMin;
}


@end
