curl https://epistat.sciensano.be/Data/COVID19BE_HOSP.json | jq 'reduce .[] as $pair ({}; .[$pair.DATE].in += $pair.NEW_IN | .[$pair.DATE].out += $pair.NEW_OUT | .[$pair.DATE].delta += $pair.NEW_IN - $pair.NEW_OUT )' > data_hospital.json

curl https://epistat.sciensano.be/Data/COVID19BE_MORT.json | jq 'map(select(.DATE >= "2020-03-15")) | reduce .[] as $pair ({}; .[$pair.DATE].deceased += $pair.DEATHS)' > data_deceased.json

jq -n 'reduce inputs as $i ({}; . * $i)' data_hospital.json data_deceased.json > data.json

mv data.json html
rm data_hospital.json data_deceased.json
