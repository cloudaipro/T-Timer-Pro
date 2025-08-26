# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Building and Running
```bash
# Install CocoaPods dependencies (required after cloning)
pod install

# Open the workspace (always use .xcworkspace, not .xcodeproj)
open "T-Timer Pro.xcworkspace"

# Build from command line
xcodebuild -workspace "T-Timer Pro.xcworkspace" -scheme "T-Timer Pro" -configuration Debug build

# Build for device
xcodebuild -workspace "T-Timer Pro.xcworkspace" -scheme "T-Timer Pro" -configuration Release -destination "generic/platform=iOS" build
```

### Project Information
- **Target**: T-Timer Pro
- **Deployment Target**: iOS 13.0
- **Swift Version**: 5.0
- **Dependency Management**: CocoaPods
- **Main Workspace**: T-Timer Pro.xcworkspace

## Architecture Overview

### Reactive Programming Pattern
The app is built around RxSwift/RxCocoa reactive programming patterns:
- `BehaviorRelay` and `PublishRelay` for state management
- Reactive binding between UI components and data models
- Observable streams for timer events and user interactions

### Core Components Relationship

**TimeView (Custom UIView)**
- Central circular timer interface component
- Manages timer state through `BehaviorRelay<TimerStatus>` and `BehaviorRelay<CGFloat>` for seconds
- Handles drag gestures to set timer duration with complex angle-to-time calculations
- Emits `TimerEvent` through `PublishRelay` for different timer states (TIMEUP, LASTONEMINUTE, etc.)
- Uses SwiftDate `Region` for precise time calculations during countdown
- Supports multiple timer modes with different visual scales and snapping behaviors

**ViewController (Main Controller)**
- Subscribes to TimeView's reactive streams for coordinating app state
- Manages audio playback (AVAudioPlayer) and speech synthesis (AVSpeechSynthesizer)
- Handles background audio session configuration for timer alerts
- Controls UI state changes between START/STOP button modes

**State Management Pattern**
```swift
enum TimerStatus { SETTING, START, STOP }
enum TimerEvent { TIMEUP, LASTONEMINUTE, REWARDING, LASTSECOND(Int) }
```

### Mathematical Timer Logic
The TimeView implements sophisticated circular timer calculations:
- **radianPerSec**: Converts time to circular position (`2π / totalSeconds`)
- **Multi-mode snapping**: Different precision levels for 1min (1-second), 5min (15-second), 60min (5-minute), 120min (10-minute)
- **Angle calculations**: Uses CGPoint extensions for circle geometry and drag gesture interpretation
- **Tolerance handling**: Prevents edge cases when dragging near 0/full circle positions

### Dependency Architecture
- **RxSwift/RxCocoa (~4.5.0)**: Core reactive programming framework
- **SwiftDate**: Precise time calculation and countdown management
- **FaveButton**: Reward animation system with particle effects
- **Toucan**: Image processing for circular reward graphics
- **AVFoundation**: Audio playback and speech synthesis

### Custom UI Components
- **RoundButton**: `@IBDesignable` button with automatic corner radius calculation
- **TimeView**: Complex custom drawing with multiple background modes and arc rendering
- **CGPoint extensions**: Comprehensive circular geometry calculations for timer interface

## Code Patterns

### Reactive Bindings
When modifying reactive streams, follow the established pattern:
```swift
timeView.timerStatus
    .subscribe(onNext: { [unowned self] status in
        // Handle state changes
    }).disposed(by: disposeBag)
```

### Timer Mode Detection
Timer behavior changes based on total duration:
- Use `totalMins` and `totalSeconds` properties for mode detection
- Each mode has different drawing methods (`backgroundType60`, `backgroundType120`, etc.)
- Snapping tolerance varies by mode through `toleranceOfFull` calculations

### Audio Session Management
Audio handling requires proper AVAudioSession configuration for background playback and system integration.

## Key Files for Modifications

- **TimeView.swift**: Timer logic, drawing, gesture handling, and reactive state management
- **ViewController.swift**: App coordination, audio management, and UI state control  
- **TimeStatus.swift**: Core enumerations for timer states and events
- **CGPoint+Extension.swift**: Circular mathematics and geometry utilities