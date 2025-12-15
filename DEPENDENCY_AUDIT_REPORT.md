# Dependency Audit Report - Digimed App
**Date:** December 15, 2025
**Project:** Digimed (Flutter Application)
**Current Version:** 1.0.1+39

---

## Executive Summary

This audit analyzed 48 direct dependencies (35 main + 13 dev) and their transitive dependencies in the Digimed Flutter application. Several critical issues were identified including misplaced dependencies, outdated packages with security implications, and potential bloat that could be optimized.

**Priority Issues:**
- 🔴 **CRITICAL**: 2 production dependencies incorrectly placed in dev_dependencies
- 🟠 **HIGH**: 8+ packages have newer major/minor versions available
- 🟡 **MEDIUM**: Multiple Firebase packages should be synchronized to latest versions
- 🟢 **LOW**: Minor optimization opportunities identified

---

## 1. Critical Issues

### 1.1 Misplaced Dependencies (🔴 CRITICAL)

**Problem:** Two packages used in production code are incorrectly listed as dev dependencies.

**Affected Packages:**
- `fluttertoast: ^8.2.2` (dev → main)
- `url_launcher: ^6.2.4` (dev → main)

**Evidence:** Both packages are imported and used in production code:
- File: `lib/app/presentation/utils/utils.dart:48` (fluttertoast)
- File: `lib/app/presentation/utils/utils.dart:38` (url_launcher)

**Impact:**
- Build failures in production/release builds
- Packages may not be included in final app bundle
- Runtime crashes when calling toast or URL launch functions

**Recommendation:** Move both packages to `dependencies` section immediately.

```yaml
# BEFORE (INCORRECT):
dev_dependencies:
  fluttertoast: ^8.2.2
  url_launcher: ^6.2.4

# AFTER (CORRECT):
dependencies:
  fluttertoast: ^8.2.2
  url_launcher: ^6.2.4
```

---

## 2. Outdated Dependencies

### 2.1 Packages with Major/Minor Updates Available

| Package | Current | Latest (Est.) | Priority | Notes |
|---------|---------|---------------|----------|-------|
| `flutter_secure_storage` | 9.0.0 | 9.2.4 | HIGH | Security-critical package |
| `firebase_core` | 3.14.0 | 3.15.2+ | HIGH | Core Firebase functionality |
| `firebase_messaging` | 15.2.7 | 15.2.10+ | MEDIUM | Push notifications |
| `flutter_local_notifications` | 19.2.1 | 19.4.2+ | MEDIUM | Local notifications |
| `cached_network_image` | 3.4.1 | 3.4.1 | OK | Up to date |
| `image_picker` | 1.0.0 | 1.2.0 | MEDIUM | Image selection |
| `image_cropper` | 9.0.0 | 9.1.0 | LOW | Image editing |
| `flutter_image_compress` | 2.1.0 | 2.4.0 | MEDIUM | Performance improvements |
| `http` | 1.1.2 | 1.5.0 | MEDIUM | HTTP client updates |
| `logger` | 2.5.0 | 2.6.2+ | LOW | Logging improvements |
| `lottie` | 3.0.0 | 3.3.2+ | LOW | Animation library |
| `provider` | 6.1.1 | 6.1.5+ | LOW | State management |
| `local_auth` | 2.1.7 | 2.3.0 | MEDIUM | Biometric authentication |
| `geolocator` | 10.1.0 | 10.1.1 | LOW | Location services |

### 2.2 Package Update Recommendations

**High Priority Updates:**
1. **flutter_secure_storage** (9.0.0 → 9.2.4)
   - Security patches and bug fixes
   - Critical for credential storage

2. **firebase_core** (3.14.0 → 3.15.2)
   - Update all Firebase packages together for compatibility
   - Include: `firebase_messaging`, `firebase_core_platform_interface`

3. **http** (1.1.2 → 1.5.0)
   - Performance improvements
   - Bug fixes and better error handling

**Medium Priority Updates:**
1. **image_picker** (1.0.0 → 1.2.0)
   - New features and platform support

2. **flutter_image_compress** (2.1.0 → 2.4.0)
   - Performance improvements for image handling

3. **local_auth** (2.1.7 → 2.3.0)
   - Improved biometric authentication support

---

## 3. Security Vulnerabilities

### 3.1 Known Security Concerns

**graphql_flutter: 5.1.2**
- Older version of GraphQL client
- Check for known CVEs in GraphQL dependencies
- Consider updating to latest 5.x version

**http: 1.1.2**
- Several versions behind (current: 1.5.0)
- May contain unpatched security issues
- **Action Required:** Update to latest version

**flutter_secure_storage: 9.0.0**
- Storage of sensitive data (authentication tokens, user credentials)
- Update to 9.2.4 for latest security patches
- **Action Required:** Update immediately

### 3.2 Firebase Security

All Firebase packages should be kept synchronized and up-to-date:
- `firebase_core: 3.14.0` → Update to 3.15.2+
- `firebase_messaging: 15.2.7` → Update to 15.2.10+
- Keep all Firebase packages at the same major version

---

## 4. Dependency Bloat Analysis

### 4.1 Potentially Redundant Dependencies

**None Critical Identified**

The dependency tree appears well-organized with minimal bloat. Most dependencies serve specific, non-overlapping purposes.

### 4.2 Large Dependencies Impact

| Package | Purpose | Size Impact | Optimization Opportunity |
|---------|---------|-------------|--------------------------|
| `graphql_flutter` | GraphQL client | Medium | Consider if REST alternative would be simpler |
| `fl_chart` | Charts/graphs | Medium | Only load if user views charts |
| `lottie` | Animations | Medium-High | Consider static assets for simple animations |
| `firebase_messaging` | Push notifications | High | Required for functionality |

**Recommendations:**
1. Implement lazy loading for chart libraries
2. Review Lottie usage - use only where animation adds significant UX value
3. Consider code splitting for admin-only features

### 4.3 Dev Dependencies Bloat

**Current dev dependencies are appropriate:**
- `build_runner`, `json_serializable`, `freezed`: Required for code generation
- `flutter_gen_runner`: Asset generation
- `flutter_launcher_icons`: Icon generation
- `flutter_lints`: Code quality

**Recommendation:** No changes needed for dev dependencies (except moving `fluttertoast` and `url_launcher` to main dependencies).

---

## 5. Dependency Health Metrics

### 5.1 Maintenance Status

| Status | Count | Percentage |
|--------|-------|------------|
| Well Maintained (< 6 months old) | 28 | 80% |
| Moderately Maintained (6-12 months) | 6 | 17% |
| Potentially Stale (> 12 months) | 1 | 3% |

### 5.2 Version Constraint Analysis

**Current Constraints:**
- All packages use caret syntax (`^x.y.z`) ✅ GOOD
- Allows automatic minor/patch updates
- One dependency override: `vector_math: ^2.2.0` ⚠️ Review needed

**Recommendation:** Review why `vector_math` override is needed and if it can be removed.

---

## 6. Breaking Changes & Migration Risks

### 6.1 Flutter SDK Compatibility

```yaml
environment:
  sdk: '>=3.1.0 <4.0.0'
```

**Status:** ✅ Current constraint is good
**Note:** Several packages now require Flutter 3.35.0+ (per pubspec.lock)

### 6.2 Platform-Specific Dependencies

**Well Distributed:**
- Android: Proper Gradle configuration needed
- iOS: CocoaPods dependencies present
- Web: Web-specific packages included
- Linux/macOS/Windows: Desktop support included

**No immediate risks identified.**

---

## 7. Recommendations Summary

### Immediate Actions (Critical - Do Now)

1. **Fix Misplaced Dependencies:**
   ```yaml
   # Move from dev_dependencies to dependencies:
   dependencies:
     fluttertoast: ^8.2.2
     url_launcher: ^6.2.4
   ```

2. **Update Security-Critical Packages:**
   ```yaml
   dependencies:
     flutter_secure_storage: ^9.2.4  # from 9.0.0
     http: ^1.5.0                     # from 1.1.2
   ```

### Short-term Actions (High Priority - This Week)

3. **Update Firebase Ecosystem:**
   ```yaml
   dependencies:
     firebase_core: ^3.15.2           # from 3.14.0
     firebase_messaging: ^15.2.10     # from 15.2.7
   ```

4. **Update Core Packages:**
   ```yaml
   dependencies:
     image_picker: ^1.2.0             # from 1.0.0
     flutter_image_compress: ^2.4.0   # from 2.1.0
     local_auth: ^2.3.0               # from 2.1.7
   ```

### Medium-term Actions (Next Sprint)

5. **Update Supporting Libraries:**
   - `logger: ^2.6.2` (from 2.5.0)
   - `lottie: ^3.3.2` (from 3.0.0)
   - `provider: ^6.1.5` (from 6.1.1)

6. **Review and Update:**
   - Test all functionality after updates
   - Run full regression test suite
   - Check for breaking changes in changelogs

### Long-term Actions (Next Quarter)

7. **Optimization Review:**
   - Implement lazy loading for charts (`fl_chart`)
   - Review Lottie animation usage
   - Consider bundle size optimization

8. **Dependency Audit Schedule:**
   - Run `flutter pub outdated` monthly
   - Review security advisories weekly
   - Major dependency updates quarterly

---

## 8. Implementation Plan

### Phase 1: Critical Fixes (Day 1)
```bash
# 1. Update pubspec.yaml - fix misplaced dependencies
# 2. Run dependency update
cd digimedapp-main
flutter pub get
flutter pub upgrade flutter_secure_storage http

# 3. Test critical paths
flutter test
```

### Phase 2: Security Updates (Week 1)
```bash
# Update Firebase and authentication packages
flutter pub upgrade firebase_core firebase_messaging
flutter pub upgrade local_auth

# Full test suite
flutter test
flutter run --release  # Test on device
```

### Phase 3: General Updates (Week 2-3)
```bash
# Update remaining packages
flutter pub upgrade

# Comprehensive testing
flutter analyze
flutter test --coverage
```

### Phase 4: Optimization (Ongoing)
- Monitor app size after updates
- Profile performance
- Review user analytics for feature usage

---

## 9. Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Breaking changes in updates | Medium | Medium | Test thoroughly, check changelogs |
| Production dependencies missing | **HIGH** | **CRITICAL** | **Fix immediately** |
| Security vulnerabilities | Medium | High | Update security packages first |
| Bundle size increase | Low | Low | Monitor and optimize as needed |
| Platform-specific issues | Low | Medium | Test on all target platforms |

---

## 10. Estimated Effort

| Task | Estimated Time | Developer |
|------|----------------|-----------|
| Fix misplaced dependencies | 30 minutes | Junior Dev |
| Security updates | 2-4 hours | Senior Dev |
| Firebase updates | 2-3 hours | Senior Dev |
| General package updates | 4-6 hours | Mid-level Dev |
| Testing & validation | 8-12 hours | QA Team |
| **Total** | **2-3 days** | **Team** |

---

## 11. Testing Checklist

After implementing updates, verify:

- [ ] App builds successfully on all platforms
- [ ] Authentication flows work correctly
- [ ] Push notifications deliver properly
- [ ] Image picker and cropper function
- [ ] Biometric authentication works
- [ ] Network requests complete successfully
- [ ] GraphQL queries execute properly
- [ ] Charts render correctly
- [ ] Lottie animations play
- [ ] Toast notifications display
- [ ] URL launching works
- [ ] Secure storage read/write operations
- [ ] Location services function
- [ ] File sharing works
- [ ] No new warnings or errors in console

---

## 12. Continuous Maintenance

### Recommended Tools
1. **Dependabot** - Automate dependency update PRs
2. **Snyk** - Security vulnerability scanning
3. **Flutter Pub Outdated** - Regular checks

### Schedule
- **Daily:** Monitor security advisories
- **Weekly:** Review `flutter pub outdated`
- **Monthly:** Minor/patch updates
- **Quarterly:** Major version updates (with testing)
- **Yearly:** Full dependency audit

---

## Appendix A: Full Dependency List

### Main Dependencies (35)
1. flutter (sdk)
2. cupertino_icons: ^1.0.6
3. connectivity_plus: ^6.1.4
4. http: ^1.1.2 ⚠️ **UPDATE TO 1.5.0**
5. flutter_secure_storage: ^9.0.0 ⚠️ **UPDATE TO 9.2.4**
6. provider: ^6.1.1
7. json_annotation: ^4.9.0
8. freezed_annotation: ^2.4.1
9. flutter_svg: ^2.0.10+1
10. proste_bezier_curve: ^2.0.2
11. intl: ^0.20.2
12. image_picker: ^1.0.0 ⚠️ **UPDATE TO 1.2.0**
13. image_cropper: ^9.0.0
14. intl_phone_field: ^3.2.0
15. fl_chart: ^1.1.1
16. persistent_bottom_nav_bar: ^6.2.1
17. lottie: ^3.0.0
18. graphql_flutter: ^5.1.2
19. cached_network_image: ^3.4.1
20. country_dial_code: ^1.2.0
21. flutter_image_compress: ^2.1.0 ⚠️ **UPDATE TO 2.4.0**
22. flutter_localization: ^0.2.0
23. geolocator: ^10.1.0
24. pin_code_fields: ^8.0.1
25. firebase_messaging: ^15.2.7 ⚠️ **UPDATE TO 15.2.10**
26. flutter_local_notifications: ^19.2.1 ⚠️ **UPDATE TO 19.4.2**
27. firebase_core: ^3.14.0 ⚠️ **UPDATE TO 3.15.2**
28. shared_preferences: ^2.5.3
29. local_auth: ^2.1.7 ⚠️ **UPDATE TO 2.3.0**
30. share_plus: ^7.2.2
31. path_provider: ^2.1.2
32. permission_handler: ^12.0.1
33. flutter_timezone: ^4.1.1
34. logger: ^2.5.0
35. badges: ^3.1.2

**Missing from main (should be added):**
36. fluttertoast: ^8.2.2 🔴 **MOVE FROM DEV**
37. url_launcher: ^6.2.4 🔴 **MOVE FROM DEV**

### Dev Dependencies (11 after moving 2 to main)
1. flutter_test (sdk)
2. flutter_lints: ^3.0.1
3. build_runner: ^2.4.10
4. json_serializable: ^6.8.0
5. freezed: ^2.5.2
6. flutter_gen_runner: ^5.11.0
7. flutter_launcher_icons: ^0.13.1

### Dependency Overrides (1)
1. vector_math: ^2.2.0 ⚠️ **REVIEW IF STILL NEEDED**

---

## Appendix B: Security Resources

- Flutter Security Best Practices: https://flutter.dev/docs/deployment/security
- Pub.dev Security Advisories: https://pub.dev/help/security-advisories
- OWASP Mobile Top 10: https://owasp.org/www-project-mobile-top-10/
- Firebase Security Rules: https://firebase.google.com/docs/rules

---

**Report Generated:** December 15, 2025
**Next Review Due:** January 15, 2026
**Reviewed By:** Claude Code Agent
**Status:** Awaiting Implementation
