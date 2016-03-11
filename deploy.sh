#!/bin/sh
set -e
openssl aes-256-cbc -K $encrypted_dde8a6eeaa7c_key -iv $encrypted_dde8a6eeaa7c_iv -in config.json.enc -out config.json -d

(cd data; node cartodb_sql.js -f global_functions.sql)
# generalizations are not updated - they could take considerable time
node create_named.js positron-all.yml light_all
node create_named.js positron-no-labels.yml light_nolabels
node create_named.js positron-labels-only.yml light_only_labels
node create_named.js dark-matter-all.yml dark_all
node create_named.js dark-matter-no-labels.yml dark_nolabels
node create_named.js dark-matter-labels-only.yml dark_only_labels
