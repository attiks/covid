curl https://epistat.sciensano.be/Data/COVID19BE_HOSP.json | jq 'reduce .[] as $pair ({}; .[$pair.DATE].total_in += $pair.TOTAL_IN | .[$pair.DATE].total_icu += $pair.TOTAL_IN_ICU | .[$pair.DATE].total_resp += $pair.TOTAL_IN_RESP | .[$pair.DATE].in += $pair.NEW_IN | .[$pair.DATE].out += $pair.NEW_OUT | .[$pair.DATE].delta += $pair.NEW_IN - $pair.NEW_OUT )' > data_hospital.json

curl https://epistat.sciensano.be/Data/COVID19BE_MORT.json | jq 'map(select(.DATE >= "2020-03-15")) | reduce .[] as $pair ({}; .[$pair.DATE].deceased += $pair.DEATHS)' > data_deceased.json

curl https://epistat.sciensano.be/Data/COVID19BE_CASES_AGESEX.json | jq 'map(select(.DATE >= "2020-03-15")) | reduce .[] as $pair ({}; .[$pair.DATE].infected += $pair.CASES)' > data_infected.json

curl https://epistat.sciensano.be/Data/COVID19BE_tests.json | jq 'map(select(.DATE >= "2020-03-15")) | reduce .[] as $pair ({}; .[$pair.DATE].tests += $pair.TESTS)' > data_tests.json

jq -n 'reduce inputs as $i ({}; . * $i)' data_hospital.json data_deceased.json > data_1.json
jq -n 'reduce inputs as $i ({}; . * $i)' data_1.json data_infected.json > data_2.json
jq -n 'reduce inputs as $i ({}; . * $i)' data_2.json data_tests.json > data.json

mv data.json docs
rm data_*.json
