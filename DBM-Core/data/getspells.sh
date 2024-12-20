#!/bin/bash

cd "$(dirname "$0")"

# curl 'https://wago.tools/db2/SpellName/csv?product=wow_classic_era_ptr'

# product=wow_classic_era_ptr is borked
mkdir -p cache/classic_era
curl 'https://wago.tools/db2/SpellName/csv?product=wow_classic_era_ptr' > cache/classic_era/SpellName.csv

mkdir -p cache/retail
curl 'https://wago.tools/db2/SpellName/csv?product=wowt' > cache/retail/SpellName.csv
