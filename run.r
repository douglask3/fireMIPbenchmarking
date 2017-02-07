source('cfg.r')

comparisonList <- named.list(GFED4.Season, GFED4.IA, GFED4.Spatial)
#comparisonList <- named.list(GPP, GFED4.IA, GFED4.Spatial, GFED4.Season)

runComparisons(comparisonList)
