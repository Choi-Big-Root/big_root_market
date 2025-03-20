#!/bin/bash

echo "[START] Flutter Dependency Check Start"

# 1. Outdated 패키지 목록 확인
echo "Checking for outdated dependencies..."
flutter pub outdated

# 2. Major 버전 포함 전체 업그레이드
echo "Upgrading all dependencies (including major versions)..."
flutter pub upgrade --major-versions

# 3. pub get 실행
echo "Running flutter pub get..."
flutter pub get

# 4. 코드 분석
echo "Analyzing project..."
flutter analyze
if [ $? -ne 0 ]; then
  echo "[FAIL] Analyze failed. Please check your code."
  exit 1
fi

# 5. 유닛 테스트 실행
#echo "Running flutter tests..."
#flutter test
#if [ $? -ne 0 ]; then
#  echo "[FAIL]Test failed. Please check test results."
#  exit 1
#fi

# 6. (선택) Integration test 실행
if [ -d "integration_test" ]; then
  echo "Running integration tests..."
  flutter test integration_test/
  if [ $? -ne 0 ]; then
    echo "[FAIL]Integration test failed. Please check results."
    exit 1
  fi
fi

echo "[SUCCESS] All checks passed! Dependencies updated and verified."
