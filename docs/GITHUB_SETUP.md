# GitHub setup: labels, milestones and issues

This is a ready-made list to create on github.com (**Issues** tab): one parent issue per screen
(`UI-xx`), with one sub-issue per functional requirement (`FR-xx`). Each issue gets a priority
label, a milestone and one assignee.

FR IDs, user stories, priorities and owners come from the **Proposal v1.0 (Tables 5 and 9)**.
Rows marked *(new – add to SRS)* are screens in the Figma design that the proposal doesn't list
yet; give them an FR ID in the SRS, then use that ID in the issue title.

## 1. Labels (Issues → Labels → New label)

| Name | Colour | Use |
|---|---|---|
| `Must` | `#f03234` | Must-have requirement |
| `Should` | `#fbca04` | Should-have requirement |
| `Could` | `#0052cc` | Could-have requirement |

The default labels (`bug`, `documentation`, `enhancement`…) can stay.

## 2. Milestones (Issues → Milestones → New milestone)

| Title | Description |
|---|---|
| Milestone 1 (M1) | Proposal & Requirements |
| Milestone 2 (M2) | Design and Prototype |
| Milestone 3 (M3) | Product & Verification |
| Milestone 4 (M4) | Final Release & Acceptance |

The clickable prototype of every screen is done, so the **UI parent issues** can go in M2 and be
closed. The **FR sub-issues** need the real backend (Supabase, DeepSeek, etc.), so they belong in M3.

## 3. Issues

Create the parent `UI-xx` issue first, then open it and use **Create sub-issue** for each FR row.

### Customer

| Parent issue | Sub-issue | Priority | Assignee | Milestone |
|---|---|---|---|---|
| **UI-01** Login | Register and log in, routed by role *(new – add to SRS)* | Must | Vickson | M3 |
| **UI-02** Home: van availability | **FR-01** Reserve a van for a date range | Must | Izzat | M3 |
| **UI-03** Booking form | **FR-02** Choose self-drive or with-driver | Must | Izzat | M3 |
| | **FR-10** Show the price per trip or per km | Must | Izzan | M3 |
| **UI-04** Upload + summary | **FR-03** Select destination and upload IC and rental forms | Must | Izzat | M3 |
| **UI-05** AI suggestions | **FR-AI-01** AI place recommendations for the trip | Must | Vickson | M3 |
| **UI-06** My bookings | View bookings and their live status *(new – add to SRS)* | Should | Izzat | M3 |

### Driver

| Parent issue | Sub-issue | Priority | Assignee | Milestone |
|---|---|---|---|---|
| **UI-07** Trip schedule | **FR-21** View assigned trips and schedule (+ notifications) | Should | Romeo | M3 |

### Admin (owner)

| Parent issue | Sub-issue | Priority | Assignee | Milestone |
|---|---|---|---|---|
| **UI-08** Admin dashboard | **FR-10** Manage pricing rules (per trip / per km) | Must | Izzan | M3 |
| **UI-09** Assign van & driver | **FR-20** Assign a driver and van to a booking with no clashes | Must | Vickson | M3 |
| **UI-10** Income & salary | **FR-30** Record income per trip and calculate driver salary | Must | Vickson | M3 |
| **UI-11** Booking review | Verify documents and deposit, then confirm *(new – add to SRS)* | Must | Izzat | M3 |

### Testing and process (label `documentation` where it fits)

| Issue | Assignee | Milestone |
|---|---|---|
| Test plan + LOGTEST: ≥ 50 test cases and ≥ 60% coverage for all Must-have FRs | Bryan | M3 |
| GitHub Actions CI/CD, secret scan and required pull-request checks | Bryan | M2 |
| Proposal (done – in `docs/Proposal`) | Romeo | M1 |
| SRS (put in `docs/SRS`) | Izzan | M1 / M2 |
| Slides (put in `docs/Slides`) | Romeo | M2 |
| SDS (put in `docs/SDS`) | Izzat | M3 |
| STD (put in `docs/STD`) | Bryan | M3 |
| Keep `process_forms/LOGAI.md` up to date | Vickson | M4 |

## 4. Working with branches and pull requests

Each change goes on its own branch and into `main` through a pull request, so the history shows
who did what:

1. In VS Code, click the branch name (bottom-left) → **Create new branch** → e.g. `feat/fr-03-real-upload`.
2. Commit your work, then **Publish Branch**.
3. On github.com, click **Compare & pull request**. In the description write `Closes #12` (the issue
   number) so the issue closes automatically when it is merged.
4. Wait for the green CI check, ask a teammate to review, then **Merge**.

Every member should commit their own work, so the GitHub contributor list reflects the whole team.
