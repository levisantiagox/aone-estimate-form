# A-One Fencing — Instant Estimate Form Setup Guide

## Files Created

| File | Purpose |
|------|---------|
| `index.html` | Complete multi-step form (HTML/CSS/JS) |
| `n8n-workflow-import.json` | n8n workflow to import — handles GHL contact, opportunity, SMS, hot lead alerts |

---

## STEP 1: Create GHL Custom Fields

Go to **GHL > Settings > Custom Fields > Contact** in the A-One Fencing sub-account.
Create each field below. The **Field Key** must match exactly — it's how the form maps data.

| # | Field Label | Field Key | Field Type |
|---|------------|-----------|------------|
| 1 | Property Type | `property_type` | Dropdown: `Residential`, `Commercial`, `Strata / Body Corporate`, `Rural / Acreage` |
| 2 | Property Owner Status | `property_owner_status` | Dropdown: `Yes`, `No, I am a tenant`, `I am a builder / developer` |
| 3 | Service Types Requested | `service_types_requested` | Multi-select: `New fence installation`, `New gate installation`, `Pool fencing (glass)`, `Shower screens` |
| 4 | Fence Material | `fence_material` | Dropdown: `Colorbond`, `PVC`, `Timber`, `Aluminium (standard)`, `Not sure yet` |
| 5 | Fence Height | `fence_height` | Dropdown: `1.2m (4 foot)`, `1.5m (5 foot)`, `1.8m (6 foot) - Most common`, `2.1m (7 foot)`, `Not sure yet` |
| 6 | Fence Length Range | `fence_length_range` | Dropdown: `Under 10 metres`, `10 - 20 metres`, `20 - 40 metres`, `40 - 60 metres`, `60 - 100 metres`, `100+ metres`, `Not sure` |
| 7 | Existing Fence Removal | `existing_fence_removal` | Dropdown: `Yes, existing fence needs full removal`, `Yes, partial removal needed`, `No existing fence`, `Not sure` |
| 8 | Gate Type | `gate_type` | Dropdown: `Pedestrian gate (single)`, `Double gate`, `Sliding gate`, `Swing gate (automated)`, `Electric / motorised gate`, `Not sure yet` |
| 9 | Gate Material | `gate_material` | Dropdown: `Colorbond`, `Aluminium`, `Timber`, `Match my fence`, `Not sure yet` |
| 10 | Number of Gates | `number_of_gates` | Dropdown: `1`, `2`, `3+` |
| 11 | Pool Fence Type | `pool_fence_type` | Dropdown: `Frameless glass`, `Semi-frameless glass`, `Aluminium pool fencing`, `Not sure yet` |
| 12 | Pool Fence Length Range | `pool_fence_length_range` | Dropdown: `Under 10 metres`, `10 - 15 metres`, `15 - 25 metres`, `25+ metres`, `Not sure` |
| 13 | Pool Status | `pool_status` | Dropdown: `Existing pool`, `New pool under construction`, `Planning / design stage` |
| 14 | Council Compliance Required | `council_compliance_required` | Dropdown: `Yes`, `No`, `Not sure` |
| 15 | Shower Screen Type | `shower_screen_type` | Dropdown: `Frameless`, `Semi-frameless`, `Framed`, `Not sure yet` |
| 16 | Shower Screen Configuration | `shower_screen_configuration` | Dropdown: `Single fixed panel`, `Single door`, `Door + fixed panel`, `Corner entry (2 doors)`, `Bath screen`, `Not sure` |
| 17 | Number of Shower Screens | `number_of_shower_screens` | Dropdown: `1`, `2`, `3+` |
| 18 | Ground Conditions | `ground_conditions` | Dropdown: `Flat`, `Slight slope`, `Steep slope`, `Rocky or hard ground`, `Sandy or soft ground`, `Not sure` |
| 19 | Site Access Difficulty | `site_access_difficulty` | Dropdown: `Easy (clear driveway or open yard)`, `Moderate (side access, some obstacles)`, `Difficult (rear access only, narrow paths)`, `Not sure` |
| 20 | Council/Boundary Considerations | `council_boundary_considerations` | Dropdown: `No`, `Yes, boundary dispute`, `Yes, council approval needed`, `Yes, heritage overlay or restrictions`, `Not sure` |
| 21 | Project Timeline | `project_timeline` | Dropdown: `ASAP`, `Within 2 weeks`, `Within 1-2 months`, `3+ months`, `Just exploring options` |
| 22 | Lead Source | `lead_source` | Dropdown: `Google search`, `Facebook / Instagram`, `Recommendation from a friend`, `Seen our work in the area`, `Other` |
| 23 | Additional Notes | `additional_notes` | Large Text |

---

## STEP 2: Import n8n Workflow

1. Open your n8n instance
2. Go to **Workflows > Import from File**
3. Select `n8n-workflow-import.json`
4. On each HTTP Request node, set the credential to your **GHL API key** (Header Auth, header name: `Authorization`, value: `Bearer YOUR_GHL_API_KEY`)
5. On the **"Alert Operator - Hot Lead"** node, replace `REPLACE_WITH_KYLE_CONTACT_ID_OR_OPERATOR_PHONE` with Kyle's GHL contact ID or set up as an internal notification
6. **Activate the workflow**
7. Copy the two webhook URLs:
   - Partial: `https://your-n8n.com/webhook/aone-estimate-partial`
   - Submit: `https://your-n8n.com/webhook/aone-estimate-submit`

---

## STEP 3: Configure the Form

Open `index.html` and update the CONFIG object near the top of the `<script>` section:

```javascript
const CONFIG = {
  webhookPartial: 'https://your-n8n.com/webhook/aone-estimate-partial',
  webhookSubmit: 'https://your-n8n.com/webhook/aone-estimate-submit',
  pipelineId: 'M8uFU74BGphAKFVw6VFp',
  stageId: '27556b70-1712-483b-a0b5-8402d7d8c325'
};
```

### Optional: Google Places Autocomplete

Uncomment the script tag at the bottom of `index.html` and replace `YOUR_API_KEY`:

```html
<script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&libraries=places&callback=initGooglePlaces" async defer></script>
```

---

## STEP 4: Deploy

### Option A: GHL Hosted Page (Recommended)
1. In GHL, go to **Sites > Funnels** or **Sites > Websites**
2. Create a new page
3. Add a **Custom Code** element
4. Paste the entire `index.html` content
5. Use the funnel/page URL as the embed source

### Option B: Squarespace Embed
1. Host `index.html` on any static host (Netlify, Vercel, GitHub Pages, or GHL)
2. On Squarespace, add a **Code Block** or **Embed Block** with:
```html
<iframe src="https://your-hosted-url.com/index.html" width="100%" height="800" frameborder="0" style="border:none;max-width:620px;margin:0 auto;display:block;"></iframe>
```

### Page-Specific Embeds (URL Parameters)

| Page | URL Parameter | Effect |
|------|--------------|--------|
| Colorbond fencing page | `?service=fence&material=Colorbond` | Pre-selects fence + Colorbond |
| PVC fencing page | `?service=fence&material=PVC` | Pre-selects fence + PVC |
| Pool fencing page | `?service=pool` | Pre-selects pool fencing |
| Shower screens page | `?service=shower` | Pre-selects shower screens |
| Gate page | `?service=gate` | Pre-selects gate installation |

---

## STEP 5: GHL Tags to Create

Ensure these tags exist in GHL (they'll be auto-applied by the workflow):

- `Website Form - Partial`
- `Website Form - Complete`
- `Hot Lead`
- `Warm Lead`
- `Nurture`
- `Long-Term Nurture`
- `Source - Google search`
- `Source - Facebook / Instagram`
- `Source - Recommendation from a friend`
- `Source - Seen our work in the area`
- `Source - Other`

---

## STEP 6: Build Follow-Up Workflows in GHL

These are separate GHL workflows (not covered by the n8n webhook) that should be built natively in GHL:

### Hot Lead Sequence (tag: Hot Lead)
- T+0: SMS + Email (handled by n8n)
- T+1hr: Internal escalation if no operator contact logged
- T+4hrs: Second SMS follow-up
- T+24hrs: Internal flag if estimate not sent

### Warm Lead Sequence (tag: Warm Lead)
- T+0: SMS + Email (handled by n8n)
- T+24hrs: Estimate sent
- T+48hrs: Follow-up SMS on estimate
- T+5 days: Second follow-up
- T+10 days: Value-add follow-up

### Nurture Sequence (tags: Nurture, Long-Term Nurture)
- T+0: SMS + Email (handled by n8n)
- T+24hrs: Estimate sent
- T+3 days: Follow-up on estimate
- T+14 days: Value email
- T+30 days: Check-in
- T+60 days: Final nurture
