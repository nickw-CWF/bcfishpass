-- for crossings, report on belowupstrbarriers categories is a bit different because the table has a mix of barriers/non-barriers
-- run it separately here.
WITH report AS
(SELECT
  a.aggregated_crossings_id,
  ROUND(COALESCE((a.total_network_km - SUM(b.total_network_km)), 0)::numeric, 2) total_belowupstrbarriers_network_km,
  ROUND(COALESCE((a.total_stream_km - SUM(b.total_stream_km)), 0)::numeric, 2) total_belowupstrbarriers_stream_km,
  ROUND(COALESCE((a.total_lakereservoir_ha - SUM(b.total_lakereservoir_ha)), 0)::numeric, 2) total_belowupstrbarriers_lakereservoir_ha,
  ROUND(COALESCE((a.total_wetland_ha - SUM(b.total_wetland_ha)), 0)::numeric, 2) total_belowupstrbarriers_wetland_ha,
  ROUND(COALESCE((a.total_slopeclass03_waterbodies_km - SUM(b.total_slopeclass03_waterbodies_km)), 0)::numeric, 2) total_belowupstrbarriers_slopeclass03_waterbodies_km,
  ROUND(COALESCE((a.total_slopeclass03_km - SUM(b.total_slopeclass03_km)), 0)::numeric, 2) total_belowupstrbarriers_slopeclass03_km,
  ROUND(COALESCE((a.total_slopeclass05_km - SUM(b.total_slopeclass05_km)), 0)::numeric, 2) total_belowupstrbarriers_slopeclass05_km,
  ROUND(COALESCE((a.total_slopeclass08_km - SUM(b.total_slopeclass08_km)), 0)::numeric, 2) total_belowupstrbarriers_slopeclass08_km,
  ROUND(COALESCE((a.total_slopeclass15_km - SUM(b.total_slopeclass15_km)), 0)::numeric, 2) total_belowupstrbarriers_slopeclass15_km,
  ROUND(COALESCE((a.total_slopeclass22_km - SUM(b.total_slopeclass22_km)), 0)::numeric, 2) total_belowupstrbarriers_slopeclass22_km,
  ROUND(COALESCE((a.total_slopeclass30_km - SUM(b.total_slopeclass30_km)), 0)::numeric, 2) total_belowupstrbarriers_slopeclass30_km,
  ROUND(COALESCE((a.salmon_network_km - SUM(b.salmon_network_km)), 0)::numeric, 2) salmon_belowupstrbarriers_network_km,
  ROUND(COALESCE((a.salmon_stream_km - SUM(b.salmon_stream_km)), 0)::numeric, 2) salmon_belowupstrbarriers_stream_km,
  ROUND(COALESCE((a.salmon_lakereservoir_ha - SUM(b.salmon_lakereservoir_ha)), 0)::numeric, 2) salmon_belowupstrbarriers_lakereservoir_ha,
  ROUND(COALESCE((a.salmon_wetland_ha - SUM(b.salmon_wetland_ha)), 0)::numeric, 2) salmon_belowupstrbarriers_wetland_ha,
  ROUND(COALESCE((a.salmon_slopeclass03_waterbodies_km - SUM(b.salmon_slopeclass03_waterbodies_km)), 0)::numeric, 2) salmon_belowupstrbarriers_slopeclass03_waterbodies_km,
  ROUND(COALESCE((a.salmon_slopeclass03_km - SUM(b.salmon_slopeclass03_km)), 0)::numeric, 2) salmon_belowupstrbarriers_slopeclass03_km,
  ROUND(COALESCE((a.salmon_slopeclass05_km - SUM(b.salmon_slopeclass05_km)), 0)::numeric, 2) salmon_belowupstrbarriers_slopeclass05_km,
  ROUND(COALESCE((a.salmon_slopeclass08_km - SUM(b.salmon_slopeclass08_km)), 0)::numeric, 2) salmon_belowupstrbarriers_slopeclass08_km,
  ROUND(COALESCE((a.salmon_slopeclass15_km - SUM(b.salmon_slopeclass15_km)), 0)::numeric, 2) salmon_belowupstrbarriers_slopeclass15_km,
  ROUND(COALESCE((a.salmon_slopeclass22_km - SUM(b.salmon_slopeclass22_km)), 0)::numeric, 2) salmon_belowupstrbarriers_slopeclass22_km,
  ROUND(COALESCE((a.salmon_slopeclass30_km - SUM(b.salmon_slopeclass30_km)), 0)::numeric, 2) salmon_belowupstrbarriers_slopeclass30_km,
  ROUND(COALESCE((a.steelhead_network_km - SUM(b.steelhead_network_km)), 0)::numeric, 2) steelhead_belowupstrbarriers_network_km,
  ROUND(COALESCE((a.steelhead_stream_km - SUM(b.steelhead_stream_km)), 0)::numeric, 2) steelhead_belowupstrbarriers_stream_km,
  ROUND(COALESCE((a.steelhead_lakereservoir_ha - SUM(b.steelhead_lakereservoir_ha)), 0)::numeric, 2) steelhead_belowupstrbarriers_lakereservoir_ha,
  ROUND(COALESCE((a.steelhead_wetland_ha - SUM(b.steelhead_wetland_ha)), 0)::numeric, 2) steelhead_belowupstrbarriers_wetland_ha,
  ROUND(COALESCE((a.steelhead_slopeclass03_km - SUM(b.steelhead_slopeclass03_km)), 0)::numeric, 2) steelhead_belowupstrbarriers_slopeclass03_km,
  ROUND(COALESCE((a.steelhead_slopeclass05_km - SUM(b.steelhead_slopeclass05_km)), 0)::numeric, 2) steelhead_belowupstrbarriers_slopeclass05_km,
  ROUND(COALESCE((a.steelhead_slopeclass08_km - SUM(b.steelhead_slopeclass08_km)), 0)::numeric, 2) steelhead_belowupstrbarriers_slopeclass08_km,
  ROUND(COALESCE((a.steelhead_slopeclass15_km - SUM(b.steelhead_slopeclass15_km)), 0)::numeric, 2) steelhead_belowupstrbarriers_slopeclass15_km,
  ROUND(COALESCE((a.steelhead_slopeclass22_km - SUM(b.steelhead_slopeclass22_km)), 0)::numeric, 2) steelhead_belowupstrbarriers_slopeclass22_km,
  ROUND(COALESCE((a.steelhead_slopeclass30_km - SUM(b.steelhead_slopeclass30_km)), 0)::numeric, 2) steelhead_belowupstrbarriers_slopeclass30_km,
  ROUND(COALESCE((a.wct_network_km - SUM(b.wct_network_km)), 0)::numeric, 2) wct_belowupstrbarriers_network_km,
  ROUND(COALESCE((a.wct_stream_km - SUM(b.wct_stream_km)), 0)::numeric, 2) wct_belowupstrbarriers_stream_km,
  ROUND(COALESCE((a.wct_lakereservoir_ha - SUM(b.wct_lakereservoir_ha)), 0)::numeric, 2) wct_belowupstrbarriers_lakereservoir_ha,
  ROUND(COALESCE((a.wct_wetland_ha - SUM(b.wct_wetland_ha)), 0)::numeric, 2) wct_belowupstrbarriers_wetland_ha,
  ROUND(COALESCE((a.wct_slopeclass03_km - SUM(b.wct_slopeclass03_km)), 0)::numeric, 2) wct_belowupstrbarriers_slopeclass03_km,
  ROUND(COALESCE((a.wct_slopeclass05_km - SUM(b.wct_slopeclass05_km)), 0)::numeric, 2) wct_belowupstrbarriers_slopeclass05_km,
  ROUND(COALESCE((a.wct_slopeclass08_km - SUM(b.wct_slopeclass08_km)), 0)::numeric, 2) wct_belowupstrbarriers_slopeclass08_km,
  ROUND(COALESCE((a.wct_slopeclass15_km - SUM(b.wct_slopeclass15_km)), 0)::numeric, 2) wct_belowupstrbarriers_slopeclass15_km,
  ROUND(COALESCE((a.wct_slopeclass22_km - SUM(b.wct_slopeclass22_km)), 0)::numeric, 2) wct_belowupstrbarriers_slopeclass22_km,
  ROUND(COALESCE((a.wct_slopeclass30_km - SUM(b.wct_slopeclass30_km)), 0)::numeric, 2) wct_belowupstrbarriers_slopeclass30_km
FROM bcfishpass.crossings a
INNER JOIN bcfishpass.crossings b
ON a.aggregated_crossings_id = b.dnstr_crossings[1]
WHERE b.barrier_status IN ('BARRIER', 'POTENTIAL')
GROUP BY a.aggregated_crossings_id
)

UPDATE bcfishpass.crossings p
SET
  total_belowupstrbarriers_network_km = r.total_belowupstrbarriers_network_km,
  total_belowupstrbarriers_stream_km = r.total_belowupstrbarriers_stream_km,
  total_belowupstrbarriers_lakereservoir_ha = r.total_belowupstrbarriers_lakereservoir_ha,
  total_belowupstrbarriers_wetland_ha = r.total_belowupstrbarriers_wetland_ha,
  total_belowupstrbarriers_slopeclass03_waterbodies_km = r.total_belowupstrbarriers_slopeclass03_waterbodies_km,
  total_belowupstrbarriers_slopeclass03_km = r.total_belowupstrbarriers_slopeclass03_km,
  total_belowupstrbarriers_slopeclass05_km = r.total_belowupstrbarriers_slopeclass05_km,
  total_belowupstrbarriers_slopeclass08_km = r.total_belowupstrbarriers_slopeclass08_km,
  total_belowupstrbarriers_slopeclass15_km = r.total_belowupstrbarriers_slopeclass15_km,
  total_belowupstrbarriers_slopeclass22_km = r.total_belowupstrbarriers_slopeclass22_km,
  total_belowupstrbarriers_slopeclass30_km = r.total_belowupstrbarriers_slopeclass30_km,
  salmon_belowupstrbarriers_network_km = r.salmon_belowupstrbarriers_network_km,
  salmon_belowupstrbarriers_stream_km = r.salmon_belowupstrbarriers_stream_km,
  salmon_belowupstrbarriers_lakereservoir_ha = r.salmon_belowupstrbarriers_lakereservoir_ha,
  salmon_belowupstrbarriers_wetland_ha = r.salmon_belowupstrbarriers_wetland_ha,
  salmon_belowupstrbarriers_slopeclass03_waterbodies_km = r.salmon_belowupstrbarriers_slopeclass03_waterbodies_km,
  salmon_belowupstrbarriers_slopeclass03_km = r.salmon_belowupstrbarriers_slopeclass03_km,
  salmon_belowupstrbarriers_slopeclass05_km = r.salmon_belowupstrbarriers_slopeclass05_km,
  salmon_belowupstrbarriers_slopeclass08_km = r.salmon_belowupstrbarriers_slopeclass08_km,
  salmon_belowupstrbarriers_slopeclass15_km = r.salmon_belowupstrbarriers_slopeclass15_km,
  salmon_belowupstrbarriers_slopeclass22_km = r.salmon_belowupstrbarriers_slopeclass22_km,
  salmon_belowupstrbarriers_slopeclass30_km = r.salmon_belowupstrbarriers_slopeclass30_km,
  steelhead_belowupstrbarriers_network_km = r.steelhead_belowupstrbarriers_network_km,
  steelhead_belowupstrbarriers_stream_km = r.steelhead_belowupstrbarriers_stream_km,
  steelhead_belowupstrbarriers_lakereservoir_ha = r.steelhead_belowupstrbarriers_lakereservoir_ha,
  steelhead_belowupstrbarriers_wetland_ha = r.steelhead_belowupstrbarriers_wetland_ha,
  steelhead_belowupstrbarriers_slopeclass03_km = r.steelhead_belowupstrbarriers_slopeclass03_km,
  steelhead_belowupstrbarriers_slopeclass05_km = r.steelhead_belowupstrbarriers_slopeclass05_km,
  steelhead_belowupstrbarriers_slopeclass08_km = r.steelhead_belowupstrbarriers_slopeclass08_km,
  steelhead_belowupstrbarriers_slopeclass15_km = r.steelhead_belowupstrbarriers_slopeclass15_km,
  steelhead_belowupstrbarriers_slopeclass22_km = r.steelhead_belowupstrbarriers_slopeclass22_km,
  steelhead_belowupstrbarriers_slopeclass30_km = r.steelhead_belowupstrbarriers_slopeclass30_km,
  wct_belowupstrbarriers_network_km = r.wct_belowupstrbarriers_network_km,
  wct_belowupstrbarriers_stream_km = r.wct_belowupstrbarriers_stream_km,
  wct_belowupstrbarriers_lakereservoir_ha = r.wct_belowupstrbarriers_lakereservoir_ha,
  wct_belowupstrbarriers_wetland_ha = r.wct_belowupstrbarriers_wetland_ha,
  wct_belowupstrbarriers_slopeclass03_km = r.wct_belowupstrbarriers_slopeclass03_km,
  wct_belowupstrbarriers_slopeclass05_km = r.wct_belowupstrbarriers_slopeclass05_km,
  wct_belowupstrbarriers_slopeclass08_km = r.wct_belowupstrbarriers_slopeclass08_km,
  wct_belowupstrbarriers_slopeclass15_km = r.wct_belowupstrbarriers_slopeclass15_km,
  wct_belowupstrbarriers_slopeclass22_km = r.wct_belowupstrbarriers_slopeclass22_km,
  wct_belowupstrbarriers_slopeclass30_km = r.wct_belowupstrbarriers_slopeclass30_km
FROM report r
WHERE p.aggregated_crossings_id = r.aggregated_crossings_id;