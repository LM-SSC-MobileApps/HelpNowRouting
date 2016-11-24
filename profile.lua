-------------------------------
-- At the top of the profile --
-------------------------------
-- Loads blocked loads lua file downloaded from helpnow into the profile for use in the node_function

require("blocked_nodes");


-----------------------------------
-- Add before the nopde_function --
-----------------------------------
-- These helper functions use haversine distance to compare the node to the blocked nodes. 
function distance_m (lat1, lon1, lat2, lon2)
  local lat1r = lat1 * 0.0174532925199433
  local lat2r = lat2 * 0.0174532925199433
  local lon1r = lon1 * 0.0174532925199433
  local lon2r = lon2 * 0.0174532925199433

  local dlon = lon2r - lon1r
  local dlat = lat2r - lat1r

  local a = (math.sin(dlat / 2.0) * math.sin(dlat / 2.0)) + math.cos(lat1r) * math.cos(lat2r) * (math.sin(dlon / 2.0) * math.sin(dlon / 2.0))
  local c = 2.0 * math.asin(math.min(1, math.sqrt(a)))
  return 6371000 * c
end

function check_blocked_node(lat, lon, result)
  for i,v in ipairs(blocked_nodes) do
    if distance_m(v["lat"], v["lon"], lat, lon) < 100 then
      result.barrier = true
      return
    end
  end
end

---------------------------------
-- in node_function at the top --
---------------------------------
-- Uses the helper functions to compute if this node is blocked, if so exit early

  local lat = node:location():lat()
  local lon = node:location():lon()
  check_blocked_node(lat, lon, result)
  if result.barrier == true then
    return
  end
