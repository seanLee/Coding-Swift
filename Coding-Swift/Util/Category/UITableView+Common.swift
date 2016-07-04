//
//  UITableView+Common.swift
//  Coding-Swift
//
//  Created by Sean on 16/7/4.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit

extension UITableView {
    // MARK: - SeperatorLine
    func addLineforPlainCell(cell: UITableViewCell, indexPath: NSIndexPath, leftSpace: CGFloat, hasSectionLine: Bool) {
        let layer = CAShapeLayer()
        
        var path = CGPathCreateMutable()
        
        let bounds = CGRectInset(cell.bounds, 0, 0)
        
        CGPathAddRect(path, nil, bounds)
        layer.path = path

        if let bgColor = cell.backgroundColor {
            layer.fillColor = bgColor.CGColor
        } else if let bgView = cell.backgroundView {
            if let bgViewColor = bgView.backgroundColor {
                layer.fillColor = bgViewColor.CGColor
            }
        } else {
            layer.fillColor = UIColor(white: 1.0, alpha: 0.8).CGColor
        }
        
        let lineColor = UIColor.colorWithHexString("0xdddddd").CGColor
        let sectionLineColor = lineColor
        
        if indexPath.row == 0 && indexPath.row == (self.numberOfRowsInSection(indexPath.section) - 1) {
            //只有一个Cell,加上长线&下长线
            if hasSectionLine {
                configLayer(layer, hasUp: true, isLong: true, color: sectionLineColor, bounds: bounds, leftSpace: 0)
                configLayer(layer, hasUp: false, isLong: true, color: sectionLineColor, bounds: bounds, leftSpace: 0)
            }
        } else if indexPath.row == 0 {
            //第一个Cell,加上长线&下短线
            if hasSectionLine {
                configLayer(layer, hasUp: true, isLong: true, color: sectionLineColor, bounds: bounds, leftSpace: 0)
            }
            configLayer(layer, hasUp: false, isLong: false, color: lineColor, bounds: bounds, leftSpace: leftSpace)
        } else if indexPath.row == (self.numberOfRowsInSection(indexPath.section) - 1) {
            //最后一个Cell,加下长线
            if hasSectionLine {
                configLayer(layer, hasUp: false, isLong: true, color: sectionLineColor, bounds: bounds, leftSpace: 0)
            }
        } else {
            configLayer(layer, hasUp: false, isLong: false, color: lineColor, bounds: bounds, leftSpace: leftSpace)
        }
        
        let layerView = UIView(frame: bounds)
        layerView.layer.insertSublayer(layer, atIndex: 0)
        cell.backgroundView = layerView
    }
    
    private func configLayer(layer: CALayer, hasUp: Bool, isLong: Bool, color: CGColor, bounds: CGRect, leftSpace: CGFloat) {
        let lineLayer = CALayer()
        let lineHeight = 1.0 / UIScreen.mainScreen().scale
        let left: CGFloat, top: CGFloat
        if hasUp {
            top = 0
        } else {
            top = bounds.size.height - lineHeight
        }
        
        if isLong {
            left = 0
        } else {
            left = leftSpace
        }
        lineLayer.frame = CGRectMake(CGRectGetMinX(bounds) + left, top, CGRectGetWidth(bounds) - left, lineHeight)
        lineLayer.backgroundColor = color
        layer.addSublayer(lineLayer)
    }
}
