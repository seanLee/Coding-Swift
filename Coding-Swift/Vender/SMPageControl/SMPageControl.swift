//
//  SMPageControl.swift
//  Coding-Swift
//
//  Created by Sean on 16/5/24.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit

class SMPageControl: UIControl {
    
    // MARK: - const
    let DEFAULT_INDICATOR_WIDTH:        CGFloat = 6.0
    let DEFAULT_INDICATOR_MARGIN:       CGFloat = 10.0
    let DEFAULT_MIN_HEIGHT:             CGFloat = 36.0
    
    let DEFAULT_INDICATOR_WIDTH_LARGE:  CGFloat = 7.0
    let DEFAULT_INDICATOR_MARGIN_LARGE: CGFloat = 9.0
    let DEFAULT_MIN_HEIGHT_LARGE:       CGFloat = 36.0
    
    // MARK: - Enum Used
    enum SMPageControlAlignment: Int {
        case SMPageControlAlignmentLeft = 1
        case SMPageControlAlignmentCenter
        case SMPageControlAlignmentRight
    }
    
    enum SMPageControlVerticalAlignment: Int {
        case SMPageControlVerticalAlignmentTop = 1
        case SMPageControlVerticalAlignmentMiddle
        case SMPageControlVerticalAlignmentBottom
    }
    
    enum SMPageControlTapBehavior: Int {
        case SMPageControlTapBehaviorStep	= 1
        case SMPageControlTapBehaviorJump
    }
    
    enum SMPageControlImageType: Int {
        case SMPageControlImageTypeNormal = 1
        case SMPageControlImageTypeCurrent
        case SMPageControlImageTypeMask
    }
    
    enum SMPageControlStyleDefaults: Int {
        case SMPageControlDefaultStyleClassic = 0
        case SMPageControlDefaultStyleModern
    }
    
    // MARK: - Stored Property
    var tapBehavior = SMPageControlTapBehavior(rawValue: 1)!
    var alignment = SMPageControlAlignment(rawValue: 2)!
    var verticalAlignment = SMPageControlVerticalAlignment(rawValue: 2)!
    
    var hidesForSinglePage = false
    var defersCurrentPageDisplay = false
    
    lazy var accessibilityPageControl: UIPageControl = {
        return UIPageControl()
    }()
    
    // MARK: - When Set Frame
    override var frame: CGRect {
        willSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - numberOfPages
    private var _numberOfPages      : Int     = 0
    var numberOfPages       : Int {
        get {
            return _numberOfPages
        }
        set {
            if newValue == _numberOfPages {
                return
            }
            
            accessibilityPageControl.numberOfPages = newValue
            
            _numberOfPages = max(0, newValue)
            
            if respondsToSelector(#selector(invalidateIntrinsicContentSize)) {
                invalidateIntrinsicContentSize()
            }
            updateAccessibilityValue()
            setNeedsDisplay()
        }
    }
    
    // MARK: - currentPage
    private var _currentPage         : Int     = 0
    var currentPage         : Int {
        get {
            return _currentPage
        }
        set {
            _currentPage = newValue
            setCurrentPage(currentPage, sendEvent: false, canDefer: false)
        }
    }
    
    // MARK: - indicatorDiameter
    private var _indicatorDiameter  : CGFloat = 10.0
    var indicatorDiameter: CGFloat {
        get {
            return _indicatorDiameter
        }
        set {
            if newValue == _indicatorDiameter {
                return
            }
            
            _indicatorDiameter = newValue
            
            if minHeight < newValue {
                minHeight = newValue
            }
            updateMeasuredIndicatorSizes()
            setNeedsDisplay()
        }
    }
    
    // MARK: - indicatorMargin
    private var _indicatorMargin    : CGFloat = 6.0
    var indicatorMargin     : CGFloat {
        get {
            return _indicatorMargin
        }
        set {
            if newValue == _indicatorMargin {
                return
            }
            
            _indicatorMargin = newValue
            setNeedsDisplay()
        }
    }
    
    // MARK: - minHeight
    private var _minHeight          : CGFloat = 36.0
    var minHeight           : CGFloat {
        get {
            return _minHeight
        }
        set {
            if newValue == _minHeight {
                return
            }
            
            _minHeight = newValue
            
            if newValue < _indicatorMargin {
                _minHeight = _indicatorMargin
            }
            
            if respondsToSelector(#selector(invalidateIntrinsicContentSize)) {
                invalidateIntrinsicContentSize()
            }
            
            setNeedsLayout()
        }
    }
    
    // MARK: -
    private var displayedPage       :Int = 0
    private var measuredIndicatorWidth  : CGFloat = 0
    private var measuredIndicatorHeight : CGFloat = 0
    private var pageImageMask: CGImage?
    
    // MARK: - pageIndicatorImage
    private var _pageIndicatorImage     : UIImage?
    var pageIndicatorImage: UIImage? {
        get {
            return _pageIndicatorImage
        }
        set {
            if newValue == _pageIndicatorImage {
                return
            }
            
            _pageIndicatorImage = newValue
            
            updateMeasuredIndicatorSizes()
            setNeedsLayout()
        }
    }
    
    // MARK: - pageIndicatorMaskImage
    private var _pageIndicatorMaskImage: UIImage?
    var pageIndicatorMaskImage : UIImage? {
        get {
            return _pageIndicatorMaskImage
        }
        set {
            if newValue == _pageIndicatorMaskImage {
                return
            }
            
            _pageIndicatorMaskImage = newValue
            
            pageImageMask = createMaskForImage(pageIndicatorMaskImage!)
            
            updateMeasuredIndicatorSizes()
            setNeedsLayout()
        }
    }
    
    // MARK: - currentPageIndicatorImage
    private var _currentPageIndicatorImage: UIImage?
    var currentPageIndicatorImage    : UIImage? {
        get {
            return _currentPageIndicatorImage
        }
        set {
            if newValue == _currentPageIndicatorImage {
                return
            }
            
            _currentPageIndicatorImage = newValue
            
            updateMeasuredIndicatorSizes()
            setNeedsLayout()
        }
    }
    
    // MARK: -
    var pageIndicatorTintColor       : UIColor?
    var currentPageIndicatorTintColor: UIColor?
    
    //当前页面图片
    private var currentPageImages   = [NSNumber :UIImage]()
    //所有的页面图片
    private var pageImages          = [NSNumber: UIImage]()
    //MaskImages
    private var pageImageMasks      = [NSNumber: UIImage]()
    //Name
    private var pageNames           = [NSNumber: String]()
    //需要绘制的图片
    private var cgImageMasks = [NSNumber: CGImage]()
    private var pageRects = [NSValue]()
    
    // MARK: - Calculate Property
    class var defaultStyleForSystemVersion: SMPageControlStyleDefaults {
        let reqSysVer = "7.0"
        let currSysVer = UIDevice.currentDevice().systemVersion
        
        if currSysVer.compare(reqSysVer, options: .NumericSearch, range: nil, locale: nil) != .OrderedAscending {
            return SMPageControlStyleDefaults(rawValue: 1)!
        } else {
            return SMPageControlStyleDefaults(rawValue: 0)!
        }
    }
    
    func _initialize() {
        backgroundColor = UIColor.clearColor()
        
        setStyleWithDefaults(SMPageControl.defaultStyleForSystemVersion)
        
        isAccessibilityElement = true
        accessibilityTraits = UIAccessibilityTraitUpdatesFrequently
        contentMode = .Redraw
    }
    
    private func setStyleWithDefaults(style: SMPageControlStyleDefaults) {
        switch style {
        case .SMPageControlDefaultStyleModern:
            indicatorDiameter = DEFAULT_INDICATOR_WIDTH_LARGE
            indicatorMargin = DEFAULT_INDICATOR_MARGIN_LARGE
            pageIndicatorTintColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
            minHeight = DEFAULT_MIN_HEIGHT_LARGE
        case .SMPageControlDefaultStyleClassic:
            indicatorDiameter = DEFAULT_INDICATOR_WIDTH
            indicatorMargin = DEFAULT_INDICATOR_MARGIN
            pageIndicatorTintColor = UIColor.whiteColor().colorWithAlphaComponent(0.3)
            minHeight = DEFAULT_MIN_HEIGHT
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        _initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _initialize()
    }
    
    deinit {
        if pageImageMask != nil {
            pageImageMask = nil
        }
    }
    
    // MARK: - Draw
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        renderPages(context, rect: rect)
    }
    
    // MARK: - Calculate Size
    private func renderPages(context: CGContextRef?, rect: CGRect) {

        var pagesRects = [NSValue]()
        
        if numberOfPages < 2 && hidesForSinglePage {
            return
        }
        
        let left = leftOffset()
        
        var xOffet = left
        var yOffset: CGFloat = 0.0
        var fillColor: UIColor?
        var image: UIImage?
        var maskingImage: CGImage?
        var maskSize = CGSizeZero;
        
        for index in 0..<numberOfPages {
            let indexNumber = NSNumber(integer: index);
            
            if index == displayedPage {
                fillColor = currentPageIndicatorTintColor ?? UIColor.whiteColor()
                image = currentPageImages[indexNumber]
                if image == nil {
                    image = currentPageIndicatorImage
                }
            } else {
                fillColor = pageIndicatorTintColor ?? UIColor.whiteColor().colorWithAlphaComponent(0.3)
                image = pageImages[indexNumber]
                if image == nil {
                    image = pageIndicatorImage
                }
            }
            
            //If no finished iamges have been set, try a masking image
            if image == nil {
                maskingImage = cgImageMasks[indexNumber];
                let originImage = pageImageMasks[indexNumber];
                if let originSize = originImage?.size {
                    maskSize = originSize
                }
                
                if maskingImage == nil {
                    maskingImage = pageImageMask
                    if let maskImageSize = pageIndicatorMaskImage?.size {
                        maskSize = maskImageSize
                    }
                }
            }
            
            fillColor!.set()
            var indicatorRect: CGRect
            if let currentImage = image {
                yOffset = topOffsetForHeight(currentImage.size.height, rect: rect)
                let centeredXOffset = xOffet + floor((measuredIndicatorWidth - currentImage.size.width) / 2.0)
                currentImage.drawAtPoint(CGPoint(x: centeredXOffset, y: yOffset))
                indicatorRect = CGRect(x: centeredXOffset, y: yOffset, width: currentImage.size.width, height: currentImage.size.height)
            } else if let currentMaskingImage = maskingImage {
                yOffset = topOffsetForHeight(maskSize.height, rect: rect)
                let centeredXOffset = xOffet + floor((measuredIndicatorWidth - maskSize.width) / 2.0)
                indicatorRect = CGRect(x: centeredXOffset, y: yOffset, width: maskSize.width, height: maskSize.height)
                CGContextDrawImage(context, indicatorRect, currentMaskingImage)
            } else {
                yOffset = topOffsetForHeight(indicatorDiameter, rect: rect)
                let centeredXOffset = xOffet + floor((measuredIndicatorWidth - indicatorDiameter) / 2.0)
                indicatorRect = CGRect(x: centeredXOffset, y: yOffset, width: indicatorDiameter, height: indicatorDiameter)
                CGContextFillEllipseInRect(context, indicatorRect)
            }
            
            pagesRects.append(NSValue(CGRect: indicatorRect))
            maskingImage = nil
            xOffet = xOffet + measuredIndicatorWidth + indicatorMargin
        }
        self.pageRects = pagesRects
    }
    
    private func leftOffset() -> CGFloat {
        let rect = self.bounds
        let size = sizeForNumberOfPages(self.numberOfPages)
        var left: CGFloat = 0.0
        switch alignment {
        case .SMPageControlAlignmentCenter:
            left = ceil(CGRectGetMinX(rect) - (size.width / 2.0))
        case .SMPageControlAlignmentRight:
            left = CGRectGetMaxX(rect) - size.width
        default:
            break;
        }
        
        return left
    }
    
    private func topOffsetForHeight(height: CGFloat, rect: CGRect) -> CGFloat {
        var top: CGFloat = 0.0
        switch verticalAlignment {
        case .SMPageControlVerticalAlignmentMiddle:
            top = CGRectGetMidY(rect) - (height / 2.0)
        case .SMPageControlVerticalAlignmentBottom:
            top = CGRectGetMaxY(rect) - height
        default:
            break;
        }
        return top
    }
    
    // MARK: - Set Layout Element
    func setImage(image: UIImage?, pageIndex: Int) {
        setImage(image, pageIndex: pageIndex, type: .SMPageControlImageTypeNormal, redraw: true)
    }
    func setCurrentImage(image: UIImage?, pageIndex: Int) {
        setImage(image, pageIndex: pageIndex, type: .SMPageControlImageTypeCurrent, redraw: true)
    }
    func setImageMask(image: UIImage?, pageIndex: Int) {
        setImage(image, pageIndex: pageIndex, type: .SMPageControlImageTypeMask, redraw: true)
        
        guard image != nil else {
            cgImageMasks.removeValueForKey(NSNumber(integer: pageIndex))
            return
        }
        
        let maskImage = createMaskForImage(image!)
        
        if let imageRef = maskImage {
            cgImageMasks[NSNumber(integer: pageIndex)] = imageRef
            updateMeasuredIndicatorSizeWithSize(image!.size)
            setNeedsDisplay()
        }
    }
    
    func imageForPage(pageIndex: Int) -> UIImage? {
        return getImageForPage(pageIndex, type: .SMPageControlImageTypeNormal)
    }
    func currentImageForPage(pageIndex: Int) -> UIImage? {
        return getImageForPage(pageIndex, type: .SMPageControlImageTypeCurrent)
    }
    func imageMaskForPage(pageIndex: Int) -> UIImage? {
        return getImageForPage(pageIndex, type: .SMPageControlImageTypeMask)
    }
    
    
    private func setImage(image: UIImage?, pageIndex: Int, type: SMPageControlImageType, redraw: Bool) {
        if pageIndex < 0 || pageIndex >= numberOfPages {
            return
        }
        
        var dictionary = [NSNumber: UIImage]()
        switch type {
        case .SMPageControlImageTypeCurrent:
            dictionary = currentPageImages
        case .SMPageControlImageTypeNormal:
            dictionary = pageImages
        case .SMPageControlImageTypeMask:
            dictionary = pageImageMasks
        }
        
        let indexKey = NSNumber(integer: pageIndex)
        if let setImage = image {
            dictionary[indexKey] = setImage
        } else {
            dictionary.removeValueForKey(indexKey)
        }
        
        if redraw {
            updateMeasuredIndicatorSizes()
        }
    }
    
    private func getImageForPage(pageIndex: Int, type: SMPageControlImageType) -> UIImage? {
        if pageIndex < 0 || pageIndex >= numberOfPages {
            return nil
        }
        
        let dictionary : [NSNumber :UIImage]
        
        switch type {
        case .SMPageControlImageTypeCurrent:
            dictionary = currentPageImages
        case .SMPageControlImageTypeNormal:
            dictionary = pageImages
        case .SMPageControlImageTypeMask:
            dictionary = pageImageMasks
        }
        
        return dictionary[NSNumber(integer: pageIndex)]
    }
    
    // MARK: - Override
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        var sizeThatFits = sizeForNumberOfPages(numberOfPages)
        sizeThatFits.height = max(sizeThatFits.height, minHeight)
        return sizeThatFits
    }
    
    override func intrinsicContentSize() -> CGSize {
        if numberOfPages < 1 || (numberOfPages < 2 && hidesForSinglePage) {
            return CGSize(width: UIViewNoIntrinsicMetric, height: 0.0)
        }
        let intrinsicContentSize = CGSizeMake(UIViewNoIntrinsicMetric, max(measuredIndicatorHeight, minHeight))
        return intrinsicContentSize
    }
    
    // MARK: - Function Used Public
    func updateCurrentPageDisplay() {
        displayedPage = currentPage
        self.setNeedsDisplay()
    }
    
    func sizeForNumberOfPages(pageCount: Int) -> CGSize {
        let marginSpace = max(0, CGFloat(pageCount) - 1) * indicatorMargin
        let indicatorSpace = CGFloat(pageCount) * measuredIndicatorWidth
        return CGSize(width: marginSpace + indicatorSpace, height: measuredIndicatorHeight)
    }
    
    func rectForPageIndicator(pageIndex: Int) -> CGRect {
        if pageIndex < 0 || pageIndex >= numberOfPages {
            return CGRectZero
        }
        
        let left = leftOffset()
        let size = sizeForNumberOfPages(pageIndex - 1)
        let rect = CGRectMake(left + size.width - measuredIndicatorWidth, 0, measuredIndicatorWidth, measuredIndicatorHeight)
        
        return rect
    }
    
    func updatePageNumberForScrollView(scrollView: UIScrollView) {
        let page = floor(scrollView.contentOffset.x / scrollView.bounds.size.width)
        currentPage = Int(page)
    }
    
    func setScrollViewContentOffsetForCurrentPage(scrollView: UIScrollView, animated: Bool) {
        var offset = scrollView.contentOffset
        offset.x = scrollView.bounds.size.width * CGFloat(currentPage)
        scrollView.setContentOffset(offset, animated: animated)
    }
    
    // MARK: - Update Layout
    private func createMaskForImage(image: UIImage) -> CGImage? {
        let pixelsWidth = Int(image.size.width * image.scale)
        let pixelsHight = Int(image.size.height * image.scale)
        let bitmapBytesPerRow = pixelsWidth * 1
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.Only.rawValue)
        let context = CGBitmapContextCreate(nil, pixelsWidth, pixelsHight, CGImageGetBitsPerComponent(image.CGImage), bitmapBytesPerRow, nil, bitmapInfo.rawValue)
        CGContextTranslateCTM(context, 0.0, CGFloat(pixelsHight))
        CGContextScaleCTM(context, 1.0, -1.0)
        
        CGContextDrawImage(context, CGRect(x: 0, y: 0, width: CGFloat(pixelsWidth), height: CGFloat(pixelsHight)), image.CGImage)
        
        //return CGImage
        return CGBitmapContextCreateImage(context)
    }
    
    private func updateMeasuredIndicatorSizes() {
        measuredIndicatorWidth = indicatorDiameter
        measuredIndicatorHeight = indicatorDiameter
        
        //If we're only use images, ignore the indicatorDiameter
        if (pageIndicatorImage != nil || pageIndicatorMaskImage != nil) && (currentPageIndicatorImage != nil) {
            measuredIndicatorWidth = 0
            measuredIndicatorHeight = 0
        }
        
        if let image = pageIndicatorImage {
            updateMeasuredIndicatorSizeWithSize(image.size)
        }
        
        if let image = currentPageIndicatorImage {
            updateMeasuredIndicatorSizeWithSize(image.size)
        }
        
        if let image = pageIndicatorMaskImage {
            updateMeasuredIndicatorSizeWithSize(image.size)
        }
        
        if respondsToSelector(#selector(invalidateIntrinsicContentSize)) {
            invalidateIntrinsicContentSize()
        }
    }
    
    private func updateMeasuredIndicatorSizeWithSize(size: CGSize) {
        measuredIndicatorWidth = max(measuredIndicatorWidth, size.width)
        measuredIndicatorHeight = max(measuredIndicatorHeight, size.height)
    }
    
    // MARK: - UIAccessibility
    func setName(name: String, pageIndex: Int) {
        if pageIndex < 0 || pageIndex >= numberOfPages {
            return
        }
        
        pageNames[NSNumber(integer: pageIndex)] = name
    }
    
    func nameForPage(pageIndex: Int) -> String? {
        if pageIndex < 0 || pageIndex >= numberOfPages {
            return nil
        }
        
        return pageNames[NSNumber(integer: pageIndex)]
    }
    
    private func updateAccessibilityValue() {
        let pageName = nameForPage(currentPage)
        let accessibilityValue = accessibilityPageControl.accessibilityValue
        
        if let name = pageName ,
            let value = accessibilityValue {
            self.accessibilityValue = "\(name) - \(value)"
        } else {
            self.accessibilityValue = accessibilityValue
        }
    }
    
    // MARK: - Responsable Function
    private func setCurrentPage(currentPage: Int, sendEvent: Bool, canDefer: Bool) {
        _currentPage = min(max(0, currentPage), numberOfPages - 1)
        
        self.accessibilityPageControl.currentPage = _currentPage
        
        updateAccessibilityValue()
        
        if (defersCurrentPageDisplay == false || canDefer == false) {
            displayedPage = _currentPage
            setNeedsDisplay()
        }
        
        if sendEvent {
            sendActionsForControlEvents(.ValueChanged)
        }
    }
    
    // MARK: - Tap Gesture
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let point = touch!.locationInView(self)
        
        if tapBehavior == .SMPageControlTapBehaviorJump {
            
            var tappedIndicatorIndex = NSNotFound
            
            for value in pageRects.enumerate() {
                let indicatorRect = value.1.CGRectValue()
                
                if CGRectContainsPoint(indicatorRect, point) {
                    tappedIndicatorIndex = value.0
                    break
                }
            }
            
            if NSNotFound != tappedIndicatorIndex {
                setCurrentPage(tappedIndicatorIndex, sendEvent: true, canDefer: true)
                return
            }
        }
        
        let size = sizeForNumberOfPages(numberOfPages)
        let left = leftOffset()
        let middle = left +  (size.width / 2.0)
        if point.x < middle {
            setCurrentPage(currentPage - 1, sendEvent: true, canDefer: true)
        } else {
            setCurrentPage(currentPage + 1, sendEvent: true, canDefer: true)
        }
    }
}
