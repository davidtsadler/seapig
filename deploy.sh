#!/usr/bin/env bash

# GZIP files.
find dist -type f \( -iname '*.xml' -or -iname '*.txt' -or -iname '*.css' -or -iname '*.js' -or -iname '*.html' \) -exec gzip "{}" \; -exec mv "{}.gz" "{}" \;

# CSS (Cache: 1 week)
s3cmd sync --acl-public --exclude '*.*' --include '*.css' -m "text/css" --add-header="Cache-Control: max-age=604800" --add-header="Content-Encoding: gzip" --add-header="Vary: Accept-Encoding" dist/css/ s3://seapig.net/css/

# HTML (Cache: 1 week)
s3cmd sync --acl-public --exclude '*.*' --include  '*.html' -m "text/html" --add-header="Cache-Control: max-age=604800, must-revalidate" --add-header="Content-Encoding: gzip" --add-header="Vary: Accept-Encoding" dist/ s3://seapig.net/

# Sitemap.xml (Cache: 1 week)
s3cmd sync --acl-public --exclude '*.*' --include  'sitemap.xml' -m "application/xml" --add-header="Cache-Control: max-age=604800, must-revalidate" --add-header="Content-Encoding: gzip" --add-header="Vary: Accept-Encoding" dist/ s3://seapig.net/

# Robots.txt (Cache: 10 weeks)
s3cmd sync --acl-public --exclude '*.*' --include 'robots.txt' -m "text/plain" --add-header="Cache-Control: max-age=6048000" --add-header="Content-Encoding: gzip" --add-header="Vary: Accept-Encoding" dist/ s3://seapig.net/

# Sync: remaining files & delete removed
s3cmd sync --acl-public --delete-removed  dist/ s3://seapig.net/
