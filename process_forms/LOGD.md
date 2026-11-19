# LOGD – Defect Recording Log

Types (TSPi): Documentation, Syntax, Build, Assignment, Interface, Checking, Data, Function, System, Environment.
Phases: REQ = requirements (SRS), DES = design (Figma), CODE, REV = review, TEST.

## M2 – Requirement Specification

| No | Date | Type | Injected | Removed | Fix time (min) | Status | Description |
|---|---|---|---|---|---|---|---|
| 1 | 20/11/2026 | Documentation | REQ | REV | | Fixed | SRS cover pointed to `/docs/SRS.md`, but the repository folder is `/docs/SRS/`. |
| 2 | 20/11/2026 | Documentation | REQ | REV | | Fixed | Linked Proposal field was left as a placeholder; set to Proposal v1.0, 16/10/2026. |
| 3 | 20/11/2026 | Documentation | REQ | REV | | Fixed | TSPi role titles in the SRS did not match the proposal. |
| 4 | 20/11/2026 | Documentation | REQ | REV | | Fixed | Revision History dates did not match the client sign-off date (16/11/2026). |
| 5 | 20/11/2026 | Function | REQ | REV | | Open | Three designed screens (Login, My bookings, Booking review) have no FR ID in the requirements. |
| 6 | 20/11/2026 | Interface | CODE | REV | | Fixed | Home: "Available" status pill stretched across the card instead of fitting its text. |
| 7 | 20/11/2026 | Interface | CODE | REV | | Fixed | Driver screens: bottom navigation floated mid-screen when content was short. |
| 8 | 20/11/2026 | Function | CODE | REV | | Fixed | Admin "Bookings" tab opened a list screen not in the design; now opens Booking review (UI-11). |
| 9 | 20/11/2026 | Data | CODE | REV | | Fixed | Admin and Driver profiles showed placeholder text instead of the Figma content. |
| 10 | 20/11/2026 | Interface | CODE | REV | | Fixed | Top spacing was 24 px smaller than the Figma design in the browser. |
| 11 | 20/11/2026 | Interface | CODE | TEST | | Fixed | `InfoRow` overflowed with long labels or large system text (found by widget test). |
| 12 | 20/11/2026 | Interface | CODE | REV | | Fixed | Income ledger titles wrapped onto two lines. |
