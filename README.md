# App Attest Demo

Ensure that requests your server receives come from legitimate instances of your app using Apple’s App Attest - part of the [DeviceCheck framework](https://developer.apple.com/documentation/devicecheck/establishing-your-app-s-integrity).

## About

This sample code accompanies a talk about the Device Check framework which covered:

- Features of the DeviceCheck framework
- Basics of Asymmetric Cryptography
- Implementation of App Attest (this repository)
- Draft Industry Standards: [OAuth 2.0 Attestation-Based Client Authentication](https://www.ietf.org/archive/id/draft-ietf-oauth-attestation-based-client-auth-01.html)

The talk was given at NSLondon on 21st November, 2024 at Apple Battersea, you can find the [slides from the talk here](https://drive.google.com/file/d/1Bx-3Ts1zYVSgcdLraWfK6gt_nwhoNHWb/view?usp=share_link).

## Progress

This implementation currently covers:

- [x] Generating an App Attest key in Secure Enclave | App
- [x] Serving a challenge from server to app | Server
- [x] Attesting a key for the given challenge | App
- [x] Submitting the Attestation Object to the server | App
- [x] Receiving the Attestation Object from the app | Server
- [x] Decoding the Attestation Object for validation | Server
- [x] Validing the Attestation Object | Server
- [ ] Acquiring fraud metrics from Apple using the receipt | Server
- [ ] Storing Attestation Key for future assertions | Server
- [x] Generating assertion objects for authentication | App
- [x] Submitting the Assertion Object to the server | App
- [ ] Receiving the Assertion Object from the app | Server
- [ ] Decoding the Assertion Object for validation | Server
- [ ] Validating the Assertion Object | Server
- [ ] Make `AttestationDecoding` & `AttestationValidation` targets available as a Swift Package

## Requirements

- iOS 14.0+
- Latest version of Xcode
- Swift 5.0+

## Getting Started

1. Clone the repository
```bash
git clone https://github.com/Oliver-Binns/app-attest.git
```

2. Open the project in Xcode
3. Build and run the sample application

## Contributing

Pull requests and feature requests are welcome - this sample code is developed fully in the open.

SwiftLint is run against all code, please ensure you have this installed so that pre-commit hooks can run successfully.

[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) are required for each pull request to ensure that release versioning can be managed automatically.
Please ensure that you have enabled the Git hooks, so that you don't get caught out!:
```
git config core.hooksPath hooks
```

The progress section above covers some future enhancements that you could contribute.

## Additional Resources

- [DeviceCheck | Apple Developer Documentation](https://developer.apple.com/documentation/devicecheck)
- [WWDC21 - Mitigate fraud with App Attest and DeviceCheck](https://developer.apple.com/videos/play/wwdc2021/10244/)

## About the Author

Oliver is an experienced mobile software engineer based in London. After attaining an IET accredited master’s degree in Computer Science from the University of York, he started his career building websites in PHP and JavaScript, before pivoting into native iOS development. He has led teams to scale apps from first lines of code to #1 on the App Store and Google Play Store.
