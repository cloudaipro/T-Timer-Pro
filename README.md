# T-Timer Pro

A feature-rich iOS timer application built with Swift, featuring a circular visual timer interface with customizable duration settings.

## Features

- **Visual Circular Timer**: Interactive circular timer interface with drag-to-set functionality
- **Multiple Duration Modes**: Support for 1 minute, 5 minutes, 60 minutes, and 120-minute timer modes
- **Audio Feedback**: Voice announcements for "one minute left" and final countdown seconds
- **Custom Sounds**: Classical music (Alla Turca) plays when timer completes
- **Holiday Theme**: Christmas-themed reward animations with Santa imagery
- **Responsive UI**: Clean, modern interface with custom colors and animations
- **Start/Stop Controls**: Easy-to-use start and stop functionality with visual feedback

## Technical Stack

- **Language**: Swift 5
- **Framework**: UIKit
- **Architecture**: Reactive programming with RxSwift/RxCocoa
- **Dependencies**: CocoaPods
- **Minimum iOS Version**: iOS 13.0+

## Dependencies

The app uses several third-party libraries managed through CocoaPods:

- `RxSwift` & `RxCocoa` (~4.5.0) - Reactive programming
- `RxDataSources` - Collection view data binding
- `Action` - Action-based reactive programming
- `RxKeyboard` - Keyboard event handling
- `RxBiBinding` - Bidirectional data binding
- `Moya/RxSwift` (~13.0) - Network abstraction layer
- `SwiftDate` - Date and time manipulation
- `Runtime` - Swift runtime inspection
- `Toucan` - Image processing and masking
- `FaveButton` - Animated favorite button with particle effects

## Project Structure

```
T-Timer Pro/
├── AppDelegate.swift          # App lifecycle management
├── SceneDelegate.swift        # Scene-based app lifecycle (iOS 13+)
├── ViewController.swift       # Main timer controller
├── TimeView.swift            # Custom circular timer view
├── RoundButton.swift         # Custom rounded button component
├── TimeStatus.swift          # Timer state enumeration
├── CGPoint+Extension.swift   # Core Graphics extensions
├── Assets.xcassets/          # App icons, images, and color assets
├── Base.lproj/              # Storyboard files
├── Sounds/                  # Audio assets
└── FaveButton/              # Custom animated button components
```

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/T-Timer-Pro.git
cd T-Timer-Pro
```

2. Install dependencies using CocoaPods:
```bash
pod install
```

3. Open the workspace file:
```bash
open "T-Timer Pro.xcworkspace"
```

4. Build and run the project in Xcode.

## Usage

### Setting Timer Duration
- Drag around the circular interface to set your desired timer duration
- The app supports different modes: 1 min, 5 min, 60 min, and 120 min
- Visual feedback shows the selected time with minute and second display

### Starting/Stopping Timer
- Tap the "START" button to begin countdown
- Button changes to "STOP" with visual color feedback
- Timer can be paused and resumed

### Audio Features
- Voice announcement when one minute remains
- Countdown voice for final 5 seconds (on 1-minute mode)
- Classical music plays when timer reaches zero
- Automatic volume adjustment for alerts

### Reward System
- Christmas-themed animations appear when timer completes
- Interactive particle effects using FaveButton library
- Santa Claus imagery for seasonal theming

## Key Components

### TimeView Class
Custom UIView that handles:
- Circular timer visualization
- Touch gesture recognition for time setting
- Reactive data binding with RxSwift
- Multiple timer mode support (60s, 5min, 60min, 120min)

### ViewController Class
Main controller managing:
- Timer state coordination
- Audio playback and speech synthesis
- UI updates and user interactions
- Background audio session management

## Timer Modes

1. **1 Minute (60 seconds)**: Precise second-by-second control
2. **5 Minutes**: 15-second increment snapping
3. **60 Minutes**: 5-minute increment snapping  
4. **120 Minutes**: 10-minute increment snapping

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Requirements

- iOS 13.0+
- Xcode 11.0+
- Swift 5.0+
- CocoaPods 1.8.0+

## Acknowledgments

- RxSwift community for reactive programming support
- FaveButton library for beautiful animations
- SwiftDate for elegant date/time handling