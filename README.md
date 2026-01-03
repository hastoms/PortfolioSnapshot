# Portfolio Snapshot

A clean, professional iOS app for tracking stock portfolio holdings with real-time price updates.

![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![Platform](https://img.shields.io/badge/Platform-iOS%2017+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## Features

- **Add Holdings** - Track stocks with symbol, quantity (up to 4 decimal places), and purchase price
- **Optional Purchase Date** - Record when you bought each holding
- **Live Price Updates** - Pull-to-refresh to fetch current market prices
- **Gain/Loss Tracking** - See individual and total portfolio performance ($ and %)
- **Local Storage** - All data stored securely on-device using SwiftData
- **No Account Required** - Simple, privacy-focused design

## Screenshots

*Coming soon*

## Setup

### 1. Clone the Repository

```bash
git clone https://github.com/hastoms/PortfolioSnapshot.git
cd PortfolioSnapshot
```

### 2. Get a Twelve Data API Key (Free)

1. Go to [twelvedata.com](https://twelvedata.com)
2. Sign up for a free account
3. Copy your API key from the dashboard

### 3. Configure Your API Key

1. Copy the example secrets file:
   ```bash
   cp PortfolioSnapshot/Secrets.swift.example PortfolioSnapshot/Secrets.swift
   ```

2. Open `PortfolioSnapshot/Secrets.swift` and replace `YOUR_API_KEY_HERE` with your actual API key

3. Add `Secrets.swift` to your Xcode project (File → Add Files to "PortfolioSnapshot")

> ⚠️ **Important**: `Secrets.swift` is gitignored to keep your API key private. Never commit it to version control.

### 4. Build and Run

Open `PortfolioSnapshot.xcodeproj` in Xcode and run on your device or simulator.

## Tech Stack

- **SwiftUI** - Modern declarative UI framework
- **SwiftData** - Persistent local storage
- **Twelve Data API** - Real-time stock price data

## API Attribution

Market data provided by [Twelve Data](https://twelvedata.com).

## Project Structure

```
PortfolioSnapshot/
├── PortfolioSnapshotApp.swift  # App entry point
├── Holding.swift               # Data model
├── PortfolioView.swift         # Main portfolio screen
├── AddHoldingView.swift        # Add/edit holding forms
├── SettingsView.swift          # Settings & About screens
├── TwelveDataService.swift     # API integration
├── Secrets.swift               # API key (gitignored)
└── Secrets.swift.example       # Template for secrets
```

## License

MIT License - feel free to use this project as a reference or starting point for your own apps.

## Author

Tom Stevenson

---

*Built with ❤️ using SwiftUI*

