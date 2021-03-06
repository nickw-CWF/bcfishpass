-- calculate DCI for Elk River system below Elko dam - calculate both metrics, potadramous and diadromous/andradamos


-- get total stream lengths for DCI_a
WITH lengths_a AS
(SELECT
    SUM(ST_Length(geom)) FILTER (WHERE accessibility_model_wct = 'ACCESSIBLE') as length_accessible,
    SUM(ST_Length(geom)) FILTER (WHERE accessibility_model_wct IN ('POTENTIALLY ACCESSIBLE', 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM')) as length_inaccessible
  FROM bcfishpass.streams
  WHERE accessibility_model_wct IS NOT NULL
  AND wscode_ltree <@ '300.625474.584724'::ltree
  AND NOT FWA_Upstream(356570562, 22910, 22910, '300.625474.584724'::ltree, '300.625474.584724.100997'::ltree, blue_line_key, downstream_route_measure, wscode_ltree, localcode_ltree)
),

-- for DCI_p, find the lengths of each portion of stream between barriers/potential barriers
segments AS
(
  SELECT
    watershed_group_code,
    dnstr_barriers_anthropogenic,
    SUM(ST_Length(geom)) as length_segment
  FROM bcfishpass.streams
  WHERE accessibility_model_wct IS NOT NULL
  AND wscode_ltree <@ '300.625474.584724'::ltree
  AND NOT FWA_Upstream(356570562, 22910, 22910, '300.625474.584724'::ltree, '300.625474.584724.100997'::ltree, blue_line_key, downstream_route_measure, wscode_ltree, localcode_ltree) -- below Elko Dam
  GROUP BY watershed_group_code, dnstr_barriers_anthropogenic
),

-- find the total length of all segments selected above
totals AS
(
  SELECT
   watershed_group_code,
   sum(length_segment) as length_total
  FROM segments
  GROUP BY watershed_group_code
),

-- calculate DCI_p
dci_p AS
(
SELECT
  t.watershed_group_code,
  ROUND(SUM((s.length_segment * s.length_segment) / (t.length_total * t.length_total))::numeric, 4) as dci_p
FROM segments s
INNER JOIN totals t
ON s.watershed_Group_code = t.watershed_group_code
GROUP BY t.watershed_group_code
),

-- dci_a
dci_a AS
(
SELECT
 round((length_accessible / (length_accessible + length_inaccessible))::numeric, 4) as dci_a
FROM lengths_a)

SELECT
  a.dci_a,
  p.dci_p
FROM dci_a a, dci_p p