-- Find rearing downstream of spawning
-- Rearing streams/wetlands must be connected (to some degree) to spawning streams of the same spp,
-- so rearing model is applied per species to make connectivity/clustering straightforward

-- CHINOOK
WITH rearing AS
(
  SELECT
    s.segmented_stream_id,
    s.geom
  FROM bcfishpass.streams s
  INNER JOIN bcfishpass.param_watersheds wsg
  ON s.watershed_group_code = wsg.watershed_group_code
  LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
  ON s.waterbody_key = wb.waterbody_key
  LEFT OUTER JOIN foundry.fwa_streams_mad mad
  ON s.linear_feature_id = mad.linear_feature_id
  LEFT OUTER JOIN bcfishpass.param_habitat h
  ON h.species_code = 'CH'
  WHERE
    s.accessibility_model_salmon IS NOT NULL AND  -- accessibility check
    s.gradient <= h.rear_gradient_max AND         -- gradient check
    ( wb.waterbody_type = 'R' OR                  -- only apply to streams/rivers
      ( wb.waterbody_type IS NULL AND
        s.edge_type IN (1000,1100,2000,2300)
      )
    ) AND

    (
      ( -- channel width based model
        wsg.model = 'cw' AND
        s.channel_width <= h.rear_channel_width_max
      )
    OR
      ( -- discharge based model
        wsg.model = 'mad' AND
        mad.mad_m3s > h.rear_mad_min AND
        mad.mad_m3s <= h.rear_mad_max
      )
    )
),

-- cluster/aggregate
rearing_clusters as
(
  SELECT
    segmented_stream_id,
    ST_ClusterDBSCAN(geom, 1, 1) over() as cid,
    geom
  FROM rearing
  ORDER BY segmented_stream_id
),

-- find all rearing downstream of spawning and get distinct cluster ids present
rearing_clusters_dnstr AS
(
  SELECT DISTINCT cid
  FROM rearing_clusters rc
  INNER JOIN bcfishpass.streams s
  ON rc.segmented_stream_id = s.segmented_stream_id
  INNER JOIN bcfishpass.streams spawn
  ON FWA_Upstream(s.blue_line_key, s.downstream_route_measure, s.wscode_ltree, s.localcode_ltree, spawn.blue_line_key, spawn.downstream_route_measure, spawn.wscode_ltree, spawn.localcode_ltree)
  AND s.watershed_group_code = spawn.watershed_group_code
  WHERE spawn.spawning_model_chinook IS TRUE
),

-- find ids of streams that compose the above clusters
rearing_ids AS
(
  SELECT
    a.segmented_stream_id
  FROM rearing_clusters a
  INNER JOIN rearing_clusters_dnstr b
  ON a.cid = b.cid
)

-- and finally, apply update based on these ids
UPDATE bcfishpass.streams s
SET rearing_model_chinook = TRUE
WHERE segmented_stream_id IN (SELECT segmented_stream_id FROM rearing_ids);


-- ----------------------------------------------
-- COHO
WITH rearing AS
(
  SELECT
    s.segmented_stream_id,
    s.geom
  FROM bcfishpass.streams s
  INNER JOIN bcfishpass.param_watersheds wsg
  ON s.watershed_group_code = wsg.watershed_group_code
  LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
  ON s.waterbody_key = wb.waterbody_key
  LEFT OUTER JOIN foundry.fwa_streams_mad mad
  ON s.linear_feature_id = mad.linear_feature_id
  LEFT OUTER JOIN bcfishpass.param_habitat h
  ON h.species_code = 'CO'
  WHERE
    s.accessibility_model_salmon IS NOT NULL AND  -- accessibility check
    s.gradient <= h.rear_gradient_max AND         -- gradient check
    ( wb.waterbody_type = 'R' OR                  -- only apply to streams/rivers/wetlands
      ( wb.waterbody_type IS NULL OR
        s.edge_type IN (1000,1100,2000,2300,1050,1150)
      )
    ) AND

    (
      ( -- channel width based model
        wsg.model = 'cw' AND
        s.channel_width <= h.rear_channel_width_max
      )
    OR
      ( -- discharge based model
        wsg.model = 'mad' AND
        mad.mad_m3s > h.rear_mad_min AND
        mad.mad_m3s <= h.rear_mad_max
      )
    OR s.edge_type IN (1050, 1150)  -- any wetlands are potential rearing
    )
),

-- cluster/aggregate
rearing_clusters as
(
  SELECT
    segmented_stream_id,
    ST_ClusterDBSCAN(geom, 1, 1) over() as cid,
    geom
  FROM rearing
  ORDER BY segmented_stream_id
),

-- find all rearing downstream of spawning and get distinct cluster ids present
rearing_clusters_dnstr AS
(
  SELECT DISTINCT cid
  FROM rearing_clusters rc
  INNER JOIN bcfishpass.streams s
  ON rc.segmented_stream_id = s.segmented_stream_id
  INNER JOIN bcfishpass.streams spawn
  ON FWA_Upstream(s.blue_line_key, s.downstream_route_measure, s.wscode_ltree, s.localcode_ltree, spawn.blue_line_key, spawn.downstream_route_measure, spawn.wscode_ltree, spawn.localcode_ltree)
  AND s.watershed_group_code = spawn.watershed_group_code
  WHERE spawn.spawning_model_coho IS TRUE
),

-- find ids of streams that compose the above clusters
rearing_ids AS
(
  SELECT
    a.segmented_stream_id
  FROM rearing_clusters a
  INNER JOIN rearing_clusters_dnstr b
  ON a.cid = b.cid
)

-- and finally, apply update based on these ids
UPDATE bcfishpass.streams s
SET rearing_model_coho = TRUE
WHERE segmented_stream_id IN (SELECT segmented_stream_id FROM rearing_ids);



-- ----------------------------------------------
-- STEELHEAD
WITH rearing AS
(
  SELECT
    s.segmented_stream_id,
    s.geom
  FROM bcfishpass.streams s
  INNER JOIN bcfishpass.param_watersheds wsg
  ON s.watershed_group_code = wsg.watershed_group_code
  LEFT OUTER JOIN whse_basemapping.fwa_waterbodies wb
  ON s.waterbody_key = wb.waterbody_key
  LEFT OUTER JOIN foundry.fwa_streams_mad mad
  ON s.linear_feature_id = mad.linear_feature_id
  LEFT OUTER JOIN bcfishpass.param_habitat h
  ON h.species_code = 'ST'
  WHERE
    s.accessibility_model_steelhead IS NOT NULL AND  -- accessibility check
    s.gradient <= h.rear_gradient_max AND         -- gradient check
    ( wb.waterbody_type = 'R' OR                  -- only apply to streams/rivers
      ( wb.waterbody_type IS NULL OR
        s.edge_type IN (1000,1100,2000,2300)
      )
    ) AND

    (
      ( -- channel width based model
        wsg.model = 'cw' AND
        s.channel_width <= h.rear_channel_width_max
      )
    OR
      ( -- discharge based model
        wsg.model = 'mad' AND
        mad.mad_m3s > h.rear_mad_min AND
        mad.mad_m3s <= h.rear_mad_max
      )
    )
),

-- cluster/aggregate
rearing_clusters as
(
  SELECT
    segmented_stream_id,
    ST_ClusterDBSCAN(geom, 1, 1) over() as cid,
    geom
  FROM rearing
  ORDER BY segmented_stream_id
),

-- find all rearing downstream of spawning and get distinct cluster ids present
rearing_clusters_dnstr AS
(
  SELECT DISTINCT cid
  FROM rearing_clusters rc
  INNER JOIN bcfishpass.streams s
  ON rc.segmented_stream_id = s.segmented_stream_id
  INNER JOIN bcfishpass.streams spawn
  ON FWA_Upstream(s.blue_line_key, s.downstream_route_measure, s.wscode_ltree, s.localcode_ltree, spawn.blue_line_key, spawn.downstream_route_measure, spawn.wscode_ltree, spawn.localcode_ltree)
  AND s.watershed_group_code = spawn.watershed_group_code
  WHERE spawn.spawning_model_steelhead IS TRUE
),

-- find ids of streams that compose the above clusters
rearing_ids AS
(
  SELECT
    a.segmented_stream_id
  FROM rearing_clusters a
  INNER JOIN rearing_clusters_dnstr b
  ON a.cid = b.cid
)

-- and finally, apply update based on these ids
UPDATE bcfishpass.streams s
SET rearing_model_steelhead = TRUE
WHERE segmented_stream_id IN (SELECT segmented_stream_id FROM rearing_ids);