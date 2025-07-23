// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all 
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V. 
// or its affiliates is strictly prohibited.

#import <Foundation/Foundation.h>
#import <GEMKit/GenericHeader.h>
#import <GEMKit/GEMSdkDelegate.h>
#import <GEMKit/CoordinatesObject.h>
#import <GEMKit/LandmarkObject.h>
#import <GEMKit/TransferStatisticsContext.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class is the entry point in Gem iOS Sdk.
 */
__attribute__((visibility("default"))) @interface GEMSdk : NSObject

/**
 * The delegate for the GEM Sdk.
 */
@property(nonatomic, weak) NSObject <GEMSdkDelegate> *delegate;

/**
 * Not available. Please use initSdk.
 */
- (instancetype)init NS_SWIFT_UNAVAILABLE("use initSdk initializers instead");

/**
 * Returns the singleton SDK instance.
 */
+ (nonnull GEMSdk *)shared;

/**
 * Makes all the proper initialisation of the SDK.
 * @param authorizationKey The Project API Key.
 * @discussion The Project API Key can be found at: https://developer.magiclane.com/api/projects
 * @discussion By default the SDK language is the device preferred language and region.
 * @return Successfully initialisation state.
 */
- (BOOL)initSdk:(nonnull NSString *)authorizationKey;

/**
 * Makes all the proper initialisation of the SDK.
 * @param authorizationKey The Project API Key.
 * @param language The SDK language. The language form might be : "ISO 639-3 language code - ISO 3166-1_3 region code ( optional )", e.g. "eng" for generic English, "eng-USA" for English American.
 *                     The language form might be also:  "ISO 639-1 language code - ISO 3166-1_2 region code ( optional )", e.g. "en" for generic English, "en-US" for English American.
 * @param handler Completion block with the init phase result code.
 * @discussion The Project API Key can be found at: https://developer.magiclane.com/api/projects
 * @return Initialisation code. SDKErrorCodeKNoError for initialisation succeeded.
 */
- (SDKErrorCode)initSdk:(nonnull NSString *)authorizationKey language:(nonnull NSString *)language completionHandler:( void(^)(SDKErrorCode) )handler;

/**
 * Makes only the core initialisation of the SDK.
 * @param authorizationKey The Project API Key.
 * @discussion The Project API Key can be found at: https://developer.magiclane.com/api/projects
 * @discussion By default the SDK language is the device preferred language and region.
 * @details Dedicated for Flutter native.
 * @return Successfully initialisation state.
 */
- (BOOL)initCoreSdk:(NSString*)authorizationKey;

/**
 * Makes only the core initialisation of the SDK.
 * @param authorizationKey The Project API Key.
 * @param language The SDK language. The language form might be : "ISO 639-3 language code - ISO 3166-1_3 region code ( optional )", e.g. "eng" for generic English, "eng-USA" for English American.
 *                     The language form might be also:  "ISO 639-1 language code - ISO 3166-1_2 region code ( optional )", e.g. "en" for generic English, "en-US" for English American.
 * @param handler Completion block with the init phase result code.
 * @discussion The Project API Key can be found at: https://developer.magiclane.com/api/projects
 * @details Dedicated for Flutter native.
 * @return Initialisation code. SDKErrorCodeKNoError for initialisation succeeded.
 */
- (SDKErrorCode)initCoreSdk:(nonnull NSString *)authorizationKey language:(nonnull NSString *)language completionHandler:( void(^)(SDKErrorCode) )handler;

/**
 * Verifies if authorization key is valid. Online connection must be available.
 * @param authorizationKey The Project API Key.
 * @param handler The block to execute asynchronously with the result.
 */
- (void)verifySdk:(nonnull NSString*)authorizationKey completionHandler:(void(^)(AuthorizationKeyStatus status))handler;

/**
 * Returns  the SDK capabilities.
 * @return A package of [ESdkCapabilities] flags
 */
- (nonnull NSArray <NSNumber *> *)getCapabilities;

/**
 * Makes all the proper de-initialisation of the SDK.
 */
- (void)cleanDestroy;

/**
 * Returns the Sdk version.
 */
- (nonnull NSString *)getVersion;

/**
 * Tells the SDK to use NSTimer timer.
 */
- (void)useSystemTimer;

/**
 * Tells the SDK to use CADisplayLink timer.
 */
- (void)useDisplayLink;

/**
 * Tells the SDK that the app is running in the background and is no longer onscreen.
 */
- (void)appDidEnterBackground;

/**
 * Tells the SDK that the app became active and is now responding to user events.
 */
- (void)appDidBecomeActive;

/**
 * Set the unit system to be used by the SDK.
 * @param type The unit system type.
 */
- (void)setUnitSystem:(UnitSystemType)type;

/**
 * Set the 24 hours format notation.
 * @param state The state value.
 */
- (void)set24HourFormatNotation:(BOOL)state;

/**
 * Set maximum space to download tiles in kilobytes (Kb).
 * @param maxSpace Size in Kb.
 * @details If maxSpace is 0 there are no restriction for tiles space.
 */
- (void)setTilesMaxSpace:(int)maxSpace;

/**
 * Get maximum space to download tiles in kilobytes (Kb).
 * @return Size in Kb.
 */
- (int)getTilesMaxSpace;

/**
 * Returns the unit system used by the SDK.
 */
- (UnitSystemType)getUnitSystem;

/**
 * Set the map language selection method.
 */
- (void)setMapLanguage:(MapLanguageType)type;

/**
 * Get the current setting for the map language selection.
 */
- (MapLanguageType)getMapLanguage;

/**
 * Set a custom decimal separator.
 */
- (void)setDecimalSeparator:(nonnull NSString*)value;

/**
 * Get the current decimal separator.
 */
- (nonnull NSString*)getDecimalSeparator;

/**
 * Set a custom digit group separator.
 */
- (void)setDigitGroupSeparator:(nonnull NSString*)value;

/**
 * Get the current digit group separator.
 */
- (nonnull NSString*)getDigitGroupSeparator;

/**
 * Set the SDK language.
 * @details The language form might be :"ISO 639-1 language code - ISO 3166-1_2 region code ( optional )", e.g. "en" for generic English, "en-US" for English American.
 * @details The language form might be: "ISO 639-3 language code - ISO 3166-1_3 region code ( optional )", e.g. "eng" for generic English, "eng-USA" for English American.
 * @param language The unit system type.
 */
- (void)setLanguage:(NSString*)language;

/**
 * Allow / deny internet connection.
 */
- (void)setAllowConnection:(BOOL)state;

/**
 * Returns true if the connection is allowed or not.
 */
- (BOOL)getAllowConnection;

/**
 * Returns true if there is online connection .
 */
- (BOOL)isOnlineConnection;

/**
 * Returns true if there is Wifi connection .
 */
- (BOOL)isWiFiConnected;

/**
 * Returns true if there is mobile data connection .
 */
- (BOOL)isMobileDataConnected;

/**
 * Compress the data buffer.
 */
- (nullable NSData *)compress:(nonnull NSData *)data;

/**
 * Uncompress the data buffer.
 */
- (nullable NSData *)uncompress:(nonnull NSData *)data;

/**
 * Allow the given service type on the extra charged network type. By default all are allowed.
 */
- (void)setOffboardService:(ServiceGroupType)type allowExtraChargedNetwork:(BOOL)allow;

/**
 * Check if the given service type is allowed on the extra charged network.
 */
- (BOOL)getAllowExtraChargedNetworkForOffboardService:(ServiceGroupType)type;

/**
 * Get transfer statistics for given service type.
 */
- (nullable TransferStatisticsContext *)getTransferStatistics:(ServiceGroupType)type;

/**
 * Activate the debug logger.
 */
- (void)activateDebugLogger;

/**
 * Deactivate the debug logger.
 */
- (void)deactivateDebugLogger;

/**
 * Print a log message using Sdk logging.
 */
- (void)logMessage:(nonnull NSString*)string;

/**
 * Check if log is silent.
 */
- (BOOL)isLogSilent;

/**
 *  Get Stripe public key for stripe initialization.
 *  @param  testMode Enables a dry run call for testing.
 *  @param [out] handler The completion handler with the Stripe public key. If fails, the error code
 */
- (SDKErrorCode)getStripePublicKeyInTestMode:(BOOL)testMode completionHandler:(nonnull void(^)(NSString *session, SDKErrorCode error))handler;

/**
 *  Get Stripe secret for a pay session creation.
 *  @param  testMode Enables a dry run call for testing.
 *  @param  amount Amount of currency sent. If a too small value is provided, the server will return error KInvalidValue.
 *  @param  currency The currency of the amount value, e.g. "eur" for Euro.
 *  @param [out] handler The completion handler with the Stripe secret key. If fails, the error code.
 */
- (SDKErrorCode)getStripeSessionInTestMode:(BOOL)testMode amount:(double)amount currency:(nonnull NSString *)currency completionHandler:(nonnull void(^)(NSString *session, SDKErrorCode error))handler;
#ifdef WITH_FLUTTER_FEATURE
-(void)refreshNetwork;
#endif
@end

NS_ASSUME_NONNULL_END
