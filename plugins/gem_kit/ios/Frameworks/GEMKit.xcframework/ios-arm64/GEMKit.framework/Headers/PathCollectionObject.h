// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all 
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V. 
// or its affiliates is strictly prohibited.

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <GEMKit/PathObject.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates path collection information.
 */
__attribute__((visibility("default"))) @interface PathCollectionObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data..
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Get the number of paths in this collection.
 */
- (int)size;

/**
 * Get the path specified by index.
 */
- (nullable PathObject *)getPathAt:(int)index;

/**
 * Get the path specified by name.
 */
- (nullable PathObject *)getPathByName:(nonnull NSString*)name;

/**
 * Get the border color for the path specified by index.
 */
- (nonnull UIColor *)getBorderColorAt:(int)index;

/**
 * Get the inner color for the path specified by index.
 */
- (nonnull UIColor *)getFillColorAt:(int)index;

/**
 * Get the border size for the path specified by index.
 */
- (double)getBorderSizeAt:(int)index;

/**
 * Get the inner size for the path specified by index.
 */
- (double)getInnerSizeAt:(int)index;

/**
 * Add a path in the collection.
 * @param path The path to be added.
 * @param colorBorder The color of the path border. By default the one from the current map view style is used.
 * @param colorInner The color of the path inner. By default the one from the current map view style is used.
 * @param szBorder The size of the path border in mm. If < 0 the one from the current map view style is used.
 * @param szInner The size of the path inner in mm. If < 0 the one from the current map view style is used.
 * @return Operation with success.
 */
- (BOOL)add:(nonnull PathObject *)path colorBorder:(nullable UIColor *)colorBorder colorInner:(nullable UIColor *)colorInner szBorder:(double)szBorder szInner:(double)szInner;

/**
 * Remove the path from collection.
 * @return Operation with success.
 */
- (BOOL)remove:(nonnull PathObject *)object;

/**
 * Remove the path specified by index.
 * @return Operation with success.
 */
- (BOOL)removeAt:(int)index;

/**
 * Remove all paths from collection.
 */
- (void)clear;

@end

NS_ASSUME_NONNULL_END
