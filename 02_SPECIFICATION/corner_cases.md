# Corner Cases Specification

## 1. All Channels Inactive
**Input:** All four channels are `00`.

**Expected behavior:**
- `uo_out[4]` = `0`
- `uo_out[3:2]` = `00`
- `uo_out[1:0]` = `00`

## 2. Only One Active Channel
**Input:** Exactly one channel has a non-zero alarm level.

**Expected behavior:** The active channel and its alarm level are selected.

## 3. Multiple Channels at the Same Highest Level
**Input:** Two or more channels share the highest non-zero alarm level.

**Expected behavior:** The channel with the smallest index is selected.

## 4. Different Alarm Levels
**Input:** Channels have different non-zero alarm levels.

**Expected behavior:** The channel with the numerically highest alarm level is selected.

## 5. Highest-Level Tie with a Lower-Level Alarm
**Input:** Multiple channels share the highest level while other channels have lower levels.

**Expected behavior:** The lowest-index channel among those with the highest level is selected.

## 6. Maximum Alarm on Channel 3
**Input:** Channel 3 has the highest alarm level, and no lower-index channel has an equal or higher level.

**Expected behavior:** Channel index `11` is selected, with the corresponding alarm level and valid indicator asserted.
