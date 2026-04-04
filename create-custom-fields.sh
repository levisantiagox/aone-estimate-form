#!/bin/bash
# Create all 23 GHL custom fields for A-One Fencing Instant Estimate Form

# Load secrets from .env file
source "$(dirname "$0")/.env"
API_KEY="$GHL_API_KEY"
BASE_URL="https://services.leadconnectorhq.com/locations/${LOCATION_ID:-9H8ikOJT1S3b1d5ETdIK}/customFields"

create_field() {
  local name="$1"
  local key="$2"
  local dataType="$3"
  shift 3
  local options=("$@")

  local json=""
  if [ ${#options[@]} -gt 0 ]; then
    local opts_json=""
    for opt in "${options[@]}"; do
      if [ -n "$opts_json" ]; then opts_json+=","; fi
      opts_json+="\"$opt\""
    done
    json="{\"name\":\"$name\",\"dataType\":\"$dataType\",\"options\":[$opts_json]}"
  else
    json="{\"name\":\"$name\",\"dataType\":\"$dataType\"}"
  fi

  local response
  response=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL" \
    -H "Authorization: Bearer $API_KEY" \
    -H "Version: 2021-07-28" \
    -H "Content-Type: application/json" \
    -d "$json")

  local http_code=$(echo "$response" | tail -1)
  local body=$(echo "$response" | head -n -1)

  if [ "$http_code" = "200" ] || [ "$http_code" = "201" ]; then
    echo "OK  [$http_code] $name"
  else
    echo "ERR [$http_code] $name -> $body"
  fi
}

echo "=== Creating 23 Custom Fields in A-One Fencing GHL ==="
echo ""

# 1. Property Type
create_field "Property Type" "property_type" "SINGLE_OPTIONS" \
  "Residential" "Commercial" "Strata / Body Corporate" "Rural / Acreage"

# 2. Property Owner Status
create_field "Property Owner Status" "property_owner_status" "SINGLE_OPTIONS" \
  "Yes" "No, I am a tenant" "I am a builder / developer"

# 3. Service Types Requested
create_field "Service Types Requested" "service_types_requested" "MULTIPLE_OPTIONS" \
  "New fence installation" "New gate installation" "Pool fencing (glass)" "Shower screens"

# 4. Fence Material
create_field "Fence Material" "fence_material" "SINGLE_OPTIONS" \
  "Colorbond" "PVC" "Timber" "Aluminium (standard)" "Not sure yet"

# 5. Fence Height
create_field "Fence Height" "fence_height" "SINGLE_OPTIONS" \
  "1.2m (4 foot)" "1.5m (5 foot)" "1.8m (6 foot) - Most common" "2.1m (7 foot)" "Not sure yet"

# 6. Fence Length Range
create_field "Fence Length Range" "fence_length_range" "SINGLE_OPTIONS" \
  "Under 10 metres" "10 - 20 metres" "20 - 40 metres" "40 - 60 metres" "60 - 100 metres" "100+ metres" "Not sure"

# 7. Existing Fence Removal
create_field "Existing Fence Removal" "existing_fence_removal" "SINGLE_OPTIONS" \
  "Yes, existing fence needs full removal" "Yes, partial removal needed" "No existing fence" "Not sure"

# 8. Gate Type
create_field "Gate Type" "gate_type" "SINGLE_OPTIONS" \
  "Pedestrian gate (single)" "Double gate" "Sliding gate" "Swing gate (automated)" "Electric / motorised gate" "Not sure yet"

# 9. Gate Material
create_field "Gate Material" "gate_material" "SINGLE_OPTIONS" \
  "Colorbond" "Aluminium" "Timber" "Match my fence" "Not sure yet"

# 10. Number of Gates
create_field "Number of Gates" "number_of_gates" "SINGLE_OPTIONS" \
  "1" "2" "3+"

# 11. Pool Fence Type
create_field "Pool Fence Type" "pool_fence_type" "SINGLE_OPTIONS" \
  "Frameless glass" "Semi-frameless glass" "Aluminium pool fencing" "Not sure yet"

# 12. Pool Fence Length Range
create_field "Pool Fence Length Range" "pool_fence_length_range" "SINGLE_OPTIONS" \
  "Under 10 metres" "10 - 15 metres" "15 - 25 metres" "25+ metres" "Not sure"

# 13. Pool Status
create_field "Pool Status" "pool_status" "SINGLE_OPTIONS" \
  "Existing pool" "New pool under construction" "Planning / design stage"

# 14. Council Compliance Required
create_field "Council Compliance Required" "council_compliance_required" "SINGLE_OPTIONS" \
  "Yes" "No" "Not sure"

# 15. Shower Screen Type
create_field "Shower Screen Type" "shower_screen_type" "SINGLE_OPTIONS" \
  "Frameless" "Semi-frameless" "Framed" "Not sure yet"

# 16. Shower Screen Configuration
create_field "Shower Screen Configuration" "shower_screen_configuration" "SINGLE_OPTIONS" \
  "Single fixed panel" "Single door" "Door + fixed panel" "Corner entry (2 doors)" "Bath screen" "Not sure"

# 17. Number of Shower Screens
create_field "Number of Shower Screens" "number_of_shower_screens" "SINGLE_OPTIONS" \
  "1" "2" "3+"

# 18. Ground Conditions
create_field "Ground Conditions" "ground_conditions" "SINGLE_OPTIONS" \
  "Flat" "Slight slope" "Steep slope" "Rocky or hard ground" "Sandy or soft ground" "Not sure"

# 19. Site Access Difficulty
create_field "Site Access Difficulty" "site_access_difficulty" "SINGLE_OPTIONS" \
  "Easy (clear driveway or open yard)" "Moderate (side access, some obstacles)" "Difficult (rear access only, narrow paths)" "Not sure"

# 20. Council/Boundary Considerations
create_field "Council Boundary Considerations" "council_boundary_considerations" "SINGLE_OPTIONS" \
  "No" "Yes, boundary dispute" "Yes, council approval needed" "Yes, heritage overlay or restrictions" "Not sure"

# 21. Project Timeline
create_field "Project Timeline" "project_timeline" "SINGLE_OPTIONS" \
  "ASAP" "Within 2 weeks" "Within 1-2 months" "3+ months" "Just exploring options"

# 22. Lead Source
create_field "Lead Source" "lead_source" "SINGLE_OPTIONS" \
  "Google search" "Facebook / Instagram" "Recommendation from a friend" "Seen our work in the area" "Other"

# 23. Additional Notes
create_field "Additional Notes" "additional_notes" "LARGE_TEXT"

echo ""
echo "=== Done ==="
