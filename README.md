# STFIL Wallet

STFIL wallet, which provides professional wallet management and message signing for Filecoin storage providers. The STFIL wallet disables the network and is safe and reliable offline.

# Introduction of  product

The future of the Filecoin ecosystem and the Web3 network is highly anticipated. The Filecoin nv18 network upgrade supports the writing and publishing of smart contracts, which means that the Filecoin network has transformed data value from storage to flow. It is necessary to provide storage providers with a purer wallet that supports offline message signatures to facilitate message processing and on-chain.

The current features STFIL Wallet supports are:

- Android & IOS - download and install
- Create wallet, import mnemonic words and import private key;
- Locally store and encrypt the private key
- Address list management
- Multiple wallet management (add, switch, etc.)
- Private key backup
- Information transmission via QR code on different devices
- Cold Wallet
- Support f1 (secp256k1) & f3 (BLS)
- Multilingual support (Chinese, English, Japanese, Korean) 

## How to run

## How to switch network

We support Filecoin mainnet and calibration network. If you want to run this app in different network, you can find the file at `lib->common->global.dart` and edit the value of variable NetPrefix. The value of mainnet is 'f' and calibration is 't'.

## Run Unit Test

`flutter test`

## How to build

### Android

Just run `flutter build apk`

### IOS

- Run `flutter build ios`
- Open the ios directory in Xcode
- Click Product -> Archive 

# How to use

Check [STFIL Wallet Documentation](https://docs.stfil.io/docs/guides/user/stake)

## License

[MIT](https://github.com/FiveToken/FiveToken-Pro/blob/master/LICENSE)

## Links

[Project structure](./doc/code-tree.txt)

[Design documents](./doc/impl.md)


# Android packaging

```shell
cd android
./gradlew assembleRelease

```

# Wlib attention

Packaging wlib (Go) iOS version cannot be packaged with M1 (ARM64) computer, otherwise there will be problems compiling ios and packaging ios

Android only needs to replace the wlib file in flotus, then modify the git version number in the pubspec.yaml of this project and package it
iOS also needs to additionally replace the wlib package under ios in this project to avoid strange problems
