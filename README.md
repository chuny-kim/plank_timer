
# Plank Timer Flutter Project

## 빌드 방법 (Android APK)

1. Flutter SDK가 설치되어 있는지 확인 (`flutter --version`).
   - 설치: https://docs.flutter.dev/get-started/install

2. 프로젝트 폴더로 이동
   ```bash
   cd plank_timer
   flutter pub get
   ```

3. 에뮬레이터나 USB 디바이스 연결 후 디버그 실행
   ```bash
   flutter run
   ```

4. 릴리스 APK 빌드
   ```bash
   flutter build apk --release
   ```
   결과물: `build/app/outputs/flutter-apk/app-release.apk`

5. `app-release.apk` 파일을 휴대폰에 복사하여 설치하거나,
   `flutter install` 로 바로 설치 가능합니다.

## 커스텀 사운드
- `assets/sounds/ding.mp3` 파일은 빈 파일입니다.
- 원하는 효과음 mp3로 교체하세요.
