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
#import <GEMKit/SoundObject.h>
#import <GEMKit/SoundContextDelegate.h>

/**
 * Constants indicating the sound audio category.
 */
typedef NS_ENUM(NSInteger, AudioCategory)
{
    /// Category when playing back audio.
    AudioCategoryPlayback,
    
    /// Category when recording and playing back audio.
    AudioCategoryPlaybackAndRecording,
};

/**
 * Constants indicating the sound output.
 */
typedef NS_ENUM(NSInteger, AudioOutput)
{
    /// Automatic mode.
    /// @details Output on speaker if device is NOT connected to Bluetooth A2DP.
    /// Output on Bluetooth A2DP if device is connected to Bluetooth A2DP.
    AudioOutputAutomatic,
    
    /// Output on Bluetooth as phone call.
    /// @details Available only for PlaybackAndRecording AudioCategory.
    AudioOutputBluetoothAsPhoneCall,
    
    /// Output only on speaker.
    /// @details Available only for PlaybackAndRecording AudioCategory.
    AudioOutputSpeakerOnly
};

/**
 * Constants indicating the audio file types.
 */
typedef NS_ENUM(NSInteger, FileAudioType)
{
    /// None.
    FileAudioTypeSpeedingWarning,
    
    /// Beep.
    FileAudioTypeSpeedCamera,
};

/**
 * Constants indicating the audio driver assistance file type.
 */
typedef NS_ENUM(NSInteger, DriverAssistanceAudioFile)
{
    /// None.
    DriverAssistanceAudioFileNone,
    
    /// Beep.
    DriverAssistanceAudioFileBeep,
    
    /// Single Beep.
    DriverAssistanceAudioFileSingleBeep,
    
    /// Short high pitched beeps.
    DriverAssistanceAudioFileShortHighPitchedBeeps,
    
    /// High pitched beeps.
    DriverAssistanceAudioFileHighPitchedBeeps,
};

NS_ASSUME_NONNULL_BEGIN

/**
 * This class handles the sound.
 */
__attribute__((visibility("default"))) @interface SoundContext : NSObject

/**
 The delegate for the navigation contex.
 */
@property(nonatomic, weak) NSObject <SoundContextDelegate> *delegate;

/**
 * Set use for text to speech.
 * @param handler The block to execute asynchronously with the result.
 * @discussion AVSpeechSynthesisVoice current language will be used.
 */
- (void)setUseTtsWithCompletionHandler:(nonnull void(^)(BOOL success))handler;

/**
 * Set use for text to speech with custom language code.
 * @param handler The block to execute asynchronously with the result.
 * @param language The language code. A string that contains the BCP 47 language and locale code for the user’s current locale ( en-US ).
 */
- (void)setUseTtsWithLanguage:(nonnull NSString *)language completionHandler:(nonnull void(^)(BOOL success))handler;

/**
 * Set use for human voice for identifier from local list.
 * @param identifier The voice identifier.
 * @param handler The block to execute asynchronously with the result.
 */
- (void)setUseHumanVoiceWithIdentifier:(NSInteger)identifier completionHandler:(nonnull void(^)(BOOL success))handler;

/**
 * Play the requested sound object.
 * @param object The sound object.
 */
- (void)playSound:(nonnull SoundObject *)object;

/**
 * Play the requested text.
 */
- (void)playText:(nonnull NSString *)text;

/**
 * Play file audio type.
 */
- (void)playFileType:(FileAudioType)type;

/**
 * Play the requested sound warning.
 */
- (void)playWarningFile:(DriverAssistanceAudioFile)audioFile;

/**
 * Play alert at maximum volume level. Everything else is interrupted.
 */
- (void)playWarningAlert:(DriverAssistanceAudioFile)audioFile;

/**
 * Cancel playing the sound.
 */
- (void)cancel;

/**
 * Returns true if a play sound is active.
 */
- (BOOL)isPlaying;

/**
 * Set the volume level.
 * @param volume The volume level.
 */
- (void)setVolume:(int)volume;

/**
 * Returns the volume level.
 */
- (int)getVolume;

/**
 * Returns the tts voice name.
 */
- (nonnull NSString *)getTtsVoiceName;

/**
 * Updates the audio session category.
 */
- (void)updateSessionWithAudioCategory:(AudioCategory)audioCategory;

/**
 * Updates the audio session output.
 */
- (void)updateSessionWithAudioOutput:(AudioOutput)audioOutput;

/**
 * Set the call delay for audio session output: AudioOutputBluetoothAsPhoneCall.
 * @details Default value is 0 milliseconds.
 */
- (void)setDelay:(int)value;

/**
 * Get the call delay for audio session output: AudioOutputBluetoothAsPhoneCall.
 */
- (int)getDelay;

/**
 * Returns the sound session interruption state.
 */
- (BOOL)isSessionInterrupted;

/**
 * Destroy the sound context.
 */
- (void)destroy;

@end

NS_ASSUME_NONNULL_END
